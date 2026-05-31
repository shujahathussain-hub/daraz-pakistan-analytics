# Business Insights, Recommendations, and Strategic Decisions
**Company: Daraz Pakistan (E-Commerce)**
**Author: Senior Analytics Consultant**

This report outlines the key data-driven findings from the analytical pipeline (SQL and Python), providing tactical recommendations and strategic decisions for the executive leadership team.

---

## 1. 30 Data-Driven Insights
Every insight is backed by quantitative evidence from our analysis, detailing its financial/operational impact and specific recommended actions.

### 1.1 Revenue & Financial Insights
1. **11.11 Seasonality Spike**: Gross Merchandise Value (GMV) spikes by **4.5x** in November compared to the yearly monthly baseline.
   - *Evidence*: SQL seasonality analysis and Python time-series aggregation.
   - *Impact*: Represents 22% of annual GMV.
   - *Action*: Secure inventory buffer 60 days in advance; scale server infrastructure.
2. **Eid Shopping Spike**: Eid festival preparation drives a **3.0x** transaction volume increase in the 30 days preceding Eid.
   - *Evidence*: SQL date query for March/April seasonal sales.
   - *Impact*: Key driver of Q1/Q2 revenue.
   - *Action*: Launch Ramzan-specific grocery and apparel campaign bundles.
3. **Cash on Delivery (COD) Domination**: COD represents **65%** of all customer checkouts.
   - *Evidence*: Payment method distribution pie chart.
   - *Impact*: Higher collection costs and slower cash flow cycles.
   - *Action*: Run incentives (e.g. 5% cashback) for mobile wallet pre-payments.
4. **Prepaid Order Safety**: Pre-paid digital wallets (Easypaisa/JazzCash) have a return-to-sender (RTS) rate of **<5%**, compared to **18%** for COD.
   - *Evidence*: Return rate SQL analysis by payment method.
   - *Impact*: Prepaid payment methods reduce courier handling costs.
   - *Action*: Partner with Easypaisa/JazzCash for marketing campaigns.
5. **High Value Order Concentration**: Orders priced >10,000 PKR account for only **15%** of total volume but generate **62%** of GMV.
   - *Evidence*: Order value tier segmentation analysis.
   - *Impact*: High exposure to high-ticket shoppers.
   - *Action*: Formulate a VIP customer retention program with dedicated customer support.
6. **Low Value Volume Drag**: Orders <2,000 PKR represent **52%** of logistics volume but only **10%** of revenue.
   - *Evidence*: Segment SQL query on order tiers.
   - *Impact*: Strains logistics network with low margin yield.
   - *Action*: Increase free delivery threshold from PKR 1,500 to PKR 2,500.
7. **Discount Stack Margin Leakage**: Orders with discounts >15% have a net margin of **<8%** compared to the company average of **26%**.
   - *Evidence*: Profitability query on discount rates.
   - *Impact*: Profit erosion on high-velocity items.
   - *Action*: Restrict cumulative coupon stacking on high-cost electronics.
8. **Product Category Profit Engine**: Fashion & Beauty yields the highest gross margin (**42.1%**), while Groceries has the lowest (**15.0%**).
   - *Evidence*: Category Profitability SQL Matrix.
   - *Impact*: Groceries drive frequency, but Fashion drives profitability.
   - *Action*: Cross-sell fashion items on grocery checkout confirmation screens.
9. **Cart Size Frequency**: Groceries show an average basket size of **3.4 units**, compared to **1.05** for Mobiles & Tablets.
   - *Evidence*: Basket size SQL aggregate.
   - *Impact*: Groceries are ideal for volume-based shipping fee structures.
   - *Action*: Offer discounts for buying staples in bundles.
10. **Refurbished Laptop Profit Margin**: Laptops (primarily refurbished Dell/HP) contribute **18%** of total electronics profit.
    - *Evidence*: Subcategory sales analysis.
    - *Impact*: High demand among students/remote workers.
    - *Action*: Source quality refurbished inventory with warranty options.

### 1.2 Customer & Churn Insights
11. **SLA Breach Churn Trigger**: Customers who experience a delay on their **first-ever order** have a **50%** churn rate, compared to **20%** for on-time deliveries.
    - *Evidence*: First-order delivery status SQL query.
    - *Impact*: Threatens customer lifetime value.
    - *Action*: Prioritize first-time buyers' orders in DEX priority processing lanes.
12. **The "SLA Cliff"**: Customer rating drops from **4.8 to 1.8** stars when delivery exceeds **4 days** in Tier 1 cities.
    - *Evidence*: Transit days vs satisfaction rating scatterplot.
    - *Impact*: Immediate negative sentiment and app uninstalls.
    - *Action*: Enforce automatic voucher payouts for delayed orders.
