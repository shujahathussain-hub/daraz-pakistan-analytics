# Power BI Dashboard Wireframes & UX Layout Spec
**Company: Daraz Pakistan**
**Theme Palette: Navy (#0B1F3A), Emerald Green (#00C853), Gold (#FFB300), Alert Red (#E53935), Soft Gray (#F5F7FA)**

This document details the visual layouts and structures of the 5 dashboard pages, simulating the layout using markdown grid formats.

---

## PAGE 1: EXECUTIVE OVERVIEW
*Purpose: Answer "What is the general health of the business?" in 30 seconds.*

```text
+--------------------------------------------------------------------------------------------------+
| [LOGO]   DARAZ PAKISTAN - EXECUTIVE BUSINESS DASHBOARD (MAY 2026)          [Filters: Date, Prov] |
+--------------------------------------------------------------------------------------------------+
|  [KPI CARD: Revenue]     [KPI CARD: Profit]       [KPI CARD: AOV]        [KPI CARD: Total Orders]|
|  PKR 542.4M (YoY +18%)   PKR 142.1M (Margin 26%)  PKR 4,320 (YoY +5%)    12,410 (Growth +12%)    |
+--------------------------------------------------------------------------------------------------+
| [VISUAL A: Monthly Revenue Trend]                | [VISUAL B: Pakistan Regional Sales Map]       |
| Line Chart: Historical Revenue vs 6-Month Holt-  | Fill Map showing Sales Volume by Province    |
| Winters Forecast. Green baseline, gold forecast. | Sindh (Karachi), Punjab (Lahore), KPK, Bal.   |
|                                                  | Color depth representing order volume density.|
|                                                  |                                               |
+--------------------------------------------------------------------------------------------------+
| [VISUAL C: Product Performance Leaders]          | [VISUAL D: AI SMART NARRATIVE PANEL]          |
| Top 5 Categories (Bar Chart):                    | Text: "Year-to-date GMV increased by 18.2%,   |
| 1. Mobiles & Tablets (PKR 184M)                  | driven by a 4.5x seasonal spike during the    |
| 2. Electronics (PKR 112M)                        | 11.11 Mega Campaign. However, gross margins   |
| 3. Fashion & Beauty (PKR 86M)                    | in Balochistan fell by 4.2% due to a 16.5%    |
| 4. Home & Living (PKR 54M)                       | delayed delivery rate from Leopards Courier." |
+--------------------------------------------------------------------------------------------------+
```

---

## PAGE 2: CUSTOMER INTELLIGENCE
*Purpose: Analyze "Who are our buyers, who is leaving, and how do we retain them?"*

```text
+--------------------------------------------------------------------------------------------------+
| [NAV BUTTONS: Overview | Customers | Sales | Marketing | Operations]        [Filters: Age, City] |
+--------------------------------------------------------------------------------------------------+
|  [KPI: Total Customers]  [KPI: Churn Rate]        [KPI: Dynamic CLV]     [KPI: Repeat Buyer Rate] |
|  2,500 Base              47.5% (Alert Red)        PKR 243,795            55.4% (Healthy Green)    |
+--------------------------------------------------------------------------------------------------+
| [VISUAL A: Customer RFM Segment Distribution]    | [VISUAL B: Cohort Retention Heatmap]          |
| Horizontal Bar Chart showing Customer Counts:    | Grid: Months since signup (M0 - M12) vs       |
| - Champions: 505                                 | Cohort Signup Months (Jan 24 - May 26).       |
| - Loyal Customers: 407                           | Color gradient of blue showing retention decay|
| - At Risk / Slipping: 384                        | over time. M1 retention drops to ~65% average |
| - Hibernating / Lost: 720                        | due to post-signup drop-offs.                 |
+--------------------------------------------------------------------------------------------------+
| [VISUAL C: Customer Churn Key Influencers]       | [VISUAL D: New vs Returning Customers GMV]    |
| Power BI AI Key Influencer Visual:               | Stacked Line Chart showing sales contribution |
| "What influences customer to churn = 1?"          | of first-time signups vs recurring loyal      |
| - Late Delivery Rate > 18% (Likelihood 2.4x)     | customer segments.                            |
| - Average Rating < 2.5 (Likelihood 3.1x)         |                                               |
+--------------------------------------------------------------------------------------------------+
```

---

## PAGE 3: SALES & CATEGORY INTELLIGENCE
*Purpose: Audit "What sells best, what is underperforming, and where is profit leaking?"*

```text
+--------------------------------------------------------------------------------------------------+
| [NAV BUTTONS: Overview | Customers | Sales | Marketing | Operations]        [Filters: Cat, Subcat] |
+--------------------------------------------------------------------------------------------------+
| [VISUAL A: Category Sales vs Net Profit Matrix]                                                  |
| Table/Matrix with Conditional Formatting Data Bars:                                              |
| Category          Sub-Category   Qty Sold   Gross GMV (PKR)   Net Profit (PKR)   Gross Margin %  |
| Mobiles & Tablets Smartphones    2,120      142,300,000       34,500,000         24.2%           |
|                   Accessories    4,500        8,500,000        3,800,000         44.7% (Green)   |
| Fashion & Beauty  Women's Wear   3,400       24,600,000        9,840,000         40.0%           |
| Groceries         Staples        8,200       12,400,000        1,860,000         15.0% (Red)     |
+--------------------------------------------------------------------------------------------------+
| [VISUAL B: Product Profit vs Margin Scatterplot] | [VISUAL C: Price Tier Contribution]           |
| Scatterplot: Y-Axis = Profit Margin %,           | Pie Chart showing Order Distribution by Price: |
| X-Axis = Qty Sold, Size = Sales Volume.           | - High Value (>10k PKR): 62% GMV share        |
| - Top-right: High volume, high margin (Hero)     | - Medium Value (2k-10k): 28% GMV share        |
| - Bottom-left: Low volume, low margin (Audits)   | - Low Value (<2k): 10% GMV share              |
+--------------------------------------------------------------------------------------------------+
```

---

## PAGE 4: MARKETING ANALYTICS
*Purpose: Optimize "Which marketing campaigns and channels deliver the highest ROI?"*

```text
+--------------------------------------------------------------------------------------------------+
| [NAV BUTTONS: Overview | Customers | Sales | Marketing | Operations]     [Filters: Campaign Month]|
+--------------------------------------------------------------------------------------------------+
|  [KPI: Marketing Spend]  [KPI: Conversions]       [KPI: Blended ROAS]    [KPI: Blended CAC]       |
|  PKR 14.2M               154,200                  3.12x (Ad Spend ROI)   PKR 92 per Conversion    |
+--------------------------------------------------------------------------------------------------+
| [VISUAL A: Campaign Spend vs Revenue (ROAS)]     | [VISUAL B: Channel Conversion Funnel]         |
| Combined Line and Clustered Column Chart:        | Funnel chart tracking channel efficacy:       |
| Columns: Marketing Spend by campaign.            | Impression -> Click -> Conversion             |
| Line: Revenue generated (PKR).                   | - Facebook Ads: High Volume, CPA PKR 110      |
| Highlights highest-performing seasonal campaigns.| - TikTok Ads: High CTR, CPA PKR 75            |
|                                                  | - Google Ads: High AOV, CPA PKR 95            |
+--------------------------------------------------------------------------------------------------+
| [VISUAL C: Channel Acquisition Efficiency Matrix]                                                 |
| Channel          Total Impressions   Total Clicks   CTR %    Conversions   Spend (PKR)   CAC (PKR)  |
| Facebook Ads     120,400,000         3,010,000      2.5%     90,300        9,930,000     110       |
| TikTok Ads        80,500,000         2,415,000      3.0%     72,450        5,433,750      75       |
| SMS Marketing     10,000,000           450,000      4.5%     18,000          450,000      25       |
+--------------------------------------------------------------------------------------------------+
```

---

## PAGE 5: OPERATIONS & LOGISTICS
*Purpose: Diagnose "Where are transit bottlenecks and which delivery networks need audit?"*

```text
+--------------------------------------------------------------------------------------------------+
| [NAV BUTTONS: Overview | Customers | Sales | Marketing | Operations]   [Filters: Courier Partner]|
+--------------------------------------------------------------------------------------------------+
|  [KPI: Avg Transit Time] [KPI: Delay Rate]        [KPI: Returned Rate]   [KPI: SLA Breach Rate]   |
|  3.12 Days               11.5% (Gold Alert)       12.8% (COD Driven)     8.4% of total shipments  |
+--------------------------------------------------------------------------------------------------+
| [VISUAL A: Delay Rate by Province & City]        | [VISUAL B: Delivery Ratings vs Transit Time]  |
| Matrix with conditional heat maps:               | Scatterplot showing correlations:             |
| Province    City         Delay Rate %            | X-Axis = Average Transit Days                 |
| Balochistan Quetta       24.2% (Red Alert)       Y-Axis = Customer Satisfaction Rating (1-5)     |
| KPK         Peshawar     18.5% (Red Alert)       Shows sharp drop-off: Rating drops from 4.8 to |
| Sindh       Karachi       4.5% (Green)           1.8 when transit time exceeds 4 days.           |
+--------------------------------------------------------------------------------------------------+
| [VISUAL C: Courier Partner Performance SLA Grid]                                                 |
| Courier Partner      Total Orders   Transit Time (Days)   Late Deliveries   SLA Breaches   Return % |
| Daraz Express (DEX)  5,240          1.8                   210 (4.0%)        110 (2.1%)     6.2%     |
| TCS                  2,100          3.5                   315 (15.0%)       180 (8.5%)    11.2%     |
| Leopard Courier      1,070          5.2                   428 (40.0%)       321 (30.0%)   26.4%     |
+--------------------------------------------------------------------------------------------------+
```
