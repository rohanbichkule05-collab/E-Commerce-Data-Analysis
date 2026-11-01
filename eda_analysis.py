import pandas as pd
import matplotlib.pyplot as plt

# Load the simulated portfolio dataset.
df = pd.read_csv("ecommerce_sales_data.csv", parse_dates=["order_date"])

# Data quality and profiling
print("Dataset shape:", df.shape)
print("Missing values by column:\n", df.isna().sum())
print("Duplicate order IDs:", df["order_id"].duplicated().sum())
print(df.describe(include="all"))

# Business KPIs
revenue = df["net_sales"].sum()
profit = df["profit"].sum()
orders = df["order_id"].nunique()
aov = revenue / orders if orders else 0
weighted_margin = profit / revenue * 100 if revenue else 0
print({
    "Total Revenue": round(revenue, 2),
    "Total Profit": round(profit, 2),
    "Total Orders": orders,
    "Average Order Value": round(aov, 2),
    "Overall Profit Margin %": round(weighted_margin, 2),
})

# Monthly revenue trend
monthly = df.groupby(df["order_date"].dt.to_period("M"))["net_sales"].sum()
ax = monthly.plot(kind="line", marker="o", title="Monthly Revenue (Simulated Data)", figsize=(10, 5))
ax.set_xlabel("Month")
ax.set_ylabel("Revenue")
plt.tight_layout()
plt.savefig("monthly_revenue_trend.png", dpi=160, bbox_inches="tight")
plt.close()

# Category analysis
category = df.groupby("category").agg(
    revenue=("net_sales", "sum"),
    profit=("profit", "sum"),
    average_margin_pct=("profit_margin_pct", "mean"),
).sort_values("revenue", ascending=False)
print("\nCategory performance:\n", category)

ax = category["revenue"].sort_values().plot(kind="barh", title="Revenue by Category (Simulated Data)", figsize=(9, 5))
ax.set_xlabel("Revenue")
ax.set_ylabel("Category")
plt.tight_layout()
plt.savefig("category_revenue.png", dpi=160, bbox_inches="tight")
plt.close()

# City and channel analysis
city = df.groupby("city")["net_sales"].sum().sort_values(ascending=False)
channel = df.groupby("channel").agg(
    revenue=("net_sales", "sum"),
    profit=("profit", "sum"),
    orders=("order_id", "count"),
).sort_values("revenue", ascending=False)
print("\nCity performance:\n", city)
print("\nChannel performance:\n", channel)

# Export an augmented file with a month field for Power BI.
df["month"] = df["order_date"].dt.to_period("M").astype(str)
df.to_csv("ecommerce_sales_cleaned.csv", index=False)
