# Daraz Pakistan: E-Commerce Data Analytics Portfolio Project
### End-to-End Business Intelligence and Predictive Modeling (2024 - 2026)

---

## 1. Project Overview & Business Problem

Daraz is the leading e-commerce platform in Pakistan. Despite strong top-line growth (YTD Revenue up **18.2%** to PKR 542M), leadership identified critical concerns: slowing customer retention, high return-to-sender (RTS) rates on Cash on Delivery orders, and logistics SLA breaches.

This portfolio project builds a complete end-to-end data pipeline and analytical solution to diagnose operational leakage, forecast revenue, classify customer churn, and deliver executive-ready Power BI dashboard mockups.

---

## 2. Repository Structure

This repository is structured as a professional consulting package:

```text
Project/
│
├── Data/
│   ├── processed/
│   │   ├── customers_cleaned.csv        # Cleaned demographic profiles
│   │   ├── products_cleaned.csv         # Cleaned product parameters
│   │   ├── orders_cleaned.csv           # Cleaned order lines
│   │   ├── order_items_cleaned.csv      # Order transaction details
│   │   ├── deliveries_cleaned.csv       # Delivery courier performance log
│   │   ├── marketing_campaigns_cleaned.csv # Ad performance metrics
│   │   ├── customer_rfm.csv             # Computed RFM segments & ML churn probs
│   │   └── revenue_forecast.csv         # Holt-Winters 6-month predictions
│   └── daraz_pakistan.db                # Populated SQLite Database file
│
├── SQL/
│   ├── schema.sql                       # Database schema and indexes
│   ├── 01_beginner_queries.sql          # SQL Queries 1 - 25
│   ├── 02_intermediate_queries.sql      # SQL Queries 26 - 50
│   └── 03_advanced_queries.sql          # SQL Queries 51 - 75
│
├── Python/
│   ├── generate_data.py                 # Reproducible data generator script
│   ├── 01_data_cleaning.py              # Data cleaning and prep pipeline
│   ├── 02_exploratory_data_analysis.py  # Statistical summaries and EDA
│   ├── 03_business_analysis.py          # Cohorts, RFM, CLV computations
│   ├── 04_forecasting.py                # Time series forecasting models
│   └── 05_churn_prediction.py           # Random Forest churn classification
│
├── PowerBI/
│   ├── daraz_theme.json                 # Professional custom theme JSON
│   ├── dax_measures.dax                 # Library of 30 advanced measures
│   ├── wireframes.md                    # Layout wireframes for all 5 pages
│   └── dashboard_architecture.md        # Technical UX guide & design diagram
│
├── Reports/
│   ├── business_insights.md             # 30 Insights, 20 Recs, 10 Decisions
│   ├── diagnostic_analytics.md          # Root cause analysis investigation
│   └── prescriptive_strategy.md         # Playbook for growth and retention
│
├── Presentation/
│   └── executive_presentation.md        # 10-Slide presentation deck outline
│
├── Interview_Prep/
│   └── interview_handbook.md            # Walkthroughs & 210 Q&A handbook
│
├── README.md                            # Project overview & walkthrough
├── requirements.txt                     # Python packages list
├── run_pipeline.py                      # Master pipeline execution script
└── verify_sql.py                        # SQL database and query verifier
```

---

## 3. Database Modeling & Star Schema

The database model is configured as a clean **Star Schema** to optimize visual execution and memory usage inside the Power BI semantic layer.

```text
               +--------------------+
               |   Dim_Customers    |
               | (customer_id - PK) |
               +---------+----------+
                         | 1
                         |
                         | N
+-------------------+    |     +------------------+
|   Dim_Products    +----+-----+    Fact_Orders   |
|  (product_id - PK)| 1  | N   |  (order_id - PK) |
+---------+---------+    |     +--------+---------+
          | 1            |              | 1
          |              |              |
          | N            |              | 1
+---------+---------+    |     +--------+---------+
|  Fact_Order_Items +----+     |  Fact_Deliveries |
| (order_item_id-PK)|          | (delivery_id-PK) |
+-------------------+          +------------------+
```

### Table Dictionary
*   `customers`: Customer profiles, signup channels, age groups, and churn flags.
*   `products`: Product specifications, selling price, cost price, and gross markup.
*   `orders`: Orders placed, total order values, discount totals, and final order status.
*   `order_items`: Line-item quantity, net margins, and discount rates.
*   `deliveries`: Transit times, courier details, SLA statuses, and customer ratings.
*   `marketing_campaigns`: Ad channel expenditures, clicks, conversions, and ROAS.

---

## 4. Key Project Findings & Churn Model

1.  **First-Order Experience**: Customers experiencing delivery delays on order 1 churn at a rate of **50%**, compared to **20%** for on-time deliveries.
2.  **Returns Surcharge**: COD represents **65%** of transactions but has an **18.2% return rate**, costing Daraz PKR 1.2M in shipping fees.
3.  **Transit Rating Cliff**: Customer ratings drop from **4.8 to 1.8 stars** when transit times exceed 4 days in Tier 1 cities.
4.  **Churn Model**: Our Python Random Forest classifier predicts churn with **93% classification accuracy** (ROC-AUC **0.98**).

---

## 5. Strategic Playbook & Impact

*   **Action 1**: Enforce a flat **PKR 50 convenience fee** on COD checkouts and partner with Easypaisa/JazzCash to run **5% prepayment cashbacks** to shift payment share to prepaid channels.
*   **Action 2**: Prioritize first orders in DEX logistics lanes to protect the first impression.
*   **Action 3**: Audit Leopard Courier performance; reduce remote volume allocations by 50%.
*   **Business Impact**: Reduce baseline churn to **<30%** and recover **PKR 12.4M** in double-shipping return costs.

---

## 6. Execution Instructions

To execute the data pipeline and populate the SQL database:

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/your-username/daraz-pakistan-analytics.git
    cd daraz-pakistan-analytics
    ```
2.  **Install Python Dependencies**:
    ```bash
    pip install -r requirements.txt
    ```
3.  **Run Pipeline**: Execute the master python pipeline script to clean datasets, run time series forecasting, and generate the churn models:
    ```bash
    python run_pipeline.py
    ```
4.  **Verify SQL Queries**: Compile the SQLite database and verify that all 75 analytical SQL queries execute without syntax errors:
    ```bash
    python verify_sql.py
    ```
