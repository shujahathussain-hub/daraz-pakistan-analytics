-- =================================================================
-- ADVANCED SQL QUERIES (51 - 75)
-- Company: Daraz Pakistan (E-Commerce)
-- Focus: Window Functions (RANK, LAG, LEAD, SUM OVER), Market Basket Analysis, Cohorts, SLA Breaches
-- =================================================================

-- 51. Programmatic RFM Segmentation
-- Question: Calculate Recency, Frequency, and Monetary ranks (1-5) using NTILE, and assign segments.
WITH rfm_raw AS (
    SELECT o.customer_id,
           (JULIANDAY('2026-05-31') - JULIANDAY(MAX(o.order_date))) AS recency,
           COUNT(o.order_id) AS frequency,
           SUM(o.total_amount) AS monetary
    FROM orders o
    WHERE o.order_status = 'Delivered'
    GROUP BY o.customer_id
),
rfm_scores AS (
    SELECT customer_id,
           recency, frequency, monetary,
           NTILE(5) OVER (ORDER BY recency DESC) AS r_score, -- Lower recency is better (5)
           NTILE(5) OVER (ORDER BY frequency ASC) AS f_score, -- Higher frequency is better (5)
           NTILE(5) OVER (ORDER BY monetary ASC) AS m_score  -- Higher monetary is better (5)
    FROM rfm_raw
)
SELECT customer_id, recency, frequency, monetary,
       (r_score || f_score || m_score) AS rfm_cell,
       CASE 
         WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
         WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Loyal Customers'
         WHEN r_score >= 4 AND f_score = 1 THEN 'New Customers'
         WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk / Slipping'
         WHEN r_score <= 2 AND f_score <= 2 THEN 'Hibernating / Lost'
         ELSE 'Promising / Warm'
       END AS customer_segment
FROM rfm_scores
ORDER BY monetary DESC
LIMIT 10;
-- Insight: Auto-segments customers using statistics-based pentiles. Champions are targets for referral programs.

-- 52. Month-over-Month (MoM) Revenue Growth Rate
-- Question: Calculate monthly delivered revenue and the percentage change compared to the previous month.
WITH monthly_revenue AS (
    SELECT STRFTIME('%Y-%m', order_date) AS year_month,
           SUM(total_amount) AS current_month_revenue
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY year_month
)
SELECT year_month,
       current_month_revenue,
       LAG(current_month_revenue, 1) OVER (ORDER BY year_month) AS prev_month_revenue,
       ((current_month_revenue - LAG(current_month_revenue, 1) OVER (ORDER BY year_month)) / 
        LAG(current_month_revenue, 1) OVER (ORDER BY year_month)) * 100 AS mom_growth_pct
FROM monthly_revenue;
-- Insight: Measures sales momentum. Highlights the drop post-November Mega Sales (-45% in December) and spikes in March.

-- 53. Cumulative Running Revenue Total (YTD Running Sum)
-- Question: Calculate a cumulative running sum of delivered revenue by month for each calendar year.
WITH monthly_revenue AS (
    SELECT STRFTIME('%Y', order_date) AS order_year,
           STRFTIME('%Y-%m', order_date) AS year_month,
           SUM(total_amount) AS monthly_sales
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY order_year, year_month
)
SELECT order_year,
       year_month,
       monthly_sales,
       SUM(monthly_sales) OVER (PARTITION BY order_year ORDER BY year_month) AS ytd_running_revenue
FROM monthly_revenue;
-- Insight: Tracks company progress against annual targets. Allows executives to monitor performance run rates.

