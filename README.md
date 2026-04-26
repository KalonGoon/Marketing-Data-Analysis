# Marketing Campaign Data Analysis
> Analyzed 174,226 rows of digital marketing campaign data using R — evaluating creative performance, campaign efficiency, CPA, CVR, and time-period trends across 10 ad creatives and 3 campaign types.

---

## 📌 Project Summary

This was a take-home analytics test analyzing a real marketing dataset. The goal was to answer 7 business questions about ad creative performance, campaign efficiency, and seasonality trends using R.

**Key findings:**
- 🎨 **10 creative versions** were run across 5 colors (Black, Grey, Orange, Teal, White) in standard and new variants
- 📈 **New creatives generated marginally more clicks** (mean 93.63) vs standard (mean 92.99) — Grey\*\*new showed the largest individual improvement
- 💰 **Conversion campaigns drove 5,483,600 conversions** — nearly 4x more than Brand (1,381,526) or Fan Acquisitions (1,381,300)
- 📊 **CPA ranged from ~$18.69 to ~$19.84** across campaign types — sc_BBY_NOLA_branding had the lowest CPA at $18.69
- 📆 **CVR spikes every 3rd month** (March, June, September, December) — suggesting seasonal patterns worth modeling with ARIMA
- 🔁 **Impressions follow a 2-high, 1-low monthly pattern** — average impressions dip below 95,000 every 3rd month vs a baseline of 103,782

> ⚠️ *Dataset is proprietary. Only the R code and analysis report are included in this repo.*

---

## 🗂️ Repository Structure

```
Marketing-Data-Analysis/
│
├── README.md
├── TakeHomeTest_Code_File.R    # Full R analysis code
└── Data_Analysis_Report.pdf   # Written findings and visualizations
```

---

## 🛠️ Tools & Skills Used

| Tool | Purpose |
|------|---------|
| R | All analysis and visualizations |
| tidyverse / dplyr | Data manipulation and filtering |
| ggplot2 | Bar charts and trend visualizations |
| readxl | Importing Excel dataset |
| lubridate / xts | Time series handling |

**R concepts demonstrated:**
- Data cleaning and column standardization (`tidy_names`, `tolower`)
- Filtering and grouping with `dplyr` (`filter`, `group_by`, `summarise`)
- String pattern matching with `grepl`
- Custom metric calculations (CPA, CVR)
- Side-by-side `ggplot2` visualizations with `gridExtra`
- Time series trend analysis across monthly dimensions

---

## 🔍 Analysis Questions Answered

### Q1 — How many versions of creative were run?
**10 versions** across 5 colors in standard and new variants: Black, Black\*\*new, Grey, Grey\*\*new, Orange, Orange\*\*new, Teal, Teal\*\*new, White, White\*\*new.

### Q2 — Did new creatives have any effect?
New creatives showed a **marginally higher mean for clicks and impressions** but no significant overall effect on conversions. Grey\*\*new was the standout — showing meaningful improvement in both clicks and impressions relative to standard Grey.

### Q3 — CPA and CVR by campaign type
- **CPA** = Total Spend / Total Conversions — ranged from **$18.69 to $19.84**
- **CVR** = (Conversions / Impressions) × 100 — exported per campaign

### Q4 — Which campaign type drove the most conversions?

| Campaign Type | Sum of Conversions | Mean Conversions |
|---|---|---|
| Conversion | **5,483,600** | 94.37 |
| Brand | 1,381,526 | 23.80 |
| Fan Acquisitions | 1,381,300 | 23.78 |

Conversion campaigns generated **~70 more conversions on average** than Brand or Fan Acquisition campaigns.

### Q5 — Are there time period trends?
- **Spend:** Stable at ~$467/month with negligible variation
- **Impressions:** Follow a 2-high, 1-low pattern — dip below 95,000 every 3rd month
- **Clicks:** Stable at ~92–93/month with no seasonal signal
- **Conversions:** Marginally lower in March and June, correlated with impression dips
- **CVR:** Spikes above 0.0510% every 3rd month (March, June, September, December) — suggests quarterly seasonality. ARIMA modelling recommended for deeper forecasting.

### Q6 — Creative colors run in February?
8 creatives: Black, Black\*\*new, Orange, Orange\*\*new, Teal, Teal\*\*new, White, White\*\*new

### Q7 — What questions would you ask to project next month's CPA?
1. What is the spend budget for next month?
2. Will the client maintain the same conversion-heavy campaign split?
3. What month is it — slow month or fast month based on seasonal trends?
4. Is it a peak demand period for this product?
5. Is a competitor entering the market?
6. What is current consumer demand like — stagnant, growing, or expanding?
7. What is general market sentiment around this product?

---

## 💼 Key Takeaways

- **Conversion campaigns are the clear winner** — 4x more conversions than other types at similar CPA
- **Grey\*\*new is the best performing creative update** — significant improvement over its standard version
- **Quarterly seasonality in CVR** is a real pattern worth building a forecasting model around
- **New vs standard creatives showed minimal aggregate difference** — individual creative color matters more than the new/standard split

---
*This project was completed as a take-home data analysis test. Dataset also included.
