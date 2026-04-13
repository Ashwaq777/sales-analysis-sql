# Sales Performance Analysis — Superstore

## Project Overview
Advanced SQL analysis of 9,994 sales transactions from a US retail company 
to identify revenue drivers, profitability issues, and customer segments.

**Business Question:**
> "Which products, customers, and regions drive the most profit — 
> and what is killing our margins?"

---

## 📁 Dataset
- **Source:** [Superstore Dataset — Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)
- **Size:** 9,994 transactions × 19 features
- **Period:** 2014 — 2017

---

## Tools & Skills
- PostgreSQL, pgAdmin
- Window Functions (RANK, LAG, NTILE)
- CTEs (Common Table Expressions)
- RFM Customer Segmentation
- Business KPIs & Profitability Analysis

---

## Key Findings

### 1. Overall Business Performance
| Metric | Value |
|---|---|
| Total Orders | 5,009 |
| Total Customers | 793 |
| Total Revenue | $2,297,201 |
| Total Profit | $286,397 |
| Avg Discount | 15.62% |

### 2. Category Performance
| Category | Revenue | Profit | Margin |
|---|---|---|---|
| Technology | $836,154 | $145,455 | 17.4% ✅ |
| Furniture | $741,999 | $18,451 | 2.49% 🚨 |
| Office Supplies | $719,046 | $122,490 | 17.04% ✅ |

### 3. Discount is Killing Profits 🚨
| Discount Level | Avg Profit | Margin |
|---|---|---|
| No Discount | $66.90 | 29.51% ✅ |
| Low 0-20% | $26.50 | 11.91% |
| Medium 20-40% | -$77.86 | -15.30% 🔴 |
| High 40%+ | -$106.71 | -77.40% 🔴 |

### 4. Top Regions
| Region | State | Profit | Margin |
|---|---|---|---|
| West | California | $76,381 | 16.69% |
| East | New York | $74,038 | 23.82% |
| West | Washington | $33,402 | 24.09% |

### 5. RFM Customer Segmentation
- **Champions** — Recent, frequent, high spenders → Retain & reward
- **Loyal** — Good customers → Upsell opportunities  
- **At Risk** — Declining activity → Re-engagement campaigns
- **Lost** — Inactive customers → Win-back or ignore

---

## Business Recommendations
1. **Stop high discounts immediately** — anything above 20% loses money
2. **Investigate Furniture margins** — 2.49% is unsustainable
3. **Focus on Champion customers** — they drive disproportionate value
4. **Expand in New York** — best margin efficiency in the dataset
5. **Review Sean Miller account** — #1 revenue but unprofitable

---

## Project Structure
sales-analysis-sql/
├── analysis.sql          # All 9 SQL queries
├── superstore_utf8.csv   # Dataset
└── README.md             # This file