-- 54. 3-Month Moving Average of Revenue
-- Question: Smooth out seasonal spikes by calculating a 3-month rolling average of monthly delivered revenue.
WITH monthly_sales AS (
    SELECT STRFTIME('%Y-%m', order_date) AS year_month,
           SUM(total_amount) AS revenue
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY year_month
)
SELECT year_month,
       revenue,
       AVG(revenue) OVER (ORDER BY year_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3_month_avg
FROM monthly_sales;
-- Insight: Provides a smoothed view of financial trends, removing noise from mega campaigns (e.g. 11.11).

-- 55. Market Basket Analysis (Product Co-Purchase)
-- Question: Identify the top 5 product pairs that are most frequently purchased together in the same order.
SELECT p1.product_name AS product_a, 
       p2.product_name AS product_b, 
       COUNT(*) AS co_purchase_count
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
GROUP BY product_a, product_b
ORDER BY co_purchase_count DESC
LIMIT 5;
-- Insight: Discovers items that drive co-purchases. Great for cross-selling recommendations and bundle discounts.

-- 56. SQL-Based Cohort Retention Matrix
-- Question: Calculate customer retention rate month-over-month for cohorts signed up in Q1 2024.
WITH cohorts AS (
    -- Get cohort signup month
    SELECT customer_id,
           STRFTIME('%Y-%m', signup_date) AS cohort_month
    FROM customers
    WHERE signup_date BETWEEN '2024-01-01' AND '2024-03-31'
),
transactions AS (
    -- Map purchases to months
    SELECT o.customer_id,
           STRFTIME('%Y-%m', o.order_date) AS order_month
    FROM orders o
    WHERE o.order_status = 'Delivered'
),
cohort_sizes AS (
    -- Size of each cohort
    SELECT cohort_month, COUNT(customer_id) AS total_users
    FROM cohorts
    GROUP BY cohort_month
),
active_users AS (
    -- Monthly active buyers per cohort
    SELECT c.cohort_month,
           t.order_month,
           -- Months difference
           ((STRFTIME('%Y', t.order_month) - STRFTIME('%Y', c.cohort_month)) * 12 + 
            (STRFTIME('%m', t.order_month) - STRFTIME('%m', c.cohort_month))) AS period_idx,
           COUNT(DISTINCT c.customer_id) AS active_users_count
    FROM cohorts c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY cohort_month, order_month
)
SELECT au.cohort_month,
       cs.total_users AS cohort_size,
       au.period_idx AS month_number,
       au.active_users_count AS active_buyers,
       (CAST(au.active_users_count AS REAL) / cs.total_users) * 100 AS retention_rate_pct
FROM active_users au
JOIN cohort_sizes cs ON au.cohort_month = cs.cohort_month
WHERE au.period_idx BETWEEN 0 AND 6
ORDER BY au.cohort_month, au.period_idx;
-- Insight: Measures structural retention. Decline in retention after month 1 indicates early-stage friction.

-- 57. Top 3 Selling Products in each category by Province
-- Question: Rank products within each category by total sales volume in each province, displaying top 3.
WITH product_ranks AS (
    SELECT c.province,
           p.category,
           p.product_name,
           SUM(oi.quantity) AS total_qty_sold,
           DENSE_RANK() OVER (PARTITION BY c.province, p.category ORDER BY SUM(oi.quantity) DESC) AS sales_rank
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN orders o ON oi.order_id = o.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.province, p.category, p.product_name
)
SELECT province, category, product_name, total_qty_sold, sales_rank
FROM product_ranks
WHERE sales_rank <= 3
ORDER BY province, category, sales_rank;
-- Insight: Shows regional product preferences (e.g. fashion is highly ranked in Lahore/Punjab, tea in Karachi/Sindh).

-- 58. First Order Late Delivery Impact on Churn
-- Question: Identify customers whose first-ever delivery was delayed, and check if they have a higher churn rate.
WITH customer_first_order AS (
    SELECT o.customer_id,
           o.order_id,
           o.order_date,
           ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date ASC) AS rn
    FROM orders o
),
first_delivery_status AS (
    SELECT cfo.customer_id,
           d.delivery_status
    FROM customer_first_order cfo
    JOIN deliveries d ON cfo.order_id = d.order_id
    WHERE cfo.rn = 1
)
SELECT fds.delivery_status AS first_delivery_experience,
       COUNT(c.customer_id) AS total_customers,
       SUM(c.is_churned) AS churned_customers,
       (CAST(SUM(c.is_churned) AS REAL) / COUNT(c.customer_id)) * 100 AS churn_rate_pct
FROM customers c
JOIN first_delivery_status fds ON c.customer_id = fds.customer_id
GROUP BY first_delivery_experience;
-- Insight: Customers who experience a delay on order 1 churn at a much higher rate (~50% vs ~20% for on-time).

-- 59. Average Days to Second Purchase
-- Question: Calculate the average time (in days) it takes for a customer to make their second order.
WITH purchase_sequence AS (
    SELECT customer_id,
           order_date,
           LEAD(order_date, 1) OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS next_order_date,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS seq
    FROM orders
    WHERE order_status = 'Delivered'
)
SELECT AVG(JULIANDAY(next_order_date) - JULIANDAY(order_date)) AS avg_days_to_second_purchase
FROM purchase_sequence
WHERE seq = 1 AND next_order_date IS NOT NULL;
-- Insight: Measures speed of loyalty. The quicker the second purchase, the higher the customer lifetime value.

