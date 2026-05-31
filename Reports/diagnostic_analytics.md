# Diagnostic Analytics Report: Root Cause Investigation
**Company: Daraz Pakistan (E-Commerce)**
**Author: Senior Analytics Consultant**

This report answers **"Why did it happen?"** by investigating the root causes of our key business leakage points: revenue fluctuations, profit decline, customer churn, marketing inefficiencies, and operational bottlenecks.

---

## 1. Revenue Fluctuations: Post-Mega Campaign Hangovers

### 1.1 Observation
GMV drops by **45%** in December and January immediately following the November 11.11 and Blessed Friday Mega Campaigns.

### 1.2 Root Cause Analysis
1.  **Demand Forwarding**: Mega campaigns pull forward future purchases. Customers delay buying high-value electronics in September/October or accelerate purchases planned for December/January to take advantage of November deals.
2.  **Post-Campaign Fatigue**: Marketing budgets are exhausted in November, leading to a **70% reduction in advertising spend** in December. This directly reduces traffic and conversions.
3.  **Stockouts**: High-velocity SKUs (like smartphones and beauty bundles) sell out completely in November, leaving the digital shelves empty or causing long fulfillment delays in December.

---

## 2. Profit Margin Leakage: Stacking Discounts and Returned Orders

### 1.1 Observation
Net profit margin fell to **<8%** on heavily promoted electronics items, despite high revenue volumes.

### 1.2 Root Cause Analysis
1.  **Discount Stacking**: The checkout system allowed customers to combine product discounts with campaign vouchers and payment gateway discounts. This led to cumulative discount rates exceeding **30%**, which eroded the gross margins of high-cost electronics.
2.  **High Cash on Delivery (COD) Returns**: Returned items generate double logistics costs (shipping and return fees), which are absorbed entirely by Daraz. A return rate of **18%** on COD orders effectively wiped out the profit margins of these sales.
3.  **Low Basket Value Processing Cost**: Low-value orders (<2,000 PKR) carry fixed sorting and packaging costs. These processing expenses represent a high percentage of the order value, diluting overall profitability.

---

## 3. Customer Churn: Logistics Delays and Poor First Impressions

### 1.1 Observation
Customer churn stands at an executive-level warning rate of **47.5%**.

### 1.2 Root Cause Analysis
1.  **SLA Breaches on First Orders**: First-time buyers who experienced transit delays > 4 days churned at **50%**. A poor first delivery experience permanently damages customer trust.
2.  **The "Late Delivery SLA Cliff"**: Delivery satisfaction ratings drop from **4.8 to 1.8** stars when delivery times exceed 4 days in Tier 1 cities. Delayed packages directly drive customer churn.
3.  **Lack of Proactive Communication**: Customers whose deliveries were delayed received no updates, leading to anxiety, delivery rejection upon arrival, and eventual customer churn.

---

## 4. Operational Bottlenecks: Third-Party Courier Failure

### 1.1 Observation
Average transit times are elevated in KPK and Balochistan, and SLA breaches occur in **30%** of deliveries handled by Leopard Courier.

### 1.2 Root Cause Analysis
1.  **Last-Mile Courier Constraints**: Third-party couriers like Leopards Courier do not have sufficient vehicle networks or staff in remote districts. This leads to packages piling up at sorting hubs.
2.  **COD Rejections**: Couriers prioritised prepaid orders over COD orders because COD requires physical cash collection, which takes more time and adds safety risks for riders.
3.  **DEX Network Limits**: In-house Daraz Express (DEX) hubs are limited to Karachi, Lahore, and Islamabad/Rawalpindi. Remote areas are completely dependent on less efficient third-party networks.

---

## 5. Marketing Inefficiencies: High-CAC Paid Channels

### 1.1 Observation
Blended ROAS has declined, and Customer Acquisition Cost (CAC) on Facebook Ads is **46% higher** than on TikTok Ads.

### 1.2 Root Cause Analysis
1.  **Ad Fatigue and Bid Inflation**: Facebook ad auctions have become highly competitive, driving up CPMs. Additionally, creative asset fatigue reduces ad click-through rates (CTR).
2.  **Targeting Inefficiencies**: Facebook campaigns were set up with broad targeting, reaching demographics that did not have payment methods like credit cards, leading to checkout page exits.
3.  **SMS Marketing Under-utilization**: Although SMS marketing yields a high ROAS, it was treated as a mass broadcast tool rather than a segmented retargeting engine, resulting in brand fatigue.
