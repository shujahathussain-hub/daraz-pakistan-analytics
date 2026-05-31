import os
import pandas as pd
import numpy as np

print("Running Data Cleaning Pipeline...")

# Create processed directory
os.makedirs("Data/processed", exist_ok=True)

# Load raw files
df_cust = pd.read_csv("Data/customers.csv")
df_prod = pd.read_csv("Data/products.csv")
df_ord = pd.read_csv("Data/orders.csv")
df_items = pd.read_csv("Data/order_items.csv")
df_deliv = pd.read_csv("Data/deliveries.csv")
df_camp = pd.read_csv("Data/marketing_campaigns.csv")

# 1. Clean Customers
df_cust["customer_name"] = df_cust["customer_name"].str.strip().str.title()
df_cust["city"] = df_cust["city"].str.strip()
df_cust["province"] = df_cust["province"].str.strip()
df_cust["signup_date"] = pd.to_datetime(df_cust["signup_date"])
df_cust["signup_channel"] = df_cust["signup_channel"].str.strip()

# Add Age Group
bins = [0, 25, 35, 50, 100]
labels = ["18-25 (Gen Z)", "26-35 (Young Millennials)", "36-50 (Older Millennials)", "50+ (Gen X/Boomers)"]
df_cust["age_group"] = pd.cut(df_cust["age"], bins=bins, labels=labels)

# 2. Clean Products
df_prod["product_name"] = df_prod["product_name"].str.strip()
df_prod["category"] = df_prod["category"].str.strip()
df_prod["sub_category"] = df_prod["sub_category"].str.strip()

# Add markup %
df_prod["markup_percentage"] = ((df_prod["selling_price"] - df_prod["cost_price"]) / df_prod["cost_price"]) * 100

# 3. Clean Orders
df_ord["order_date"] = pd.to_datetime(df_ord["order_date"])
df_ord["payment_method"] = df_ord["payment_method"].str.strip()
df_ord["payment_status"] = df_ord["payment_status"].str.strip()
df_ord["order_status"] = df_ord["order_status"].str.strip()

# 4. Clean Order Items
# Make sure no negative revenue/profit
df_items["net_amount"] = df_items["net_amount"].clip(lower=0)
df_items["net_profit"] = df_items["net_profit"]  # profit can be negative if high discounts

# 5. Clean Deliveries
df_deliv["shipment_date"] = pd.to_datetime(df_deliv["shipment_date"])
df_deliv["delivery_date"] = pd.to_datetime(df_deliv["delivery_date"], errors="coerce")
df_deliv["delivery_status"] = df_deliv["delivery_status"].str.strip()
df_deliv["courier_partner"] = df_deliv["courier_partner"].str.strip()

# Calculate transit days
df_deliv["transit_days"] = (df_deliv["delivery_date"] - df_deliv["shipment_date"]).dt.days

# Handle missing ratings (if any) or fill them realistically
# Rating can be null for cancelled orders where customer didn't receive it
# Let's check ratings where delivery status is "Returned to Sender" or "Delayed"
df_deliv["customer_rating"] = df_deliv["customer_rating"].fillna(-1)

# 6. Clean Campaigns
df_camp["campaign_date"] = pd.to_datetime(df_camp["campaign_date"])
df_camp["campaign_name"] = df_camp["campaign_name"].str.strip()
df_camp["channel"] = df_camp["channel"].str.strip()

# Add ROI and CTR
df_camp["roi"] = df_camp["revenue_generated_pkr"] / df_camp["spend_pkr"]
df_camp["ctr_percentage"] = (df_camp["clicks"] / df_camp["impressions"]) * 100
df_camp["cvr_percentage"] = (df_camp["conversions"] / df_camp["clicks"]) * 100
df_camp["cac_pkr"] = df_camp["spend_pkr"] / df_camp["conversions"]

# Save processed CSVs
df_cust.to_csv("Data/processed/customers_cleaned.csv", index=False)
df_prod.to_csv("Data/processed/products_cleaned.csv", index=False)
df_ord.to_csv("Data/processed/orders_cleaned.csv", index=False)
df_items.to_csv("Data/processed/order_items_cleaned.csv", index=False)
df_deliv.to_csv("Data/processed/deliveries_cleaned.csv", index=False)
df_camp.to_csv("Data/processed/marketing_campaigns_cleaned.csv", index=False)

print("Data cleaning completed successfully. Processed files written to Data/processed/.")