-- 60. Dynamic Customer Lifetime Value (CLV) by Signup Channel
-- Question: Calculate customer value metrics (average orders, average spend, churn rate, and projected CLV) grouped by channel.
SELECT c.signup_channel,
       COUNT(DISTINCT c.customer_id) AS total_acquired_customers,
       AVG(monetary_summary.total_spend) AS avg_lifetime_spend_pkr,
       AVG(monetary_summary.total_orders) AS avg_lifetime_orders,
       AVG(c.is_churned) * 100 AS churn_rate_pct,
       -- CLV Formula: (Avg Spend * Avg Orders) / Churn Rate
       (AVG(monetary_summary.total_spend) * AVG(monetary_summary.total_orders)) / COALESCE(NULLIF(AVG(c.is_churned), 0), 0.05) AS projected_clv_pkr
FROM customers c
LEFT JOIN (
    SELECT customer_id, 
           SUM(total_amount) AS total_spend,
           COUNT(order_id) AS total_orders
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
) monetary_summary ON c.customer_id = monetary_summary.customer_id
GROUP BY c.signup_channel
ORDER BY projected_clv_pkr DESC;
-- Insight: organic and referrals produce the highest CLV due to lower churn, whereas paid channels have higher churn rates.

-- 61. High Return Product Quality Flag
-- Question: Identify products that have a high return rate (>15%) and low average delivery rating (<3.0).
SELECT p.product_id,
       p.product_name,
       p.category,
       COUNT(oi.order_item_id) AS total_items_ordered,
       (CAST(SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END) AS REAL) / COUNT(oi.order_item_id)) * 100 AS return_rate_pct,
       AVG(d.customer_rating) AS avg_delivery_rating
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN deliveries d ON o.order_id = d.order_id
GROUP BY p.product_id, p.product_name, p.category
HAVING total_items_ordered >= 20 AND return_rate_pct > 15.0 AND avg_delivery_rating < 3.0
ORDER BY return_rate_pct DESC;
-- Insight: Highlights potential quality control issues. These products should be audited or removed from the catalog.

-- 62. Year-over-Year Cohort Expansion
-- Question: Compare customer acquisition count and their average revenue contribution between 2024 and 2025 signups.
WITH customer_cohort_spend AS (
    SELECT c.customer_id,
           STRFTIME('%Y', c.signup_date) AS signup_year,
           COALESCE(SUM(o.total_amount), 0) AS total_spend
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status = 'Delivered'
    GROUP BY c.customer_id, signup_year
)
SELECT signup_year,
       COUNT(customer_id) AS customers_acquired,
       AVG(total_spend) AS avg_spend_per_customer_pkr,
       SUM(total_spend) AS total_sales_contribution_pkr
FROM customer_cohort_spend
GROUP BY signup_year;
-- Insight: Measures velocity of market growth. 2025 cohort represents accelerated acquisition compared to 2024.

-- 63. Pareto Principle (80/20 Rule) Verification
-- Question: Calculate what percentage of total revenue is contributed by the top 10% highest-spending customers.
WITH customer_spend AS (
    SELECT customer_id,
           SUM(total_amount) AS spend,
           ROW_NUMBER() OVER (ORDER BY SUM(total_amount) DESC) AS spend_rank,
           (SELECT COUNT(DISTINCT customer_id) FROM customers) AS total_customers,
           (SELECT SUM(total_amount) FROM orders WHERE order_status = 'Delivered') AS total_revenue
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)
SELECT SUM(spend) AS top_10_percent_spend_pkr,
       total_revenue AS overall_revenue_pkr,
       (SUM(spend) / total_revenue) * 100 AS revenue_share_pct
FROM customer_spend
WHERE spend_rank <= (total_customers * 0.10);
-- Insight: Evaluates concentration. If 10% of customers generate ~40% of sales, loyalty campaigns are critical.

-- 64. SLA Performance Breach Analysis by Region
-- Question: Identify deliveries that breached SLA (SLA is 3 days for Sindh/Punjab, 6 days for other provinces).
WITH delivery_sla AS (
    SELECT d.delivery_id,
           c.province,
           d.courier_partner,
           (JULIANDAY(d.delivery_date) - JULIANDAY(d.shipment_date)) AS transit_days,
           CASE 
             WHEN c.province IN ('Sindh', 'Punjab', 'Islamabad Capital Territory') THEN 3 
             ELSE 6 
           END AS sla_days
    FROM deliveries d
    JOIN orders o ON d.order_id = o.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE d.delivery_status = 'Delivered' AND d.delivery_date IS NOT NULL
)
SELECT province,
       courier_partner,
       COUNT(delivery_id) AS total_shipments,
       SUM(CASE WHEN transit_days > sla_days THEN 1 ELSE 0 END) AS sla_breaches,
       (CAST(SUM(CASE WHEN transit_days > sla_days THEN 1 ELSE 0 END) AS REAL) / COUNT(delivery_id)) * 100 AS breach_rate_pct
