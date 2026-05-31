-- Daraz Pakistan E-Commerce Schema Definition
-- Compatible with SQLite, PostgreSQL, and SQL Server

-- Disable foreign key checks for clean recreation
PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS marketing_campaigns;

PRAGMA foreign_keys = ON;

-- 1. Customers Dimension Table
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    gender TEXT,
    age INTEGER,
    city TEXT,
    province TEXT,
    signup_date DATE NOT NULL,
    signup_channel TEXT,
    is_churned INTEGER DEFAULT 0,
    age_group TEXT
);

-- 2. Products Dimension Table
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    sub_category TEXT,
    cost_price REAL NOT NULL,
    selling_price REAL NOT NULL,
    markup_percentage REAL
);

-- 3. Orders Fact Table
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date TIMESTAMP NOT NULL,
    payment_method TEXT,
    payment_status TEXT,
    total_amount REAL,
    discount_applied REAL,
    order_status TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 4. Order Items Fact-Bridge Table
CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER NOT NULL,
    unit_price REAL NOT NULL,
    discount_rate REAL DEFAULT 0.0,
    net_amount REAL NOT NULL,
    item_cost REAL NOT NULL,
    net_profit REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 5. Deliveries Dimension/Fact Table
CREATE TABLE deliveries (
    delivery_id INTEGER PRIMARY KEY,
    order_id INTEGER,
    courier_partner TEXT,
    shipment_date TIMESTAMP,
    delivery_date TIMESTAMP,
    delivery_status TEXT,
    delivery_charges REAL,
    customer_rating INTEGER,
    transit_days INTEGER,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 6. Marketing Campaigns Table (Aggregated)
CREATE TABLE marketing_campaigns (
    campaign_id INTEGER PRIMARY KEY,
    campaign_name TEXT NOT NULL,
    channel TEXT NOT NULL,
    spend_pkr REAL NOT NULL,
    impressions INTEGER,
    clicks INTEGER,
    conversions INTEGER,
    revenue_generated_pkr REAL,
    campaign_date DATE NOT NULL,
    roi REAL,
    ctr_percentage REAL,
    cvr_percentage REAL,
    cac_pkr REAL
);

-- CREATE INDEXES FOR PERFORMANCE OPTIMIZATION
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_deliveries_order_id ON deliveries(order_id);
CREATE INDEX idx_customers_city_province ON customers(city, province);
