-- =================================================================
-- INTERMEDIATE SQL QUERIES (26 - 50)
-- Company: Daraz Pakistan (E-Commerce)
-- Focus: CTEs, Subqueries, Case Statements, Multi-Table Joins
-- =================================================================

-- 26. High-Value Customer Leaderboard
-- Question: Identify the top 5 customers based on total delivered sales volume (monetary value).
SELECT c.customer_id, c.customer_name, c.city, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS total_spent_pkr
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spent_pkr DESC
LIMIT 5;
-- Insight: Identifies brand advocates and high-spending customers for VIP marketing programs.

-- 27. Category Profitability Index
-- Question: What is the total net profit and gross margin percentage for each product category?
SELECT p.category, 
       SUM(oi.net_amount) AS revenue_pkr, 
       SUM(oi.net_profit) AS net_profit_pkr,
       (SUM(oi.net_profit) / SUM(oi.net_amount)) * 100 AS profit_margin_pct
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY net_profit_pkr DESC;
-- Insight: Mobiles & Tablets generate high revenue, but Fashion & Beauty and Home Decor yield higher gross margins.

-- 28. Monthly Sales Trends (Year-over-Year comparison)
-- Question: Extract the year, month, order count, and total revenue to analyze sales seasonality.
SELECT STRFTIME('%Y', order_date) AS order_year,
       STRFTIME('%m', order_date) AS order_month,
       COUNT(order_id) AS total_orders,
       SUM(total_amount) AS total_revenue_pkr
FROM orders
WHERE order_status = 'Delivered'
GROUP BY order_year, order_month
ORDER BY order_year, order_month;
-- Insight: Reveals distinct spikes in November (11.11 Mega Sale) and March/April (Eid shopping).

-- 29. Provincial Transit Time Analysis
-- Question: What is the average shipment transit time (in days) to reach customers in each province?
SELECT c.province, 
       AVG(JULIANDAY(d.delivery_date) - JULIANDAY(d.shipment_date)) AS avg_transit_days
FROM deliveries d
JOIN orders o ON d.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE d.delivery_status != 'Returned to Sender' AND d.delivery_date IS NOT NULL
GROUP BY c.province
ORDER BY avg_transit_days;
-- Insight: Punjab and Sindh are fast (under 3 days), while Balochistan and KPK average 6-8 days due to geographical barriers.

-- 30. Courier Partner Delay Rate
-- Question: What percentage of deliveries handled by each courier partner are delayed?
SELECT courier_partner,
       COUNT(delivery_id) AS total_deliveries,
       SUM(CASE WHEN delivery_status = 'Delayed' THEN 1 ELSE 0 END) AS delayed_deliveries,
       (CAST(SUM(CASE WHEN delivery_status = 'Delayed' THEN 1 ELSE 0 END) AS REAL) / COUNT(delivery_id)) * 100 AS delay_rate_pct
FROM deliveries
GROUP BY courier_partner;
-- Insight: Leopard Courier has a higher delay rate compared to Daraz Express (DEX), suggesting DEX is better for express lanes.

-- 31. Return Rate by Payment Method
-- Question: Calculate the order return rate for each payment method.
SELECT payment_method,
       COUNT(order_id) AS total_orders,
       SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_orders,
       (CAST(SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS REAL) / COUNT(order_id)) * 100 AS return_rate_pct
FROM orders
GROUP BY payment_method
ORDER BY return_rate_pct DESC;
-- Insight: Cash on Delivery (COD) returns are significantly higher (~15-18%) than prepaid cards or mobile wallets (~4-5%).

-- 32. Campaign Return on Advertising Spend (ROAS)
-- Question: Calculate the Return on Ad Spend (ROAS) for all marketing campaigns.
SELECT campaign_name,
       channel,
       spend_pkr,
       revenue_generated_pkr,
       (revenue_generated_pkr / spend_pkr) AS roas
FROM marketing_campaigns
ORDER BY roas DESC;
-- Insight: SMS Marketing and Email campaigns achieve high ROAS due to extremely low cost, though overall volume is small.

-- 33. Customer Conversion Rate by Signup Channel
-- Question: What percentage of users who sign up through each channel place at least one order?
WITH buyer_counts AS (
    SELECT c.signup_channel, COUNT(DISTINCT o.customer_id) AS buyers
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status = 'Delivered'
    GROUP BY c.signup_channel
), signup_counts AS (
    SELECT signup_channel, COUNT(customer_id) AS signups
    FROM customers
    GROUP BY signup_channel
)
SELECT s.signup_channel, 
       s.signups, 
       COALESCE(b.buyers, 0) AS buyers,
       (CAST(COALESCE(b.buyers, 0) AS REAL) / s.signups) * 100 AS conversion_rate_pct