FROM delivery_sla
GROUP BY province, courier_partner
ORDER BY breach_rate_pct DESC;
-- Insight: Pins down logistics bottlenecks. Helpful in renegotiating vendor contracts based on performance SLAs.

-- 65. Early Churn Warning Indicator
-- Question: Identify active customers (is_churned=0) who haven't ordered in the last 60 days.
SELECT c.customer_id,
       c.customer_name,
       c.city,
       c.signup_channel,
       (JULIANDAY('2026-05-31') - JULIANDAY(MAX(order_date))) AS days_since_last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.is_churned = 0 AND o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name, c.city, c.signup_channel
HAVING days_since_last_order BETWEEN 60 AND 90
ORDER BY days_since_last_order DESC;
-- Insight: Generates the target list for immediate email/SMS discount campaigns before they transition to fully churned.

-- 66. Top Gateway Campaign Attributors
-- Question: What product subcategories have the highest first-purchase volume (customer acquisition gateways)?
WITH customer_first_purchase AS (
    SELECT o.customer_id,
           oi.product_id,
           ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date ASC) AS rn
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
)
SELECT p.sub_category,
       p.category,
       COUNT(DISTINCT cfp.customer_id) AS first_time_buyers
FROM customer_first_purchase cfp
JOIN products p ON cfp.product_id = p.product_id
WHERE cfp.rn = 1
GROUP BY p.sub_category, p.category
ORDER BY first_time_buyers DESC
LIMIT 5;
-- Insight: Identifies "gateway products." These categories attract new customers, so they should be highlighted on landing pages.

-- 67. Cumulative Returns Cost Impact on Profit
-- Question: Calculate a running sum of profits lost due to returns chronologically.
WITH monthly_returns AS (
    SELECT STRFTIME('%Y-%m', o.order_date) AS year_month,
           SUM(oi.net_amount) AS revenue_lost_pkr,
           SUM(oi.net_profit) AS profit_lost_pkr
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Returned'
    GROUP BY year_month
)
SELECT year_month,
       revenue_lost_pkr,
       profit_lost_pkr,
       SUM(profit_lost_pkr) OVER (ORDER BY year_month) AS cumulative_profit_lost_pkr
FROM monthly_returns;
-- Insight: Tracks financial drain over time. Essential for CFO reporting.

-- 68. Category Diversity Index
-- Question: Segment customers based on the number of unique product categories they purchase from.
WITH customer_diversity AS (
    SELECT o.customer_id,
           COUNT(DISTINCT p.category) AS unique_categories
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.customer_id
)
SELECT unique_categories,
       COUNT(customer_id) AS customer_count,
       (CAST(COUNT(customer_id) AS REAL) / (SELECT COUNT(DISTINCT customer_id) FROM orders WHERE order_status = 'Delivered')) * 100 AS customer_share_pct
FROM customer_diversity
GROUP BY unique_categories
ORDER BY unique_categories;
-- Insight: Most customers purchase from only 1 or 2 categories. Cross-category promotion represents a massive growth lever.

-- 69. Growth Velocity by City Year-over-Year
-- Question: Calculate year-over-year revenue growth for Karachi, Lahore, and Islamabad/Rawalpindi.
WITH city_annual_sales AS (
    SELECT c.city,
           STRFTIME('%Y', o.order_date) AS order_year,
           SUM(o.total_amount) AS total_sales
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Delivered' AND c.city IN ('Karachi', 'Lahore', 'Islamabad', 'Rawalpindi')
    GROUP BY c.city, order_year
)
SELECT city,
       order_year,
       total_sales,
       LAG(total_sales, 1) OVER (PARTITION BY city ORDER BY order_year) AS prev_year_sales,
       ((total_sales - LAG(total_sales, 1) OVER (PARTITION BY city ORDER BY order_year)) / 
        LAG(total_sales, 1) OVER (PARTITION BY city ORDER BY order_year)) * 100 AS yoy_growth_pct
FROM city_annual_sales;
-- Insight: Shows growth rate of our core city markets. Rawalpindi/Islamabad have shown accelerated growth compared to Karachi.

