# Prescriptive Strategy Report: Strategic Playbook
**Company: Daraz Pakistan (E-Commerce)**
**Author: Senior Analytics Consultant**

This playbook provides actionable, data-backed strategies to optimize revenue growth, reduce fulfillment leakage, improve marketing efficiency, and curb customer churn.

---

## 1. Customer Retention Strategy: Protecting the First Impression

### 1.1 Action Plan
1.  **First-Order Priority (FOP)**: Tag all new accounts' first orders with a high-priority flag in the warehouse management system.
    *   *Fulfillment SLA*: First orders must be shipped within 12 hours of payment confirmation.
    *   *Carrier Routing*: Route first orders exclusively through Daraz Express (DEX) or high-performing couriers like TCS, avoiding Leopard Courier.
2.  **Proactive Delayed Compensation**: Implement automated triggers that send an app notification and a 200 PKR discount voucher if an order transit time exceeds 4 days in Tier 1 or 7 days in remote areas.
3.  **Customer Churn Warning Pipeline**: Use the machine learning model churn probabilities output in `customer_rfm.csv` to feed automated email and SMS discount campaign queues daily for active customers with churn probability > 70%.

---

## 2. Revenue Growth Strategy: High-Margin Basket Expansion

### 2.1 Action Plan
1.  **Cross-Category Recommendation**: Set up automated product listing recommendations on shopping carts. Focus on prompting grocery shoppers with Fashion & Beauty items.
    *   *Lever*: Cross-sell women's apparel items alongside home essentials to capitalize on higher checkout frequencies.
2.  **Tiered Free Delivery Program**: Implement tiered free delivery thresholds to increase Average Order Value (AOV) by 15%.
    *   *Tier 1 (Karachi, Lahore, Islamabad, Pindi)*: Free delivery above PKR 2,500.
    *   *Tier 2 (Other cities)*: Free delivery above PKR 3,500.
3.  **Seasonal Campaign Calendar**: Reallocate 15% of the marketing budget from Q1 to pre-Eid and pre-11.11 shopping periods. Optimize inventory buffers for refurbished laptops and smartphones.

---

## 3. Cost Reduction Strategy: Eliminating Logistics Leakage

### 3.1 Action Plan
1.  **Digital Payment Surcharges / Incentives**:
    *   *COD Convenience Fee*: Apply a flat PKR 50 convenience fee on COD checkouts.
    *   *Digital Cashback*: Secure partnerships with Easypaisa and JazzCash to offer a 5% instant discount (up to PKR 250) on prepaid orders.
    *   *Target*: Reduce COD transaction share from 65% to 45% within 18 months, saving millions in return logistics.
2.  **Discount Stacking Controls**: Upgrade the checkout cart business logic to prevent stacking coupon codes, payment gateway discounts, and store voucher codes. Cap cumulative order discounts at **20%** of gross order value.
3.  **Low-Margin Category Review**: Enforce a minimum seller commission of 12% on low-margin FMCG/staple categories to offset warehousing costs.

---

## 4. Operational Improvement Strategy: Courier Network Optimization

### 4.1 Action Plan
1.  **Courier Contract Renegotiation**:
    *   Introduce an SLA-linked penalty: Couriers must pay a 20% refund on shipping charges for any delivery delayed beyond the SLA threshold.
    *   Scale down Leopard Courier volume allocations by 50% in KPK and Punjab, shifting the volume to TCS.
2.  **Micro-Fulfillment Hub Quetta**: Set up a micro-fulfillment center in Quetta storing top-selling smartphones, mobile accessories, and staples to bypass the long transit times from Sindh.

---

## 5. Marketing Optimization Strategy: Dynamic Channel Allocation

### 5.1 Action Plan
1.  **Budget Reallocation**: Shift 20% of general brand awareness ad budget from Facebook to TikTok.
    *   *Reason*: TikTok CAC is PKR 75 compared to Facebook at PKR 110, offering higher signup volume per rupee spent.
2.  **Google Search Focus**: Allocate ad spend to search campaigns targeting high-intent electronic keywords (e.g. Redmi Note 13 buy, refurbished laptops Lahore) to capture high AOV checkouts.
3.  **Automated SMS Retargeting**: Integrate CRM lists with SMS services to send automated push campaigns to the "At Risk" customer segment at 8 PM on weekends.
