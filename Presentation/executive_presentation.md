# Daraz Pakistan: E-Commerce Growth and Operations Presentation
**Executive Slide Deck for C-Suite Leadership**
**Prepared by: Senior Data Analytics Team**

---

## SLIDE 1: Title Slide & Executive Summary
### Re-imagining Daraz Pakistan's Growth, Operations, and Customer Retention

*   **Subtitle**: A Data-Driven Roadmap to Reduce Churn and Recover Margins (2024–2026)
*   **The Bottom Line**: YTD Revenue grew by **18.2%** to PKR 542M. However, customer churn stands at **47.5%**, driven by logistics delays (Leopards delay rate of 40%) and high COD order returns (18.2%). By implementing our prescriptive strategy, we can reduce churn to under 30% and save PKR 12.4M annually in fulfillment costs.
*   *Speaker Notes*: "Good morning team. Today we are presenting a comprehensive analysis of Daraz Pakistan's operations over the last two years. While our top-line revenue shows solid growth, we are experiencing significant leaks in customer retention and profitability. We will cover the data-driven root causes and outline our strategy to recover these margins."

---

## SLIDE 2: The Business Problem
### Slowing Retention, Rising Returns, and Logistics SLA Breaches

*   **Key Issues**:
    *   **High Customer Churn**: Churn stands at **47.5%**, indicating low customer loyalty.
    *   **COD Returns**: COD accounts for 65% of orders but experiences a **18.2% return-to-sender (RTS) rate**, eroding gross margins.
    *   **Logistics Failures**: Third-party courier partners breach delivery SLA targets in **30%** of remote deliveries.
*   **Business Goal**: Identify high-value growth levers, optimize marketing spend, reduce shipping returns, and build a predictive early-warning churn model.
*   *Speaker Notes*: "Our core problems are retention and operational leakage. We are acquiring users, but half of them leave. Furthermore, Cash on Delivery checkouts are causing massive return rates, and our logistics partners are failing to meet delivery SLAs. Let's look at how we structured the data to diagnose these issues."

---

## SLIDE 3: Data Modeling & Schema
### Star Schema Architecture for High-Performance Analytics

*   **Data Structure**:
    *   **Fact Tables**: `Fact_Orders` (8,604 rows), `Fact_Order_Items` (13,787 rows), `Fact_Deliveries` (8,410 rows).
    *   **Dimension Tables**: `Dim_Customers` (2,500 rows), `Dim_Products` (42 rows), `Dim_Marketing_Campaigns` (53 rows).
    *   **Derived Columns**: Age groups, monthly revenue forecast, and machine learning churn probabilities.
*   **Relationships**: 1:N relations mapped to optimize Power BI tabular engine performance.
*   *Speaker Notes*: "We built a clean Star Schema database in SQL. By separating dimensions like Customers and Products from transactional facts, we optimized query execution times and built a robust semantic model for our Power BI dashboard."

---

## SLIDE 4: Methodology & Analytical Toolkit
### How We Derived Insights From Raw Transactions

*   **Tooling Stack**:
    *   **SQL Database Engine**: SQLite/PostgreSQL used for writing 75 queries (aggregations, CTEs, Window functions).
    *   **Python Pipelines**: Pandas and NumPy for cleaning; Matplotlib/Seaborn for EDA.
    *   **Time Series Forecasting**: Holt-Winters Exponential Smoothing fitted on monthly revenue index.
    *   **Machine Learning**: Scikit-Learn Random Forest Classifier trained to predict customer churn (ROC-AUC: **0.98**).
*   *Speaker Notes*: "We didn't just look at static reports. We ran 75 distinct analytical queries in SQL, built a Python cleaning pipeline, and trained a Random Forest model to predict churn with 98% accuracy. We also utilized Holt-Winters to forecast monthly revenue."

---

## SLIDE 5: Key Finding 1: Customer Segmentation & Cohorts
### Identifying Our Profit Engines and Retention Leakage

*   **RFM Segmentation**:
    *   **Champions**: 505 customers who drive **48% of net profit**.
    *   **Loyal Customers**: 407 customers who buy regularly.
    *   **At Risk / Slipping**: 384 customers showing declining activity.
*   **Cohort Retention Analysis**:
    *   Month 1 retention drops sharply by **35%** on average.
    *   *Conclusion*: We are failing to engage customers immediately after signup.