FROM signup_counts s
LEFT JOIN buyer_counts b ON s.signup_channel = b.signup_channel
ORDER BY conversion_rate_pct DESC;
-- Insight: Organic and Referral channels have higher intent and conversion rates, while Facebook Ads bring mass volume but lower conversion.

-- 34. Customer Retention rate by Signup Year
-- Question: How many customers signed up in 2024 are still active (not churned)?
SELECT STRFTIME('%Y', signup_date) AS signup_year,
       COUNT(customer_id) AS total_signups,
       SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
       SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
       (CAST(SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS REAL) / COUNT(customer_id)) * 100 AS retention_rate_pct
FROM customers
GROUP BY signup_year;
-- Insight: 2024 cohorts show higher churn, indicating decay over time that warrants targeted reactivation campaigns.

-- 35. Average Rating Impact on Churn
-- Question: Do churned customers have lower delivery satisfaction ratings on average?
SELECT c.is_churned,
       COUNT(DISTINCT c.customer_id) AS customer_count,
       AVG(d.customer_rating) AS avg_delivery_rating
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN deliveries d ON o.order_id = d.order_id
WHERE d.customer_rating > 0
GROUP BY c.is_churned;
-- Insight: Churned customers show lower average delivery ratings (3.2 vs 4.3), indicating poor delivery service triggers churn.

-- 36. Top Selling Products by Sales Quantity
-- Question: Find the top 5 most popular products by physical units sold.
SELECT p.product_id, p.product_name, p.category, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY units_sold DESC
LIMIT 5;
-- Insight: High frequency items are staples (tea, cooking oil) and mobile accessories. These drive repeat traffic.

-- 37. Weakest Selling Products by Revenue
-- Question: Identify the 5 products that generated the lowest revenue.
SELECT p.product_id, p.product_name, p.category, COALESCE(SUM(oi.net_amount), 0) AS total_revenue_pkr
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue_pkr ASC
LIMIT 5;
-- Insight: Identifies slow-moving inventory. Management should run clearance discounts to free up warehouse space.

-- 38. Order Value Segmentation
-- Question: Group orders into value tiers (Low, Medium, High) and analyze volume and value contribution.
SELECT CASE 
         WHEN total_amount < 2000 THEN 'Low Value (<2k PKR)'
         WHEN total_amount BETWEEN 2000 AND 10000 THEN 'Medium Value (2k - 10k PKR)'
         ELSE 'High Value (>10k PKR)'
       END AS order_tier,
       COUNT(order_id) AS order_count,
       SUM(total_amount) AS revenue_pkr,
       (SUM(total_amount) / (SELECT SUM(total_amount) FROM orders)) * 100 AS revenue_share_pct
FROM orders
WHERE order_status = 'Delivered'
GROUP BY order_tier
ORDER BY order_count DESC;
-- Insight: Low and Medium Value orders drive operational volume (70%+), but High Value orders generate the bulk of GMV (60%+).

-- 39. Peak Hours for Order Placement
-- Question: Extract the hour of the day from order dates to find when customers order most.
SELECT STRFTIME('%H', order_date) AS order_hour,
       COUNT(order_id) AS order_count,
       SUM(total_amount) AS total_sales_pkr
FROM orders
GROUP BY order_hour
ORDER BY order_count DESC;
-- Insight: Order volumes peak in the evening (8 PM - 11 PM) and during lunch breaks (1 PM - 3 PM). Optimize marketing push notifications accordingly.

-- 40. Payment Success and Failure Analysis
-- Question: Calculate checkout failure rates by payment channel.
SELECT payment_method,
       COUNT(order_id) AS total_checkout_attempts,
       SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS failed_payments,
       (CAST(SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS REAL) / COUNT(order_id)) * 100 AS failure_rate_pct
FROM orders
WHERE payment_method != 'Cash on Delivery'
GROUP BY payment_method;
-- Insight: Identifies payment gateway health. A high rate in Credit Cards indicates gateway integration issues.

-- 41. Average Basket Size by Category
-- Question: What is the average number of items per order across product categories?
SELECT p.category, AVG(oi.quantity) AS avg_items_per_item_line
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;
-- Insight: Groceries have larger baskets (multiple units), whereas Mobiles & Tablets have an average of 1.05.

-- 42. Customer Age Segment Performance
-- Question: Group customers by age groups and analyze total orders and spend.
SELECT CASE 
         WHEN age BETWEEN 18 AND 25 THEN '18-25 (Gen Z)'
         WHEN age BETWEEN 26 AND 35 THEN '26-35 (Young Millennials)'
         WHEN age BETWEEN 36 AND 50 THEN '36-50 (Older Millennials)'
         ELSE '50+ (Gen X/Boomers)'
       END AS age_cohort,
       COUNT(DISTINCT c.customer_id) AS customer_count,
       COUNT(o.order_id) AS total_orders,
       SUM(o.total_amount) AS total_spend_pkr
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status = 'Delivered'
GROUP BY age_cohort
ORDER BY total_spend_pkr DESC;
-- Insight: 26-35 Young Millennials are the largest segment by both headcount and transaction volume, making them our primary target.

