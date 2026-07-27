# Macroeconomic Time Series Analysis

## Overview

This project investigates the dynamic effects of U.S. monetary policy on real economic activity and inflation using a Structural Vector Autoregression (SVAR).

Quarterly macroeconomic data are obtained from the Federal Reserve Economic Data (FRED) database and transformed into a multivariate time series framework. The analysis estimates a recursively identified VAR model, evaluates its statistical properties, and examines the dynamic responses of output, inflation, and interest rates through impulse response functions.

The project demonstrates a complete empirical workflow for macroeconomic time series analysis, including data preparation, model estimation, diagnostic testing, structural identification, and robustness validation.

---

## Project Objectives

- Prepare quarterly U.S. macroeconomic time series
- Transform variables for VAR estimation
- Select the optimal lag order using statistical criteria
- Estimate a Structural Vector Autoregression (SVAR)
- Evaluate model stability and residual diagnostics
- Analyze monetary policy transmission using impulse response functions
- Validate lag selection through rolling-origin cross-validation

---

## Repository Structure

```text
.
├── code/
│   └── analysis.R
│
├── data/
│   ├── GDPC1.csv
│   ├── GDPCTPI.csv
│   └── FEDFUNDS.csv
│
├── notebooks/
│   └── macroeconomic_time_series_analysis.ipynb
│
├── docs/
│   ├── assignment.pdf
│   └── report.pdf
│
├── results/
│   └── IRF_3x3_BIC_model.png
│
├── README.md
├── LICENSE
└── .gitignore
```

---

## Data

The analysis uses quarterly U.S. macroeconomic data from the Federal Reserve Economic Data (FRED) database:

- **GDPC1** – Real Gross Domestic Product
- **GDPCTPI** – GDP Price Index
- **FEDFUNDS** – Effective Federal Funds Rate

Real GDP and the GDP Price Index are transformed into quarter-over-quarter log differences, while the Federal Funds Rate is used in levels, following the project specification.

---

## Methodology

The empirical analysis follows these steps:

1. Data acquisition and preprocessing
2. Variable transformation
3. Lag order selection (BIC)
4. Vector Autoregression estimation
5. Model stability and diagnostic testing
6. Recursive (Cholesky) structural identification
7. Impulse response analysis
8. Rolling-origin cross-validation as a robustness check

---

## Main Findings

The estimated VAR(1) model suggests that:

- Monetary policy responds systematically to changes in output growth and inflation.
- Contractionary monetary policy shocks produce a modest negative response in output growth.
- Inflation exhibits the well-known **price puzzle**, a common result in recursively identified monetary policy VAR models.
- Both the Bayesian Information Criterion (BIC) and rolling-origin cross-validation select the same lag order, supporting the robustness of the empirical specification.

---

## Technologies

- R
- Vector Autoregression (VAR)
- Structural VAR (SVAR)
- FRED Macroeconomic Data
- forecast
- vars
- urca
- tseries
- ggplot2

---

## Reproducibility

Install the required R packages and run:

```r
source("code/analysis.R")
```

The script reproduces the complete empirical analysis, including model estimation, diagnostic tests, impulse response functions, and robustness checks.

Alternatively, the analysis can be explored interactively through the accompanying Jupyter notebook.

---

## Repository Contents

This repository includes:

- Complete R implementation
- Reproducible Jupyter notebook
- Project report
- Assignment description
- Input datasets
- Generated impulse response figures

---

## Author

**Konstantinos Papavrontos**
