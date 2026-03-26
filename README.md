# UTM Campaign Trend Analysis (SQL)

## Project Overview
This project analyzes marketing campaign performance over time using UTM parameters and SQL.

It focuses on monthly trends, performance changes, and campaign dynamics using time-series analysis techniques.

---

## Datasets
- `facebook_ads_basic_daily`
- `google_ads_basic_daily`

---

## Analysis Tasks

### 1. Data Preparation
- Combine Facebook Ads and Google Ads data using `UNION ALL`
- Clean and normalize data using `COALESCE`

### 2. Campaign Extraction
- Extract `utm_campaign` from URL parameters
- Normalize campaign naming

### 3. Monthly Aggregation
- Aggregate performance data by month and campaign
- Calculate key metrics:
  - Total Spend
  - Impressions
  - Clicks
  - Conversion Value
  - CTR, CPC, CPM, ROMI

### 4. Trend Analysis
- Use window functions (`LAG`) to calculate:
  - Month-over-month CPM change (%)
  - Month-over-month CTR change (%)
  - Month-over-month ROMI change (%)

---

## SQL Highlights
- `CTE` structure for modular transformations  
- `date_trunc` for time aggregation  
- `window functions (LAG)` for trend analysis  
- KPI calculations with safe division logic  
- Multi-source data integration  

---

## Tools Used
- PostgreSQL
- DBeaver

---

## Conclusion
This project demonstrates how SQL can be used not only for static analysis, but also for tracking performance trends over time and identifying changes in marketing efficiency.