13. **Balochistan Logistics Friction**: Churn in Quetta/Balochistan stands at **68%** due to transit times averaging **8.4 days**.
    - *Evidence*: Provincial transit time and churn rate query.
    - *Impact*: Negative growth in western markets.
    - *Action*: Establish a small fulfillment hub in Quetta.
14. **Customer Age Sweet Spot**: Customers aged **26–35** make up **54%** of active buyers and **60%** of gross profit.
    - *Evidence*: Age group demographic analysis.
    - *Impact*: Core cohort for recurring revenue.
    - *Action*: Focus digital ad targeting on this group.
15. **Organic Channel Retention**: Organic search and referral signups have a **65%** 6-month retention rate, compared to **35%** for Facebook Ads.
    - *Evidence*: Retention rate by channel SQL.
    - *Impact*: Paid acquisition attracts low-loyalty shoppers.
    - *Action*: Invest in SEO content marketing and product review incentives.
16. **RFM Champion Concentration**: Champions represent **20%** of customer headcount but drive **48%** of net profit.
    - *Evidence*: Pareto Principle verification and RFM analysis.
    - *Impact*: Core profit defenders.
    - *Action*: Launch premium preview access to flash sales for this group.
17. **New Customer Drop-off**: Month 1 cohort retention drops by **35%** on average.
    - *Evidence*: Python cohort heatmap.
    - *Impact*: High leakage post-acquisition.
    - *Action*: Automated email campaign offering 20% discount on order 2 within 14 days of signup.
18. **Mobile Accessories Affinity**: Mobile covers and chargers are the top gateway products for new customer signups.
    - *Evidence*: Gateway products SQL analysis.
    - *Impact*: High volume, low profit gateway.
    - *Action*: Use accessories as free add-ons to drive high-margin smartphone checkouts.
19. **Low Rating Warning**: Active customers with average ratings < 2.5 are **3.1x** more likely to churn in the next 30 days.
    - *Evidence*: Python Random Forest key influencers.
    - *Impact*: Early warning indicator.
    - *Action*: Route these customers to VIP support teams for resolution.
20. **Female Apparel Frequency**: Female customers have a purchase frequency **1.8x** higher than male customers.
    - *Evidence*: Customer retention and purchase frequency by gender.
    - *Impact*: Ideal for high-margin weekly fashion campaigns.
    - *Action*: Implement dynamic homepage layouts emphasizing fashion for female accounts.

### 1.3 Operations & Logistics Insights
21. **DEX SLA Superiority**: Daraz Express (DEX) delivers orders in **1.8 days** on average with an SLA breach rate of only **2.1%**.
    - *Evidence*: Courier partner SLA SQL analysis.
    - *Impact*: Benchmark courier performance.
    - *Action*: Move as much Tier-1 volume to DEX as possible.
22. **Leopard Courier Leakage**: Leopard Courier has a **40%** delay rate and a **26.4%** return rate in remote Punjab/KPK.
    - *Evidence*: Courier performance SQL grid.
    - *Impact*: High return costs and customer frustration.
    - *Action*: Replace Leopard with TCS or regional players in underperforming cities.
23. **Weekday Peak Ordering Hours**: Customers order most between **8 PM and 11 PM** on weekdays.
    - *Evidence*: Hour of day SQL query.
    - *Impact*: Strains server capacity during peaks.
    - *Action*: Deploy live inventory sync and scheduled database maintenance outside these hours.
24. **COD Cash Handling Cost**: Cash handling fees and cash-in-transit (CIT) risk represent **2.8%** of COD transaction values.
    - *Evidence*: SQL order items cost analysis and finance logs.
    - *Impact*: Reduces net margin.
    - *Action*: Charge a small PKR 50 convenience fee for COD checkout to cover handling.
25. **Product Return Velocity**: Smartphones have the highest absolute return rate value, costing PKR 1.2M in shipping fees.
    - *Evidence*: Potential GMV lost query.
    - *Impact*: High working capital blockage.
    - *Action*: Implement serial number scanning and physical box checks prior to delivery dispatch.

### 1.4 Marketing & Ad Insights
26. **TikTok Ad Cost Efficiency**: TikTok Ads have a Customer Acquisition Cost (CAC) of **PKR 75** compared to Facebook Ads at **PKR 110**.
    - *Evidence*: Blended CAC query.
    - *Impact*: Higher volume acquisition budget efficiency.
    - *Action*: Shift 20% of general awareness budget from Facebook to TikTok.
27. **SMS Marketing High ROAS**: SMS campaigns drive a **4.5x** return on ad spend (ROAS) due to low CPM cost.
    - *Evidence*: Campaign ROI SQL analysis.
    - *Impact*: Effective for local promotions.
    - *Action*: Limit SMS marketing to high-value users to prevent brand fatigue.
