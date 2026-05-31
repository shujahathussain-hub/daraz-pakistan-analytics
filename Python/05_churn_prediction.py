import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix, roc_auc_score, roc_curve
from sklearn.preprocessing import LabelEncoder

print("Running Customer Churn Prediction Model...")

# Ensure directories exist
os.makedirs("Data/processed", exist_ok=True)
os.makedirs("assets/plots", exist_ok=True)
os.makedirs("Reports", exist_ok=True)

# Load datasets
df_cust = pd.read_csv("Data/processed/customers_cleaned.csv")
df_rfm = pd.read_csv("Data/processed/customer_rfm.csv")
df_ord = pd.read_csv("Data/processed/orders_cleaned.csv")
df_deliv = pd.read_csv("Data/processed/deliveries_cleaned.csv")

# 1. Feature Engineering
# Calculate late delivery rate per customer
# Late is defined as delivery_status == "Delayed"
cust_orders = df_ord.merge(df_deliv, on="order_id", how="inner")
cust_delivery_stats = cust_orders.groupby("customer_id").agg({
    "delivery_status": lambda x: sum(x == "Delayed") / len(x) if len(x) > 0 else 0.0,
    "customer_rating": lambda x: np.mean(x[x > 0]) if sum(x > 0) > 0 else 3.5, # mean of valid ratings, default to neutral 3.5
    "order_status": lambda x: sum(x == "Returned") / len(x) if len(x) > 0 else 0.0 # return rate
}).rename(columns={
    "delivery_status": "late_delivery_rate",
    "customer_rating": "average_rating",
    "order_status": "return_rate"
})

# Merge demographics, RFM, and delivery metrics
features = df_rfm[["customer_id", "recency", "frequency", "monetary", "age", "gender", "province", "signup_channel", "is_churned"]].copy()
features = features.merge(cust_delivery_stats, on="customer_id", how="left")

# Fill missing values for customers with no orders
features["late_delivery_rate"] = features["late_delivery_rate"].fillna(0.0)
features["average_rating"] = features["average_rating"].fillna(3.5)
features["return_rate"] = features["return_rate"].fillna(0.0)

# Encode categorical features
cat_cols = ["gender", "province", "signup_channel"]
encoders = {}
for col in cat_cols:
    le = LabelEncoder()
    features[col] = le.fit_transform(features[col].astype(str))
    encoders[col] = le

# Separate features (X) and target (y)
X = features.drop(columns=["customer_id", "is_churned"])
y = features["is_churned"]

# Train-Test Split (80/20)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

# Fit Random Forest Classifier
rf_model = RandomForestClassifier(n_estimators=100, max_depth=6, random_state=42)
rf_model.fit(X_train, y_train)

# Predictions
y_pred = rf_model.predict(X_test)
y_prob = rf_model.predict_proba(X_test)[:, 1]

# Model Metrics
report = classification_report(y_test, y_pred)
roc_auc = roc_auc_score(y_test, y_prob)
conf_matrix = confusion_matrix(y_test, y_pred)

print(f"Random Forest Churn Model Training Complete.")
print(f"ROC-AUC Score: {roc_auc:.4f}")
print("Classification Report:")
print(report)

# Save Metrics Report
with open("Reports/churn_model_metrics.txt", "w") as f:
    f.write("==================================================\n")
    f.write("RANDOM FOREST CUSTOMER CHURN PREDICTION REPORT\n")
    f.write("==================================================\n\n")
    f.write(f"ROC-AUC Score: {roc_auc:.4f}\n\n")
    f.write("Classification Report:\n")
    f.write(report)
    f.write("\nConfusion Matrix:\n")
    f.write(f"{conf_matrix}\n\n")
    f.write("Features Analyzed:\n")
    for col in X.columns:
        f.write(f"- {col}\n")

# Feature Importance Analysis
importances = rf_model.feature_importances_
feature_names = X.columns
df_importance = pd.DataFrame({
    "feature": feature_names,
    "importance": importances
}).sort_values(by="importance", ascending=False)

# Plot Feature Importance
plt.figure()
sns.barplot(data=df_importance, x="importance", y="feature", palette="mako")
plt.title("Customer Churn: Feature Importance")
plt.xlabel("Importance Score")
plt.ylabel("Feature")
plt.tight_layout()
plt.savefig("assets/plots/churn_feature_importance.png", dpi=150)
plt.close()

# Plot ROC Curve
fpr, tpr, _ = roc_curve(y_test, y_prob)
plt.figure()
plt.plot(fpr, tpr, color="darkorange", lw=2, label=f"ROC Curve (AUC = {roc_auc:.2f})")
plt.plot([0, 1], [0, 1], color="navy", lw=2, linestyle="--")
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")
plt.title("Receiver Operating Characteristic (ROC) Curve")
plt.legend(loc="lower right")
plt.tight_layout()
plt.savefig("assets/plots/churn_roc_curve.png", dpi=150)
plt.close()

# Save probabilities back to RFM file for Power BI integration
df_rfm["churn_probability"] = rf_model.predict_proba(X)[:, 1]
df_rfm.to_csv("Data/processed/customer_rfm.csv", index=False)

print("Churn model metrics written to Reports/churn_model_metrics.txt.")
print("ROC Curve and Feature Importance plots saved to assets/plots/.")
print("Predictions appended to Data/processed/customer_rfm.csv.")
