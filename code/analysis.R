# =============================================================
# Monetary Transmission and Propagation Mechanism
# Computational Econometrics — Y. Dendramis
# SVAR analysis of FFR -> GDP growth & Inflation
# =============================================================

# ---- 0. Packages ----
required_packages <- c("vars")
to_install <- required_packages[!required_packages %in% installed.packages()[, "Package"]]
if (length(to_install) > 0) install.packages(to_install)
library(vars)

# Set this to the folder containing GDPC1.csv, GDPCTPI.csv, FEDFUNDS.csv
# setwd("C:/Users/Κωνσταντίνος/Documents")

# ---- 1. Load raw data ----
gdp <- read.csv("GDPC1.csv")     # Real GDP, chained dollars (replacement for discontinued GDPC96)
pi  <- read.csv("GDPCTPI.csv")   # GDP chain-type price index
ff  <- read.csv("FEDFUNDS.csv")  # Fed funds rate, quarterly average

gdp$observation_date <- as.Date(gdp$observation_date)
pi$observation_date  <- as.Date(pi$observation_date)
ff$observation_date  <- as.Date(ff$observation_date)

ff <- ff[!is.na(ff$FEDFUNDS), ]  # drop incomplete current quarter, if present

# ---- 2. Merge on common quarters ----
df <- merge(gdp, pi, by = "observation_date")
df <- merge(df, ff, by = "observation_date")
df <- df[order(df$observation_date), ]
rownames(df) <- NULL

cat("Common sample:", as.character(min(df$observation_date)), "to",
    as.character(max(df$observation_date)), "| N =", nrow(df), "\n")

# ---- 3. Transformations (per assignment spec) ----
# Y1 = QoQ log-difference of real GDP, x100
# Y2 = QoQ log-difference of the GDP price index, x100
# Y3 = ffr in levels
df$Y1_gdp_growth <- c(NA, diff(log(df$GDPC1)))   * 100
df$Y2_inflation  <- c(NA, diff(log(df$GDPCTPI))) * 100
df$Y3_ffr        <- df$FEDFUNDS

df <- df[-1, ]  # drop first row (lost to differencing)
rownames(df) <- NULL

# ---- 4. Build the multivariate ts object ----
start_year <- as.numeric(format(df$observation_date[1], "%Y"))
start_qtr  <- (as.numeric(format(df$observation_date[1], "%m")) - 1) %/% 3 + 1

y <- ts(df[, c("Y1_gdp_growth", "Y2_inflation", "Y3_ffr")],
        start = c(start_year, start_qtr), frequency = 4)
colnames(y) <- c("GDP growth", "Inflation", "FFR")

plot(y, main = "Transformed series")

# ---- 5. Lag-order selection, p in {1,2,3}, via BIC (Schwarz) ----
lagsel <- VARselect(y, lag.max = 3, type = "const")
print(lagsel$criteria)
p_bic <- unname(lagsel$selection["SC(n)"])
cat("BIC-selected lag order: p =", p_bic, "\n")

# ---- 6. Estimate the reduced-form VAR(p_bic) ----
var_model <- VAR(y, p = p_bic, type = "const")
summary(var_model)

# ---- 7. Basic diagnostics ----
cat("Moduli of characteristic roots (should all be < 1 for stability):\n")
print(roots(var_model))

print(serial.test(var_model, lags.pt = 8, type = "PT.asymptotic"))

# ---- 8. Triangular (Cholesky) SVAR identification ----
# Ordering: GDP growth -> Inflation -> FFR
# FFR last => a monetary policy shock affects GDP/inflation only with a lag,
# while GDP/inflation shocks affect the FFR contemporaneously (Fed observes
# current conditions when setting rates).
irf_bic <- irf(var_model, n.ahead = 20, ortho = TRUE,
               boot = TRUE, ci = 0.95, runs = 500, seed = 123)

# ---- 9. 3x3 grid of IRF plots (rows = shock, columns = response) ----
# Names are pulled directly from the irf object (not hard-coded), since
# VAR()/irf() may silently rewrite column names containing spaces.
plot_irf_grid <- function(irf_obj, filename, col_line) {
  shocks <- names(irf_obj$irf)
  resps  <- colnames(irf_obj$irf[[1]])
  h      <- 0:(nrow(irf_obj$irf[[1]]) - 1)
  
  png(filename, width = 1100, height = 1100, res = 130)
  par(mfrow = c(3, 3), mar = c(4, 4, 3, 1))
  for (shock in shocks) {
    for (resp in resps) {
      point <- irf_obj$irf[[shock]][, resp]
      lower <- irf_obj$Lower[[shock]][, resp]
      upper <- irf_obj$Upper[[shock]][, resp]
      plot(h, point, type = "l", lwd = 2, col = col_line,
           ylim = range(c(lower, upper, 0)),
           xlab = "Quarters", ylab = resp,
           main = paste0("Shock: ", shock))
      lines(h, lower, lty = 2, col = "grey40")
      lines(h, upper, lty = 2, col = "grey40")
      abline(h = 0, col = "red", lty = 3)
    }
  }
  dev.off()
}

plot_irf_grid(irf_bic, "IRF_3x3_BIC_model.png", "steelblue4")
cat("Saved IRF_3x3_BIC_model.png\n")

# =============================================================
# 10. EXTRA CREDIT — Cross-validation for lag-order selection
# Rolling-origin, one-step-ahead forecast CV (compares p in {1,2,3})
# =============================================================
cv_lag_selection <- function(y, p_grid = 1:3, n_init = 80) {
  Tobs <- nrow(y)
  cv_sse <- matrix(NA, nrow = Tobs - n_init, ncol = length(p_grid))
  colnames(cv_sse) <- paste0("p", p_grid)
  
  for (j in seq_along(p_grid)) {
    p <- p_grid[j]
    for (t in n_init:(Tobs - 1)) {
      train <- y[1:t, ]
      mod <- tryCatch(VAR(train, p = p, type = "const"), error = function(e) NULL)
      if (is.null(mod)) next
      fc     <- predict(mod, n.ahead = 1)
      actual <- y[t + 1, ]
      pred   <- sapply(fc$fcst, function(x) x[1, "fcst"])
      err    <- actual - pred
      cv_sse[t - n_init + 1, j] <- sum(err^2)
    }
  }
  colMeans(cv_sse, na.rm = TRUE)
}

cv_mse <- cv_lag_selection(y, p_grid = 1:3, n_init = 80)
cat("Cross-validation mean squared forecast error by lag order:\n")
print(cv_mse)

p_cv <- as.numeric(sub("p", "", names(which.min(cv_mse))))
cat("CV-selected lag order: p =", p_cv, "\n")

if (p_cv != p_bic) {
  cat("CV and BIC disagree (BIC p =", p_bic, ", CV p =", p_cv,
      ") -- estimating the alternative model for comparison.\n")
  var_model_cv <- VAR(y, p = p_cv, type = "const")
  irf_cv <- irf(var_model_cv, n.ahead = 20, ortho = TRUE,
                boot = TRUE, ci = 0.95, runs = 500, seed = 123)
  plot_irf_grid(irf_cv, "IRF_3x3_CV_model.png", "darkorange3")
  cat("Saved IRF_3x3_CV_model.png -- compare visually with the BIC version.\n")
} else {
  cat("CV agrees with BIC on p =", p_bic, "-- no second model needed.\n")
}