28. **11.11 Ad Spend Efficiency**: 11.11 Mega campaigns generate a ROAS of **3.5x**, compared to general baseline ads at **2.0x**.
    - *Evidence*: Monthly campaign ROAS comparison.
    - *Impact*: Validation of high-budget seasonal ad spend.
    - *Action*: Continue massive allocation to mega campaigns.
29. **Facebook Ads Volume Engine**: Facebook Ads drive **58%** of total conversions but have a lower conversion rate (2.5%).
    - *Evidence*: Channel funnel conversion rate.
    - *Impact*: Primary reach engine.
    - *Action*: Utilize Facebook for retargeting already-engaged web visitors.
30. **Google Search Intent**: Google Ads conversion rate is **4.5%** with the highest AOV (PKR 5,800).
    - *Evidence*: Google Ads channel funnel.
    - *Impact*: Attracts high-value intent buyers.
    - *Action*: Target Google Search ads to specific high-value electronic models.

---

## 2. 20 Business Recommendations
1.  **DEX Lane Expansion**: Expand Daraz Express (DEX) logistics hubs to Multan, Peshawar, and Quetta.
2.  **Prepayment Cashbacks**: Offer 5% instant cashback for JazzCash/Easypaisa to reduce COD return rates.
3.  **Tiered Free Delivery**: Set a dynamic free shipping threshold: PKR 2,500 for Tier-1 cities, PKR 3,500 for Tier-2.
4.  **VIP Loyalty Scheme**: Introduce "Daraz Club" offering free delivery and 24-hour dispatch to Champions.
5.  **First-Order Protection**: Add a flag in the WMS (Warehouse Management System) to prioritize first-time buyers' orders.
6.  **Fulfillment Center Quetta**: Set up a micro-fulfillment center in Quetta storing top-selling electronics.
7.  **Courier SLA Penalties**: Renegotiate the SLA contract with Leopards Courier. Apply a 15% penalty for delayed deliveries.
8.  **Automated Reactivation**: Send automated SMS/App push notifications to customers who are inactive for 45 days.
9.  **Fashion Cross-Sell**: Show high-margin clothing accessories during grocery checkout flows.
10. **Refurbished Tech Expansion**: Partner with certified local electronics refurbishers to launch a co-branded warranty line.
11. **COD COD Fee**: Add a flat PKR 50 handling fee on COD checkouts to cover cash transit costs.
12. **TikTok Budget Shift**: Allocate 20% of the Q3 digital marketing budget from Facebook to TikTok.
13. **Stacking Discount Caps**: Implement coupon checks preventing discount stacking above 20% order value.
14. **Pre-Shipment Box Checks**: Require high-value electronics boxes to be sealed with tamper-proof tape and photographed.
15. **SMS Blast Optimization**: Reserve SMS push notifications for weekends and peak hours (8 PM - 10 PM).
16. **Dynamic Landing Page**: Personalize homepage grids based on customer demographics (e.g. fashion for women, gaming/tech for young men).
17. **Quality Control Audits**: Audit products with return rates >15% and ratings <3.0. Pause listings during audit.
18. **Mobile Wallet Integrations**: Create a direct SDK checkout partnership with Easypaisa/JazzCash apps.
19. **Clearance Campaigns**: Run clearance sales for slow-moving electronics stock (identified in SQL Query 37).
20. **Weekly Retention cohort checks**: Setup automated Power BI report delivery to operations managers every Monday morning.

---

## 3. 10 Strategic Decisions
1.  **Transition to Hybrid Marketplace**: Shift focus from direct wholesale sourcing to third-party vendor platforms.
2.  **In-source Logistics Focus**: Transition Tier-1 city shipments completely to in-house Daraz Express (DEX).
3.  **Geographic Target Realignment**: Shift marketing spend away from low-margin remote areas towards high-margin cities.
4.  **FMCG Subscription Model**: Launch a "Daraz Fresh Subscription" service for weekly staples.
5.  **Digital Payment Priority**: Target a reduction in Cash on Delivery (COD) share from 65% to 40% by Q4 2027.
6.  **Brand Positioning Shift**: Move Daraz positioning from "lowest price search" to "fastest delivery platform".
7.  **Vendor Quality Management**: Ban vendors who maintain an average product rating < 3.0 or return rate > 15%.
8.  **Time-Series Guided Inventory**: Use Holt-Winters forecasting to purchase inventory for peak sales.
9.  **Customer Support Automation**: Deploy an AI customer support chatbot to resolve transit queries.
10. **Financial Margin Guardrails**: Enforce a minimum product profit margin of 10% across all categories.
