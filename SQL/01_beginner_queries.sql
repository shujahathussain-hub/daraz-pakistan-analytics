-- =================================================================
-- BEGINNER SQL QUERIES (1 - 25)
-- Company: Daraz Pakistan (E-Commerce)
-- Focus: Aggregations, Joins, Group By, Filtering, Date Functions
-- =================================================================

-- 1. View Customer Profiles
-- Question: Get a list of the first 10 customers who joined Daraz Pakistan.
SELECT customer_id, customer_name, city, province, signup_date
FROM customers
ORDER BY signup_date ASC
LIMIT 10;
-- Insight: Displays initial adopters. Early signups are mostly from major hubs like Karachi and Lahore.

-- 2. Unique Cities Matrix
-- Question: Identify all distinct cities where Daraz Pakistan has an active customer base.
SELECT DISTINCT city, province 
FROM customers
ORDER BY province, city;
-- Insight: Shows regional footprint. Useful for planning localized delivery campaigns and hubs.

-- 3. Province-level Customer Concentration
-- Question: How many customers do we have in each province?
SELECT province, COUNT(customer_id) AS customer_count
FROM customers
GROUP BY province
ORDER BY customer_count DESC;
-- Insight: Punjab and Sindh are our primary markets, holding over 65% of the total customer base.

-- 4. High-Value Product Catalog
-- Question: List all products that are priced above 30,000 PKR.
SELECT product_id, product_name, category, selling_price
FROM products
WHERE selling_price > 30000
ORDER BY selling_price DESC;
-- Insight: Primarily identifies smartphones, laptops, and large smart TVs. These are our high-margin inventory items.

-- 5. Customer Age Demographics
-- Question: What is the average, minimum, and maximum age of our customer base?
SELECT MIN(age) AS youngest_customer, MAX(age) AS oldest_customer, AVG(age) AS average_age
FROM customers;
-- Insight: Average age is around 30. Our primary demographic is young working professionals and students.

-- 6. Total Order Volume
-- Question: What is the total number of orders placed in the system?
SELECT COUNT(order_id) AS total_orders
FROM orders;
-- Insight: Baseline transaction count. Shows the scale of operational throughput.

-- 7. Total Historical GMV (Gross Merchandise Value)
-- Question: What is the total revenue generated from all historical orders?
SELECT SUM(total_amount) AS gross_revenue_pkr
FROM orders;
-- Insight: Overall sales volume. Combined with profit analysis, this sets the baseline for financial performance.

-- 8. Payment Method Distribution
-- Question: Count the number of orders placed through each payment method.
SELECT payment_method, COUNT(order_id) AS order_count
FROM orders
GROUP BY payment_method
ORDER BY order_count DESC;
-- Insight: Cash on Delivery (COD) remains the dominant payment method (over 60%), reflecting trust preferences in Pakistan.

-- 9. Checkout Success Rate
-- Question: What is the distribution of payment statuses across orders?
SELECT payment_status, COUNT(order_id) AS order_count
FROM orders
GROUP BY payment_status;
-- Insight: Helps identify digital payment failure rates. High failure rates indicate API or payment gateway issues.

-- 10. Order Fulfillment Funnel
-- Question: What is the breakdown of orders by final status (Delivered, Returned, Cancelled)?
SELECT order_status, COUNT(order_id) AS order_count
FROM orders
GROUP BY order_status;
-- Insight: Returns and Cancellations are leakage points. High return rates directly affect logistics costs.

-- 11. Top Selling Categories
-- Question: Count the number of products available in each category.
SELECT category, COUNT(product_id) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;
-- Insight: Shows product diversity. Electronics and Mobiles & Tablets have high product variety.

-- 12. Marketing Channel Signup Performance
-- Question: Which channels are driving the most customer signups?
SELECT signup_channel, COUNT(customer_id) AS signup_count
FROM customers
GROUP BY signup_channel
ORDER BY signup_count DESC;
-- Insight: Facebook Ads and Google Ads are the top drivers. TikTok shows potential among younger cohorts.

-- 13. Average Order Value (AOV)
-- Question: What is the average order value across all successful deliveries?
SELECT AVG(total_amount) AS average_order_value_pkr
FROM orders
WHERE order_status = 'Delivered';
-- Insight: AOV helps in determining pricing strategies and setting discount thresholds (e.g. Free Delivery above PKR 3,000).

