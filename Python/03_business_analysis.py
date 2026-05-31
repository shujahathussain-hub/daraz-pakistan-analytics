import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

print("Running Cohort and RFM Business Analysis...")

# Load cleaned data
df_cust = pd.read_csv("Data/processed/customers_cleaned.csv")
df_ord = pd.read_csv("Data/processed/orders_cleaned.csv")
df_items = pd.read_csv("Data/processed/order_items_cleaned.csv")

# Set dataset end date
END_DATE = pd.to_datetime("2026-05-31")

# Convert dates
df_ord["order_date"] = pd.to_datetime(df_ord["order_date"])
df_cust["signup_date"] = pd.to_datetime(df_cust["signup_date"])

# 1. RFM ANALYSIS
# Filter completed (delivered) orders
df_completed_orders = df_ord[df_ord["order_status"] == "Delivered"]

# Aggregate by customer
rfm = df_completed_orders.groupby("customer_id").agg({
    "order_date": lambda x: (END_DATE - x.max()).days, # Recency
    "order_id": "count",                             # Frequency
    "total_amount": "sum"                             # Monetary
}).rename(columns={
    "order_date": "recency",
    "order_id": "frequency",
    "total_amount": "monetary"
})

# Handle customers with no delivered orders (they might have cancelled or returned all)
missing_customers = set(df_cust["customer_id"]) - set(rfm.index)
missing_rfm = pd.DataFrame({
    "recency": [365 * 3] * len(missing_customers),  # High recency (inactive)
    "frequency": [0] * len(missing_customers),
    "monetary": [0.0] * len(missing_customers)
}, index=list(missing_customers))

rfm = pd.concat([rfm, missing_rfm])
rfm.index.name = "customer_id"

# Scoring (Quintiles 1 to 5)
# Note: Lower recency is better (5), higher frequency and monetary is better (5)
rfm["R"] = pd.qcut(rfm["recency"], 5, labels=[5, 4, 3, 2, 1])

# Frequency and Monetary might have duplicates (especially 0 frequency for missing customers)
# We handle duplicates by using rank or custom boundaries
rfm["F"] = pd.qcut(rfm["frequency"].rank(method="first"), 5, labels=[1, 2, 3, 4, 5])
rfm["M"] = pd.qcut(rfm["monetary"].rank(method="first"), 5, labels=[1, 2, 3, 4, 5])

# RFM Score
rfm["rfm_score"] = rfm["R"].astype(str) + rfm["F"].astype(str) + rfm["M"].astype(str)

# Define Customer Segments
def segment_customer(row):
    r, f, m = int(row["R"]), int(row["F"]), int(row["M"])
    score = r + f + m
    
    if r >= 4 and f >= 4 and m >= 4:
        return "Champions"
    elif r >= 3 and f >= 3 and m >= 3:
        return "Loyal Customers"
    elif r >= 4 and f == 1:
        return "New Customers"
    elif r >= 3 and f >= 1 and f <= 2:
        return "Promising / Warm"
    elif r <= 2 and f >= 3:
        return "At Risk / Slipping"
    elif r <= 2 and f >= 1 and f <= 2:
        return "Hibernating"
    else:
        return "Lost / Inactive"

rfm["segment"] = rfm.apply(segment_customer, axis=1)

# Add demographics to RFM
rfm_full = rfm.reset_index().merge(df_cust, on="customer_id")
rfm_full.to_csv("Data/processed/customer_rfm.csv", index=False)

# RFM Segment Visualization
plt.figure(figsize=(12, 6))
segment_counts = rfm_full["segment"].value_counts().reset_index()
sns.barplot(data=segment_counts, x="count", y="segment", palette="viridis")
plt.title("Customer Segments Based on RFM Analysis")
plt.xlabel("Number of Customers")
plt.ylabel("Segment")
plt.tight_layout()
plt.savefig("assets/plots/rfm_segments.png", dpi=150)
plt.close()


# 2. COHORT RETENTION ANALYSIS
# Define cohort month as the customer's signup month
df_cust["cohort_month"] = df_cust["signup_date"].dt.to_period("M")
cust_cohort = df_cust[["customer_id", "cohort_month"]]

# Merge with orders to get transaction months
df_ord_cohort = df_ord.merge(cust_cohort, on="customer_id")
df_ord_cohort["order_month"] = df_ord_cohort["order_date"].dt.to_period("M")

# Calculate periods between signup and order
df_ord_cohort["cohort_index"] = (df_ord_cohort["order_month"].dt.year - df_ord_cohort["cohort_month"].dt.year) * 12 + \
                               (df_ord_cohort["order_month"].dt.month - df_ord_cohort["cohort_month"].dt.month)

# Filter cohort index >= 0
df_ord_cohort = df_ord_cohort[df_ord_cohort["cohort_index"] >= 0]

# Calculate active customers per cohort month and cohort index
cohort_data = df_ord_cohort.groupby(["cohort_month", "cohort_index"])["customer_id"].nunique().reset_index()

# Pivot cohort table
cohort_pivot = cohort_data.pivot(index="cohort_month", columns="cohort_index", values="customer_id")

# Get cohort sizes (number of signups in that month)
cohort_sizes = df_cust.groupby("cohort_month").size()

# Divide columns by cohort sizes to get retention rates
retention = cohort_pivot.divide(cohort_sizes, axis=0) * 100

# Format index for plotting
retention.index = retention.index.astype(str)

# Plot Cohort Retention Heatmap
plt.figure(figsize=(16, 10))
sns.heatmap(retention.iloc[:15, :12], annot=True, fmt=".1f", cmap="Blues", cbar=True)
plt.title("Customer Cohort Retention Rate (%)")
plt.xlabel("Months Since Signup")
plt.ylabel("Cohort Month")
plt.tight_layout()
plt.savefig("assets/plots/cohort_retention_heatmap.png", dpi=150)
plt.close()

# Calculate Customer Lifetime Value (CLV)
# Simple CLV = (Average Order Value * Purchase Frequency) / Churn Rate
avg_order_value = df_completed_orders["total_amount"].mean()
purchase_frequency = df_completed_orders.groupby("customer_id")["order_id"].count().mean()
churn_rate = df_cust["is_churned"].mean()

clv_simple = (avg_order_value * purchase_frequency) / max(0.01, churn_rate)

print("Business analysis results:")
print(f"- Champions: {sum(rfm_full['segment'] == 'Champions')}")
print(f"- Loyal Customers: {sum(rfm_full['segment'] == 'Loyal Customers')}")
print(f"- At Risk: {sum(rfm_full['segment'] == 'At Risk / Slipping')}")
print(f"- Churn Rate: {churn_rate:.2%}")
print(f"- Simple CLV Estimate: PKR {clv_simple:,.2f}")
print("Business analysis completed successfully.")