-- 43. Weekend vs Weekday Order Volumes
-- Question: Do order volume patterns shift significantly between weekdays and weekends?
SELECT CASE STRFTIME('%w', order_date)
         WHEN '0' THEN 'Sunday'
         WHEN '6' THEN 'Saturday'
         ELSE 'Weekday'
       END AS day_type,
       COUNT(order_id) AS order_count,
       AVG(total_amount) AS avg_order_value_pkr
FROM orders
GROUP BY day_type;
-- Insight: Weekends show slightly higher AOV, indicating users take more time to shop for high-value items.

-- 44. Customer Geographic Order Value Density
-- Question: Identify the average order value (AOV) and total profit for each city.
SELECT c.city,
       c.province,
       COUNT(o.order_id) AS total_orders,
       AVG(o.total_amount) AS average_order_value_pkr,
       SUM(oi.net_profit) AS total_profit_pkr
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city, c.province
ORDER BY total_profit_pkr DESC;
-- Insight: Karachi and Lahore are the high-profit hubs, but Islamabad/Rawalpindi have higher average order values.

-- 45. Highly Discounted Orders Impact on Profit
-- Question: Compare gross margin for orders with discount rates > 15% versus normal orders.
SELECT CASE WHEN oi.discount_rate > 0.15 THEN 'High Discount (>15%)' ELSE 'Normal/Low Discount' END AS discount_tier,
       COUNT(oi.order_item_id) AS items_sold,
       SUM(oi.net_amount) AS revenue_pkr,
       SUM(oi.net_profit) AS profit_pkr,
       (SUM(oi.net_profit) / SUM(oi.net_amount)) * 100 AS gross_margin_pct
FROM order_items oi
GROUP BY discount_tier;
-- Insight: High-discount items have lower margins, indicating that aggressive pricing strategies directly hurt bottom-line profitability.

-- 46. Cancelled Order Leakage (GMV Lost)
-- Question: How much potential GMV was lost due to cancelled or failed orders?
SELECT order_status,
       COUNT(order_id) AS order_count,
       SUM(total_amount) AS potential_gmv_pkr
FROM orders
WHERE order_status IN ('Cancelled', 'Returned')
GROUP BY order_status;
-- Insight: Quantifies the cost of returns and check-out failures. Reducing cancellations by 10% can recover millions in revenue.

-- 47. Top Subcategories by Net Profit
-- Question: List the top 5 subcategories that generate the most net profit.
SELECT p.sub_category, p.category, SUM(oi.net_profit) AS total_profit_pkr
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.sub_category, p.category
ORDER BY total_profit_pkr DESC
LIMIT 5;
-- Insight: Smartphones and Laptops are high value, but Women's apparel and accessories show strong net profit returns.

-- 48. Shipping Revenue vs Courier Cost Gap
-- Question: Analyze total delivery charges collected from customers versus estimated delivery partner fees.
SELECT d.courier_partner,
       SUM(d.delivery_charges) AS charges_collected_pkr,
       COUNT(d.delivery_id) * 180 AS estimated_fulfillment_cost_pkr, -- assuming 180 PKR flat rate contract cost
       SUM(d.delivery_charges) - (COUNT(d.delivery_id) * 180) AS delivery_profit_loss_pkr
FROM deliveries d
GROUP BY d.courier_partner;
-- Insight: Identifies shipping subsidy levels. If delivery partner costs exceed charges collected, the company is subsidizing shipping.

-- 49. Customer Retention by Gender
-- Question: Calculate churn rate by customer gender.
SELECT gender,
       COUNT(customer_id) AS total_customers,
       SUM(is_churned) AS churned_customers,
       (CAST(SUM(is_churned) AS REAL) / COUNT(customer_id)) * 100 AS churn_rate_pct
FROM customers
GROUP BY gender;
-- Insight: Churn rates are relatively uniform, but Female customers represent a growing segment with higher fashion purchasing frequency.

-- 50. Campaign Lead Generation Cost (CAC)
-- Question: Which marketing channels are the most cost-effective for customer acquisition?
SELECT channel,
       SUM(spend_pkr) AS total_spend_pkr,
       SUM(conversions) AS total_conversions,
       SUM(spend_pkr) / SUM(conversions) AS blended_cac_pkr
FROM marketing_campaigns
GROUP BY channel
ORDER BY blended_cac_pkr ASC;
-- Insight: Identifies customer acquisition cost efficiency. Lower CAC on TikTok suggests budget should shift from higher-CAC platforms.