-- 14. Average Discount Amount
-- Question: What is the total and average discount amount applied across all orders?
SELECT SUM(discount_applied) AS total_discount_given, AVG(discount_applied) AS avg_discount_per_order
FROM orders;
-- Insight: High discount averages reduce gross margin. Must be balanced against customer acquisition targets.

-- 15. Total Marketing Spend
-- Question: What is the total marketing spend across all campaigns?
SELECT SUM(spend_pkr) AS total_marketing_spend_pkr
FROM marketing_campaigns;
-- Insight: Total marketing investment. Used to calculate overall customer acquisition costs.

-- 16. Campaign Volume and Conversion
-- Question: List all campaigns that generated more than 5,000 conversions.
SELECT campaign_name, channel, conversions, revenue_generated_pkr
FROM marketing_campaigns
WHERE conversions > 5000
ORDER BY conversions DESC;
-- Insight: Identifies mega campaigns like 11.11 and Eid festivals that achieve high volume conversions.

-- 17. Delivery Courier Partner Market Share
-- Question: How many deliveries were handled by each courier partner?
SELECT courier_partner, COUNT(delivery_id) AS delivery_count
FROM deliveries
GROUP BY courier_partner
ORDER BY delivery_count DESC;
-- Insight: DEX handles the majority of shipments, especially in Tier-1 cities. TCS and Leopards manage regional/out-of-reach delivery.

-- 18. Average Customer Delivery Rating
-- Question: What is the average customer delivery rating?
SELECT AVG(customer_rating) AS average_delivery_rating
FROM deliveries
WHERE customer_rating > 0;
-- Insight: Delivery ratings reflect logistics performance. Ratings below 4.0 warrant investigation into delayed deliveries.

-- 19. Un-Delivered/Returned Shipments
-- Question: How many deliveries were returned to sender?
SELECT COUNT(delivery_id) AS returned_deliveries
FROM deliveries
WHERE delivery_status = 'Returned to Sender';
-- Insight: Returned packages represent wasted logistics costs (double shipping fees).

-- 20. Total Units Sold
-- Question: What is the total quantity of items sold historically?
SELECT SUM(quantity) AS total_units_sold
FROM order_items;
-- Insight: Measures physical inventory throughput.

-- 21. Specific Product Sales Tracker
-- Question: Find the total revenue and units sold for "Redmi Note 13".
SELECT p.product_name, SUM(oi.quantity) AS units_sold, SUM(oi.net_amount) AS revenue_pkr
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE p.product_name = 'Redmi Note 13'
GROUP BY p.product_name;
-- Insight: Monitors sales velocity for key items. Helps in forecasting stock replenishment.

-- 22. Customers in KPK and Balochistan
-- Question: List the customer count in KPK and Balochistan.
SELECT province, COUNT(customer_id) AS customer_count
FROM customers
WHERE province IN ('KPK', 'Balochistan')
GROUP BY province;
-- Insight: These represent frontier expansion zones. Logistics constraints there limit market size.

-- 23. Orders in Eid Shopping Season (March 2024)
-- Question: Count the number of orders placed in March 2024 (Ramzan/Eid season).
SELECT COUNT(order_id) AS march_2024_orders
FROM orders
WHERE order_date BETWEEN '2024-03-01 00:00:00' AND '2024-03-31 23:59:59';
-- Insight: Measures seasonality impact. March represents a high-growth seasonal window.

-- 24. Low-Performing Products Catalog
-- Question: List all products where cost price is greater than 85% of the selling price.
SELECT product_name, category, cost_price, selling_price, (cost_price / selling_price) * 100 AS cost_ratio
FROM products
WHERE cost_price > (selling_price * 0.85);
-- Insight: Identifies low-margin products. These items are vulnerable to discounts and may dilute overall profits.

-- 25. Average Shipping Cost per Delivery
-- Question: What is the average delivery charge applied to our orders?
SELECT AVG(delivery_charges) AS average_delivery_charge_pkr
FROM deliveries;
-- Insight: Average shipping cost. Used to set baseline delivery fees for customers.
