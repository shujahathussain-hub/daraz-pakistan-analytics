import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from statsmodels.tsa.holtwinters import ExponentialSmoothing

print("Running Revenue Forecasting Model...")

# Ensure assets directory exists
os.makedirs("Data/processed", exist_ok=True)
os.makedirs("assets/plots", exist_ok=True)

# Load orders data
df_ord = pd.read_csv("Data/processed/orders_cleaned.csv")
df_ord["order_date"] = pd.to_datetime(df_ord["order_date"])

# Filter completed orders
df_delivered = df_ord[df_ord["order_status"] == "Delivered"]

# Aggregate revenue monthly
df_delivered = df_delivered.set_index("order_date")
monthly_rev = df_delivered["total_amount"].resample("ME").sum().reset_index()
monthly_rev.rename(columns={"total_amount": "revenue"}, inplace=True)

# Format dates for time series
monthly_rev["order_date"] = pd.to_datetime(monthly_rev["order_date"])
monthly_rev.set_index("order_date", inplace=True)

# Verify we have enough data (at least 24 months for seasonality)
print(f"Data points available for forecasting: {len(monthly_rev)}")

# Fit Holt-Winters Exponential Smoothing (additive trend, additive seasonality with 12 months period)
model = ExponentialSmoothing(
    monthly_rev["revenue"],
    trend="add",
    seasonal="add",
    seasonal_periods=12
).fit()

# Forecast next 6 months
forecast_steps = 6
forecast_idx = pd.date_range(start=monthly_rev.index[-1] + pd.offsets.MonthEnd(1), periods=forecast_steps, freq="ME")
forecast_values = model.forecast(forecast_steps)

df_forecast = pd.DataFrame({
    "date": forecast_idx,
    "forecasted_revenue": forecast_values
})

# Save forecast to CSV
df_forecast.to_csv("Data/processed/revenue_forecast.csv", index=False)

# Combine history and forecast for plotting
history = monthly_rev.reset_index()
history.rename(columns={"order_date": "date", "revenue": "historical_revenue"}, inplace=True)

# Plot Forecast
plt.figure(figsize=(12, 6))
plt.plot(history["date"], history["historical_revenue"], marker="o", color="#0B1F3A", label="Historical Revenue", linewidth=2.5)
plt.plot(df_forecast["date"], df_forecast["forecasted_revenue"], marker="s", linestyle="--", color="#FFB300", label="Forecasted Revenue (Next 6 Months)", linewidth=2.5)

# Highlight seasonal months (e.g. November spikes)
for date in history["date"]:
    if date.month == 11:
        plt.axvline(date, color="green", alpha=0.15, linestyle="-")
        plt.text(date, plt.gca().get_ylim()[1]*0.9, "11.11 Spike", color="green", alpha=0.7, rotation=90, ha="right")

plt.title("Daraz Pakistan: Monthly Revenue Forecast (Holt-Winters)")
plt.xlabel("Date")
plt.ylabel("Revenue (PKR)")
plt.legend(loc="upper left")
plt.tight_layout()
plt.savefig("assets/plots/revenue_forecast.png", dpi=150)
plt.close()

print(f"Revenue forecast complete. Forecasted values for next 6 months:")
for idx, row in df_forecast.iterrows():
    print(f"- {row['date'].strftime('%Y-%m')}: PKR {row['forecasted_revenue']:,.2f}")
print("Forecasted dataset written to Data/processed/revenue_forecast.csv.")