*   *Speaker Notes*: "The RFM segmentation shows a classic Pareto principle: 20% of our customer base, our Champions, drive nearly half of our profits. However, looking at the cohort heatmap, we see a massive leakage point: 35% of signups never make a second purchase. This points to a weak onboarding experience."

---

## SLIDE 6: Key Finding 2: Logistics SLA Performance
### The High Cost of Delivery Delays

*   **DEX vs Third-Party Couriers**:
    *   **Daraz Express (DEX)**: 1.8 days average transit time; **2.1% SLA breach rate**.
    *   **TCS**: 3.5 days average transit time; **8.5% SLA breach rate**.
    *   **Leopard Courier**: 5.2 days average transit time; **30.0% SLA breach rate**; 26.4% return rate.
*   **The SLA Cliff**: Customer satisfaction ratings fall from **4.8 to 1.8 stars** when delivery exceeds 4 days in Tier 1 cities.
*   *Speaker Notes*: "Our in-house delivery network, DEX, is highly efficient. In contrast, Leopard Courier is a major bottleneck, with a 30% SLA breach rate. More critically, our scatterplot shows a satisfaction cliff: ratings drop to 1.8 stars when deliveries take longer than 4 days. This directly causes churn."

---

## SLIDE 7: Key Finding 3: Predictive Churn Analysis
### What Drives Customers to Leave?

*   **Top Churn Drivers (Random Forest Feature Importances)**:
    1.  **Recency** (Days since last order) - Highest predictor.
    2.  **Late Delivery Rate** - Key operational trigger.
    3.  **Average Delivery Rating** - Satisfaction benchmark.
*   **The "First Impression" Rule**:
    *   Customers experiencing a delay on order 1 churn at **50%**, compared to **20%** for on-time deliveries.
*   *Speaker Notes*: "Our Random Forest model highlights that besides recency, late delivery rates are the primary operational drivers of churn. Specifically, if a customer's very first order is delayed, they have a 50/50 chance of never ordering again. Delivery speed on the first purchase is critical."

---

## SLIDE 8: Predictive Analytics: Revenue Forecast
### Forecasting Q3/Q4 Sales Volume

*   **Holt-Winters Model Results (Next 6 Months)**:
    *   **June 2026**: PKR 27.2M
    *   **July 2026**: PKR 30.0M
    *   **August 2026**: PKR 33.3M
    *   **September 2026**: PKR 35.4M
    *   **October 2026**: PKR 39.2M
    *   **November 2026 (11.11 Forecast)**: **PKR 50.7M** (Seasonal peak)
*   **Opportunity**: Anticipate seasonality to prevent stockouts of top-selling categories.
*   *Speaker Notes*: "Our Holt-Winters forecasting model predicts steady revenue recovery, peaking at PKR 50.7M in November for the 11.11 sale. We must use these predictions to pre-arrange financing and secure warehouse inventory levels."

---

## SLIDE 9: Prescriptive Action Plan
### Actionable Steps to Improve Profitability and Loyalty

*   **Logistics Optimization**:
    *   Move KPK/Punjab remote volume from Leopard to TCS; enforce SLA delay penalties (20% delivery charge refund).
    *   Tag first-time buyers' orders for priority DEX lanes.
*   **Prepayment Push**:
    *   Enforce a flat PKR 50 convenience fee on COD.
    *   Offer 5% cashback via Easypaisa/JazzCash to shift COD checkouts.
*   **Targeted Reactivation**:
    *   Send automated push discounts to users with model churn probability > 70%.
*   *Speaker Notes*: "Our recommendations are clear. First, tag first-time buyers for priority shipping. Second, push prepaid payments with mobile wallet cashbacks and introduce a COD fee. Third, automate reactivation ads to users flagged by our machine learning model."

---

## SLIDE 10: Expected Business Impact
### Projected Financial and Operational Returns

*   **Churn Reduction**: Drop churn rate from **47.5% to <30%** within 12 months.
*   **Return Reduction**: Reduce COD return-to-sender (RTS) rate from **18.2% to <10%**, saving **PKR 12.4M** in wasted double-shipping courier fees.
*   **Fulfillment Speed**: Increase Tier-1 SLA compliance from **88.5% to 96%** through DEX lane prioritization.
*   *Speaker Notes*: "By executing this playbook, we target a reduction in customer churn to under 30% and expect to recover PKR 12.4M in logistics costs by lowering COD returns. Thank you, and I am open to any questions."
