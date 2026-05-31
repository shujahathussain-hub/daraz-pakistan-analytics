import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

print("Running Exploratory Data Analysis (EDA)...")

# Ensure assets directory exists
os.makedirs("assets/plots", exist_ok=True)

# Load cleaned data
df_cust = pd.read_csv("Data/processed/customers_cleaned.csv")
df_ord = pd.read_csv("Data/processed/orders_cleaned.csv")
df_deliv = pd.read_csv("Data/processed/deliveries_cleaned.csv")
df_prod = pd.read_csv("Data/processed/products_cleaned.csv")

# Set visualization style
sns.set_theme(style="whitegrid")
plt.rcParams["font.size"] = 12
plt.rcParams["figure.figsize"] = (10, 6)

# 1. Order Status Distribution
plt.figure()
sns.countplot(data=df_ord, x="order_status", palette=["#00C853", "#E53935", "#FFB300"])
plt.title("Order Status Distribution")
plt.xlabel("Order Status")
plt.ylabel("Number of Orders")
plt.tight_layout()
plt.savefig("assets/plots/order_status_distribution.png", dpi=150)
plt.close()

# 2. Delivery Customer Ratings Distribution (excluding missing/unrated)
plt.figure()
valid_ratings = df_deliv[df_deliv["customer_rating"] > 0]
sns.countplot(data=valid_ratings, x="customer_rating", palette="Blues_d")
plt.title("Distribution of Customer Delivery Ratings")
plt.xlabel("Rating (1-5)")
plt.ylabel("Number of Deliveries")
plt.tight_layout()
plt.savefig("assets/plots/delivery_ratings.png", dpi=150)
plt.close()

# 3. Monthly Orders Trend
df_ord["order_month"] = pd.to_datetime(df_ord["order_date"]).dt.to_period("M")
monthly_orders = df_ord.groupby("order_month").size().reset_index(name="order_count")
monthly_orders["order_month"] = monthly_orders["order_month"].astype(str)

plt.figure(figsize=(12, 6))
sns.lineplot(data=monthly_orders, x="order_month", y="order_count", marker="o", color="#0B1F3A", linewidth=2.5)
plt.xticks(rotation=45)
plt.title("Monthly Order Volume (2024 - 2026)")
plt.xlabel("Month")
plt.ylabel("Total Orders")
plt.tight_layout()
plt.savefig("assets/plots/monthly_order_trends.png", dpi=150)
plt.close()

# 4. Age Distribution of Customers
plt.figure()
sns.histplot(data=df_cust, x="age", bins=15, kde=True, color="#00C853")
plt.title("Customer Age Profile")
plt.xlabel("Age")
plt.ylabel("Frequency")
plt.tight_layout()
plt.savefig("assets/plots/age_distribution.png", dpi=150)
plt.close()

# 5. Payment Method Share
plt.figure()
df_ord["payment_method"].value_counts().plot.pie(
    autopct="%1.1f%%", 
    colors=["#0B1F3A", "#FFB300", "#00C853", "#E53935"], 
    startangle=90, 
    textprops={'fontsize': 12, 'color': 'black'}
)
plt.title("Payment Method Share")
plt.ylabel("")
plt.tight_layout()
plt.savefig("assets/plots/payment_method_share.png", dpi=150)
plt.close()

print("EDA completed. Plots saved to assets/plots/.")