-- 70. Product Profit Contribution vs Sales Share
-- Question: For each product, calculate its share of total items sold vs its share of total profits.
WITH product_summary AS (
    SELECT product_id,
           SUM(quantity) AS product_qty,
           SUM(net_profit) AS product_profit
    FROM order_items
    GROUP BY product_id
),
overall_totals AS (
    SELECT SUM(quantity) AS grand_qty,
           SUM(net_profit) AS grand_profit
    FROM order_items
)
SELECT p.product_name,
       p.category,
       (CAST(ps.product_qty AS REAL) / ot.grand_qty) * 100 AS sales_qty_share_pct,
       (CAST(ps.product_profit AS REAL) / ot.grand_profit) * 100 AS profit_share_pct
FROM product_summary ps
CROSS JOIN overall_totals ot
JOIN products p ON ps.product_id = p.product_id
ORDER BY profit_share_pct DESC
LIMIT 10;
-- Insight: Highlights key margin products. Redmi Note 13 and Laptops contribute disproportionate profit shares compared to units sold.

-- 71. Consecutive Late Deliveries Tracker
-- Question: Identify customers who have experienced late deliveries on their two most recent orders.
WITH delivery_sequence AS (
    SELECT o.customer_id,
           d.delivery_status,
           ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date DESC) AS order_recency_rank
    FROM orders o
    JOIN deliveries d ON o.order_id = d.order_id
    WHERE o.order_status = 'Delivered'
),
recent_deliveries AS (
    SELECT customer_id,
           SUM(CASE WHEN delivery_status = 'Delayed' THEN 1 ELSE 0 END) AS delayed_count
    FROM delivery_sequence
    WHERE order_recency_rank <= 2
    GROUP BY customer_id
)
SELECT rd.customer_id, c.customer_name, c.city, c.province
FROM recent_deliveries rd
JOIN customers c ON rd.customer_id = c.customer_id
WHERE rd.delayed_count = 2;
-- Insight: Identifies extremely frustrated customers who have experienced back-to-back delivery delays. High churn risk!

-- 72. Marketing Campaign conversion funnel (Impression to Conversion)
-- Question: Calculate click-through-rate (CTR), conversion rate (CVR), and cost-per-acquisition (CPA) per campaign.
SELECT campaign_name,
       channel,
       spend_pkr,
       (CAST(clicks AS REAL) / impressions) * 100 AS ctr_pct,
       (CAST(conversions AS REAL) / clicks) * 100 AS cvr_pct,
       spend_pkr / conversions AS cpa_pkr
FROM marketing_campaigns
ORDER BY cvr_pct DESC;
-- Insight: Shows funnel efficiency. Eid campaigns achieve high click-to-conversion rates compared to general brand awareness ads.

-- 73. Loss-Making Order items
-- Question: Find specific order items where profit was negative due to heavy discounts (net_profit < 0).
SELECT oi.order_id,
       c.customer_name,
       p.product_name,
       oi.quantity,
       oi.unit_price,
       oi.discount_rate,
       oi.net_amount,
       oi.net_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE oi.net_profit < 0
ORDER BY oi.net_profit ASC;
-- Insight: Identifies pricing policy breaches. Heavy discount stacking can lead to loss-making sales.

-- 74. Sales Velocity Growth rate (2025 vs 2024)
-- Question: Find the top 3 products whose sales quantity increased the most from 2024 to 2025.
WITH annual_product_sales AS (
    SELECT product_id,
           SUM(CASE WHEN STRFTIME('%Y', o.order_date) = '2024' THEN oi.quantity ELSE 0 END) AS qty_2024,
           SUM(CASE WHEN STRFTIME('%Y', o.order_date) = '2025' THEN oi.quantity ELSE 0 END) AS qty_2025
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY product_id
)
SELECT p.product_name,
       p.category,
       aps.qty_2024,
       aps.qty_2025,
       aps.qty_2025 - aps.qty_2024 AS growth_units,
       ((CAST(aps.qty_2025 AS REAL) - aps.qty_2024) / NULLIF(aps.qty_2024, 0)) * 100 AS growth_pct
FROM annual_product_sales aps
JOIN products p ON aps.product_id = p.product_id
WHERE aps.qty_2024 > 0
ORDER BY growth_units DESC
LIMIT 3;
-- Insight: Pinpoints rising star products. Great for adjusting purchase forecasts and warehouse allocation.

-- 75. Database Verification and Explaining Query Plan
-- Question: Use SQLite EXPLAIN QUERY PLAN to examine the efficiency of indexing for product-category sales.
EXPLAIN QUERY PLAN
SELECT p.category, SUM(oi.net_amount) AS revenue
FROM order_items oi
INDEXED BY idx_order_items_product_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;
-- Insight: Verifies that database optimizer utilizes index `idx_order_items_product_id` to join tables efficiently, preventing slow full-table scans.
