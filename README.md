# Macroeconomic Time Series Analysis

## Overview

This project investigates the dynamic relationships among key U.S. macroeconomic indicators using modern time series econometric techniques.

The analysis focuses on modeling the interaction between Real GDP, inflation, and monetary policy while demonstrating a complete empirical workflow including data acquisition, preprocessing, stationarity testing, model estimation, forecasting, and diagnostic evaluation.

The project was implemented in **R** as part of an applied econometrics assignment and has been reorganized into a reproducible GitHub repository.

---

## Objectives

The analysis includes:

- Collection of macroeconomic time series
- Exploratory time series visualization
- Stationarity testing (ADF)
- Time series transformation
- VAR model estimation
- Lag order selection
- Impulse Response Functions (IRFs)
- Forecast Error Variance Decomposition (FEVD)
- Granger causality analysis
- Model diagnostics
- Economic interpretation of results

---

## Repository Structure

```
.
├── data/
│   ├── FEDFUNDS.csv
│   ├── GDPC1.csv
│   └── GDPCTPI.csv
│
├── notebooks/
│   └── macroeconomic_time_series_analysis.ipynb
│
├── code/
│   └── analysis.R
│
├── results/
│   └── IRF_3x3_BIC_model.png
│
├── docs/
│   ├── assignment.pdf
│   └── report.pdf
│
└── README.md
```

---

## Data

The empirical analysis uses three U.S. macroeconomic time series:

- Real Gross Domestic Product (GDPC1)
- GDP Price Index (GDPCTPI)
- Effective Federal Funds Rate (FEDFUNDS)

These series were originally obtained from publicly available economic databases and are **not redistributed in this repository**.

---

## Methods

The project applies several standard econometric techniques commonly used in empirical macroeconomics:

- Time series visualization
- Unit root testing
- Stationarity transformations
- Vector Autoregression (VAR)
- Lag selection using information criteria
- Granger causality tests
- Impulse Response Functions
- Forecast Error Variance Decomposition
- Residual diagnostics
- Economic interpretation

---

## Technologies

- R
- vars
- urca
- tseries
- forecast
- ggplot2
- tidyverse

---

## Reproducibility

Run the complete analysis with:

```r
source("code/analysis.R")
```

The script reproduces all preprocessing, model estimation, diagnostics, and figures used throughout the project.

> **Note**
>
> The original data files are not included in this repository.
> If the required macroeconomic series are unavailable locally, they should be downloaded from their original public sources before executing the analysis.

---

## Project Highlights

- Complete macroeconomic time series workflow
- Vector Autoregression (VAR) modeling
- Dynamic causal analysis using IRFs and FEVD
- Granger causality testing
- Forecasting and model diagnostics
- Fully documented empirical analysis

---

## Author

**Konstantinos Papavrontos**
