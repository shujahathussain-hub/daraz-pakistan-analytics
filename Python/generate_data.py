import os
import random
import numpy as np
import pandas as pd
from datetime import datetime, timedelta

# Set seed for reproducibility
np.random.seed(42)
random.seed(42)

# Ensure directory exists
os.makedirs("Data", exist_ok=True)

# Configurations
NUM_CUSTOMERS = 2500
NUM_ORDERS = 12000
START_DATE = datetime(2024, 1, 1)
END_DATE = datetime(2026, 5, 31)

print("Starting realistic data generation for Daraz Pakistan Analytics Portfolio...")

# --- 1. GENERATE CUSTOMERS ---
cities_provinces = [
    ("Karachi", "Sindh", 0.35),
    ("Lahore", "Punjab", 0.30),
    ("Islamabad", "Islamabad Capital Territory", 0.10),
    ("Rawalpindi", "Punjab", 0.08),
    ("Faisalabad", "Punjab", 0.05),
    ("Multan", "Punjab", 0.04),
    ("Peshawar", "KPK", 0.04),
    ("Quetta", "Balochistan", 0.02),
    ("Sialkot", "Punjab", 0.01),
    ("Gujranwala", "Punjab", 0.01)
]

cities, provinces, probs = zip(*cities_provinces)
probs = np.array(probs) / sum(probs)  # normalize

first_names = ["Muhammad", "Ahmed", "Ali", "Zain", "Hamza", "Fatima", "Ayesha", "Sana", "Bilal", "Usman", "Omer", "Asad", "Kiran", "Mariam", "Zahra", "Saad", "Tariq", "Hassan", "Sara", "Nida", "Raza", "Yasmin", "Faisal", "Hina", "Amna"]
last_names = ["Khan", "Ahmed", "Ali", "Sheikh", "Malik", "Butt", "Raza", "Iqbal", "Siddiqui", "Abbasi", "Shah", "Mughal", "Dar", "Qureshi", "Gill", "Cheema", "Jatoi", "Farooq", "Baig", "Hashmi"]

channels = ["Facebook Ads", "Google Ads", "TikTok Ads", "Organic", "Direct", "Referral"]
channel_probs = [0.35, 0.20, 0.15, 0.15, 0.10, 0.05]

customer_data = []
for cid in range(1, NUM_CUSTOMERS + 1):
    name = f"{random.choice(first_names)} {random.choice(last_names)}"
    gender = random.choice(["Male", "Female"]) if random.random() > 0.05 else "Other"
    age = int(np.random.normal(30, 8))
    age = max(18, min(65, age))
    
    city_idx = np.random.choice(len(cities), p=probs)
    city = cities[city_idx]
    province = provinces[city_idx]
    
    signup_days_ago = random.randint(0, (END_DATE - START_DATE).days)
    signup_date = START_DATE + timedelta(days=signup_days_ago)
    signup_channel = np.random.choice(channels, p=channel_probs)
    
    customer_data.append({
        "customer_id": cid,
        "customer_name": name,
        "gender": gender,
        "age": age,
        "city": city,
        "province": province,
        "signup_date": signup_date.strftime("%Y-%m-%d"),
        "signup_channel": signup_channel,
        "is_churned": 0 # updated later based on orders
    })

df_customers = pd.DataFrame(customer_data)

# --- 2. GENERATE PRODUCTS ---
categories = {
    "Mobiles & Tablets": [
        ("Smartphones", ["Redmi Note 13", "Infinix Hot 40", "Samsung Galaxy A15", "Tecno Spark 20", "Realme C67"], (25000, 45000)),
        ("Tablets", ["Mi Pad 6", "Lenovo Tab M10", "Realme Pad 2"], (30000, 60000)),
        ("Accessories", ["Mobile Covers", "Tempered Glass", "Fast Chargers", "Power Bank 20000mAh"], (500, 3000))
    ],
    "Electronics": [
        ("Smart TVs", ["TCL 43 Inch Smart TV", "Xiaomi LED TV 32", "Changhong Ruba 40"], (35000, 80000)),
        ("Audio", ["Audionic Airbud 550", "Ronin R-520 Earbuds", "Anker Soundcore Q20"], (2000, 15000)),
        ("Laptops", ["HP EliteBook 840 G6 (Refurbished)", "Dell Latitude 5400", "Lenovo ThinkPad X1 Carbon"], (45000, 120000))
    ],
    "Fashion & Beauty": [
        ("Men's Apparel", ["Unstitched Shalwar Kameez", "Polo T-Shirt", "Casual Denim Jeans"], (1500, 4000)),
        ("Women's Apparel", ["Lawn 3-Piece Suit Unstitched", "Kurti Designer", "Chiffon Dupatta"], (2000, 6000)),
        ("Beauty & Cosmetics", ["Sunscreener SPF 50", "Matte Lipstick Pack", "Hair Serum Organic"], (500, 2500))
    ],
    "Home & Living": [
        ("Kitchen Appliances", ["Anex Juicer Blender", "Westpoint Microwave Oven", "National Roti Maker"], (3500, 15000)),
        ("Home Decor", ["Bedsheet Double King Size", "LED Strip Lights 10m", "Wall Clock Modern"], (1000, 4000))
    ],
    "Groceries": [
        ("Staples", ["Dal Chana 1kg", "Basmati Rice 5kg", "Cooking Oil 5 Litre"], (350, 2500)),
        ("Snacks & Beverages", ["Tapal Danedar Tea 900g", "Potato Chips Carton", "Soft Drink Pack of 6"], (200, 1500))
    ]
}

product_data = []
pid = 1
for cat, subcats in categories.items():
    for subcat, items, price_range in subcats:
        for item in items:
            sell_price = round(random.randint(price_range[0], price_range[1]), -1)
            # typical retail markup is 20% to 50%
            markup = random.uniform(0.15, 0.35)
            cost_price = round(sell_price * (1 - markup), -1)
            
            product_data.append({
                "product_id": pid,
                "product_name": item,
                "category": cat,
                "sub_category": subcat,
                "cost_price": cost_price,
                "selling_price": sell_price
            })
            pid += 1

df_products = pd.DataFrame(product_data)

# --- 3. GENERATE ORDERS & ORDER ITEMS ---
# Order dates will have seasonality:
# - Eid Shopping Spikes: 
#   - Eid 2024: April 10 (Eid shopping spike March 10 to April 9)
#   - Eid 2025: March 31 (Eid shopping spike March 1 to March 30)
# - 11.11 Mega Sale: November 1 to November 15
# - Blessed Friday: November 24 to November 30
# - Weekly pattern: weekend has slightly more orders

order_data = []
order_items_data = []

order_id_counter = 1
item_id_counter = 1

# Generate a list of dates weighted by shopping seasonality
date_list = []
current_d = START_DATE
while current_d <= END_DATE:
    # Baseline probability weights
    weight = 1.0
    
    # 11.11 (Nov 1 to Nov 15)
    if current_d.month == 11 and (1 <= current_d.day <= 15):
        weight *= 4.5
    # Blessed Friday (late Nov)
    elif current_d.month == 11 and (22 <= current_d.day <= 30):
        weight *= 2.5
    # Eid 2024 (March 10 to April 9)
    elif current_d.year == 2024 and ((current_d.month == 3 and current_d.day >= 10) or (current_d.month == 4 and current_d.day <= 9)):
        weight *= 3.0
    # Eid 2025 (March 1 to March 30)
    elif current_d.year == 2025 and (current_d.month == 3):
        weight *= 3.0
    # Ramzan/Eid 2026 (Feb 20 to March 25)
    elif current_d.year == 2026 and ((current_d.month == 2 and current_d.day >= 20) or (current_d.month == 3 and current_d.day <= 25)):
        weight *= 3.0
    
    # Weekend multiplier
    if current_d.weekday() in [5, 6]:
        weight *= 1.2
        
    date_list.append((current_d, weight))
    current_d += timedelta(days=1)

# Normalize weights
dates, weights = zip(*date_list)
weights = np.array(weights)
weights /= sum(weights)

# Let's map customer purchase frequency
# Highly active customers order multiple times, others order once or twice
customer_order_freqs = np.random.zipf(a=1.8, size=NUM_CUSTOMERS)
customer_order_freqs = np.clip(customer_order_freqs, 1, 15)

orders_pool = []
for cid in range(1, NUM_CUSTOMERS + 1):
    num_cust_orders = customer_order_freqs[cid - 1]
    cust_signup_date = datetime.strptime(df_customers.loc[cid - 1, "signup_date"], "%Y-%m-%d")
    
    # Select dates after signup date
    valid_dates_indices = [i for i, d in enumerate(dates) if d >= cust_signup_date]
    if not valid_dates_indices:
        valid_dates_indices = [len(dates) - 1]
        
    valid_dates = [dates[i] for i in valid_dates_indices]
    valid_weights = [weights[i] for i in valid_dates_indices]
    valid_weights = np.array(valid_weights) / sum(valid_weights)
    
    selected_dates = np.random.choice(valid_dates, size=min(num_cust_orders, len(valid_dates)), replace=True, p=valid_weights)
    
    for o_date in selected_dates:
        orders_pool.append((cid, o_date))

# Sort orders by date
orders_pool = sorted(orders_pool, key=lambda x: x[1])
# We want approximately NUM_ORDERS, let's truncate or expand if needed
orders_pool = orders_pool[:NUM_ORDERS]

delivery_data = []
delivery_id_counter = 1

for ord_idx, (cid, o_date) in enumerate(orders_pool):
    order_id = ord_idx + 1
    cust_row = df_customers.loc[cid - 1]
    
    # Choose items in order
    num_items = random.choices([1, 2, 3, 4], weights=[0.60, 0.25, 0.10, 0.05])[0]
    chosen_products = df_products.sample(n=num_items, replace=False)
    
    order_total_amount = 0
    order_cost = 0
    order_profit = 0
    discount_applied = 0
    
    for _, prod in chosen_products.iterrows():
        qty = random.choices([1, 2, 3], weights=[0.85, 0.12, 0.03])[0]
        unit_price = prod["selling_price"]
        # Discount logic
        disc_rate = 0.0
        if random.random() > 0.5:
            disc_rate = random.choices([0.05, 0.10, 0.15, 0.20], weights=[0.40, 0.30, 0.20, 0.10])[0]
            
        gross_amt = qty * unit_price
        disc_amt = gross_amt * disc_rate
        net_amt = gross_amt - disc_amt
        item_cost = qty * prod["cost_price"]
        net_prof = net_amt - item_cost
        
        order_total_amount += net_amt
        order_cost += item_cost
        order_profit += net_prof
        discount_applied += disc_amt
        
        order_items_data.append({
            "order_item_id": item_id_counter,
            "order_id": order_id,
            "product_id": prod["product_id"],
            "quantity": qty,
            "unit_price": unit_price,
            "discount_rate": disc_rate,
            "net_amount": net_amt,
            "item_cost": item_cost,
            "net_profit": net_prof
        })
        item_id_counter += 1
        
    # Order Status & Payment Method
    payment_method = random.choices(["Cash on Delivery", "Easypaisa", "JazzCash", "Credit/Debit Card"], weights=[0.65, 0.15, 0.12, 0.08])[0]
    
    # Cash on Delivery (COD) has high return rate
    # Others have low return rate, but cards have a failure rate during checkout.
    payment_status = "Success"
    if payment_method != "Cash on Delivery" and random.random() < 0.04:
        payment_status = "Failed"
        
    order_status = "Delivered"
    if payment_status == "Failed":
        order_status = "Cancelled"
    else:
        # returns based on payments & province
        # remote provinces have higher delay/return rates
        ret_prob = 0.04
        if payment_method == "Cash on Delivery":
            ret_prob += 0.12  # COD buyers reject deliveries
        if cust_row["province"] in ["Balochistan", "KPK"]:
            ret_prob += 0.06  # delivery transit failures
            
        rand_val = random.random()
        if rand_val < ret_prob:
            order_status = "Returned"
        elif rand_val < ret_prob + 0.03:
            order_status = "Cancelled"  # cancelled before dispatch
            
    # Add to orders
    order_data.append({
        "order_id": order_id,
        "customer_id": cid,
        "order_date": o_date.strftime("%Y-%m-%d %H:%M:%S"),
        "payment_method": payment_method,
        "payment_status": payment_status,
        "total_amount": order_total_amount,
        "discount_applied": discount_applied,
        "order_status": order_status
    })
    
    # Generate delivery record for dispatched orders
    if order_status != "Cancelled" or (order_status == "Cancelled" and random.random() > 0.5):
        # courier partner selection
        couriers = ["Daraz Express (DEX)", "TCS", "Leopard Courier"]
        # DEX handles major cities mostly
        if cust_row["city"] in ["Karachi", "Lahore", "Islamabad"]:
            courier = random.choices(couriers, weights=[0.70, 0.20, 0.10])[0]
        else:
            courier = random.choices(couriers, weights=[0.20, 0.50, 0.30])[0]
            
        ship_days = random.randint(0, 2)
        ship_date = o_date + timedelta(days=ship_days)
        
        # Delivery times by province
        province_transit_days = {
            "Sindh": (1, 4),
            "Punjab": (1, 4),
            "Islamabad Capital Territory": (1, 3),
            "KPK": (3, 8),
            "Balochistan": (4, 10)
        }
        min_d, max_d = province_transit_days.get(cust_row["province"], (2, 6))
        
        # Couriers: DEX is faster, Leopard is slower
        transit_modifier = 0
        if courier == "Daraz Express (DEX)":
            transit_modifier = -1
        elif courier == "Leopard Courier":
            transit_modifier = 1
            
        actual_transit = max(1, random.randint(min_d, max_d) + transit_modifier)
        deliv_date = ship_date + timedelta(days=actual_transit)
        
        # Check if delayed (threshold: 4 days for Sindh/Punjab, 7 days for others)
        thresh = 7 if cust_row["province"] in ["KPK", "Balochistan"] else 4
        
        if order_status == "Returned":
            delivery_status = "Returned to Sender"
            deliv_rating = random.choices([1, 2, 3], weights=[0.60, 0.30, 0.10])[0]
        else:
            if actual_transit > thresh:
                delivery_status = "Delayed"
                deliv_rating = random.choices([1, 2, 3, 4], weights=[0.40, 0.30, 0.20, 0.10])[0]
            else:
                delivery_status = "On Time"
                deliv_rating = random.choices([4, 5, 3], weights=[0.60, 0.30, 0.10])[0]
                
        # Weight delivery charge by weight/city distance
        delivery_charge = 150
        if cust_row["province"] in ["KPK", "Balochistan"]:
            delivery_charge = 250
            
        delivery_data.append({
            "delivery_id": delivery_id_counter,
            "order_id": order_id,
            "courier_partner": courier,
            "shipment_date": ship_date.strftime("%Y-%m-%d %H:%M:%S"),
            "delivery_date": deliv_date.strftime("%Y-%m-%d %H:%M:%S") if order_status != "Cancelled" else "",
            "delivery_status": delivery_status,
            "delivery_charges": delivery_charge,
            "customer_rating": deliv_rating
        })
        delivery_id_counter += 1

df_orders = pd.DataFrame(order_data)
df_order_items = pd.DataFrame(order_items_data)
df_deliveries = pd.DataFrame(delivery_data)

# --- Update Customer Churn Status ---
# A customer is churned if they haven't ordered in the last 90 days of the dataset (i.e. since March 2, 2026)
latest_order_per_customer = df_orders.groupby("customer_id")["order_date"].max()
latest_order_per_customer = pd.to_datetime(latest_order_per_customer)

for idx, row in df_customers.iterrows():
    cid = row["customer_id"]
    if cid in latest_order_per_customer:
        last_date = latest_order_per_customer[cid]
        days_inactive = (END_DATE - last_date).days
        # Churned if inactive > 90 days
        if days_inactive > 90:
            df_customers.at[idx, "is_churned"] = 1
    else:
        # never ordered
        df_customers.at[idx, "is_churned"] = 1

# Save data
df_customers.to_csv("Data/customers.csv", index=False)
df_products.to_csv("Data/products.csv", index=False)
df_orders.to_csv("Data/orders.csv", index=False)
df_order_items.to_csv("Data/order_items.csv", index=False)
df_deliveries.to_csv("Data/deliveries.csv", index=False)


# --- 4. GENERATE MARKETING CAMPAIGNS ---
# We will create a clean monthly marketing performance table
campaigns_list = [
    # 2024 Campaigns
    ("Jan 24 - New Year Bash", "Facebook Ads", 150000, 1500, 2024, 1),
    ("Jan 24 - New Year Bash", "Google Ads", 100000, 800, 2024, 1),
    ("Feb 24 - Valentine Special", "Facebook Ads", 180000, 1900, 2024, 2),
    ("Feb 24 - Valentine Special", "TikTok Ads", 120000, 1400, 2024, 2),
    ("Mar 24 - Ramzan Grocery", "Google Ads", 250000, 2800, 2024, 3),
    ("Mar 24 - Ramzan Grocery", "SMS Marketing", 50000, 900, 2024, 3),
    ("Apr 24 - Eid Shopping Fest", "Facebook Ads", 400000, 4800, 2024, 4),
    ("Apr 24 - Eid Shopping Fest", "TikTok Ads", 300000, 4200, 2024, 4),
    ("Apr 24 - Eid Shopping Fest", "Google Ads", 200000, 2200, 2024, 4),
    ("May 24 - Summer Clearance", "Facebook Ads", 150000, 1300, 2024, 5),
    ("Jun 24 - Tech Bonanza", "Google Ads", 350000, 3200, 2024, 6),
    ("Jul 24 - Monsoon Sale", "TikTok Ads", 100000, 950, 2024, 7),
    ("Aug 24 - Independence Day Mega", "Facebook Ads", 300000, 3600, 2024, 8),
    ("Aug 24 - Independence Day Mega", "TikTok Ads", 200000, 2500, 2024, 8),
    ("Sep 24 - Back to School", "Google Ads", 150000, 1400, 2024, 9),
    ("Oct 24 - Fashion Runway", "Facebook Ads", 200000, 2100, 2024, 10),
    ("Oct 24 - Fashion Runway", "TikTok Ads", 180000, 1950, 2024, 10),
    ("Nov 24 - 11.11 Mega Campaign", "Facebook Ads", 1000000, 15000, 2024, 11),
    ("Nov 24 - 11.11 Mega Campaign", "Google Ads", 800000, 11000, 2024, 11),
    ("Nov 24 - 11.11 Mega Campaign", "TikTok Ads", 700000, 12500, 2024, 11),
    ("Nov 24 - 11.11 Mega Campaign", "SMS Marketing", 150000, 4500, 2024, 11),
    ("Dec 24 - Blessed Friday", "Facebook Ads", 500000, 6800, 2024, 12),
    ("Dec 24 - Blessed Friday", "TikTok Ads", 400000, 5900, 2024, 12),
    # 2025 Campaigns
    ("Jan 25 - Winter Wardrobe", "Facebook Ads", 250000, 2300, 2025, 1),
    ("Jan 25 - Winter Wardrobe", "TikTok Ads", 200000, 2100, 2025, 1),
    ("Feb 25 - Spring Arrivals", "Instagram Ads", 180000, 1750, 2025, 2),
    ("Mar 25 - Ramzan & Eid Fest", "Facebook Ads", 600000, 7200, 2025, 3),
    ("Mar 25 - Ramzan & Eid Fest", "TikTok Ads", 500000, 6800, 2025, 3),
    ("Mar 25 - Ramzan & Eid Fest", "Google Ads", 400000, 4900, 2025, 3),
    ("Mar 25 - Ramzan & Eid Fest", "SMS Marketing", 100000, 2800, 2025, 3),
    ("Apr 25 - Eid Mubarak Sale", "Facebook Ads", 350000, 3900, 2025, 4),
    ("May 25 - Home Makeover", "Google Ads", 250000, 2400, 2025, 5),
    ("Jun 25 - Mobile Fest", "Facebook Ads", 450000, 4200, 2025, 6),
    ("Jun 25 - Mobile Fest", "Google Ads", 400000, 3800, 2025, 6),
    ("Jul 25 - Azadi Prep", "TikTok Ads", 150000, 1400, 2025, 7),
    ("Aug 25 - Azadi Shopping Festival", "Facebook Ads", 500000, 5800, 2025, 8),
    ("Aug 25 - Azadi Shopping Festival", "TikTok Ads", 400000, 5200, 2025, 8),
    ("Sep 25 - Tech Bazaar", "Google Ads", 300000, 2850, 2025, 9),
    ("Oct 25 - Beauty Fest", "Facebook Ads", 250000, 2600, 2025, 10),
    ("Oct 25 - Beauty Fest", "TikTok Ads", 250000, 2900, 2025, 10),
    ("Nov 25 - 11.11 Mega Campaign", "Facebook Ads", 1500000, 22000, 2025, 11),
    ("Nov 25 - 11.11 Mega Campaign", "Google Ads", 1000000, 13500, 2025, 11),
    ("Nov 25 - 11.11 Mega Campaign", "TikTok Ads", 1000000, 17800, 2025, 11),
    ("Nov 25 - 11.11 Mega Campaign", "SMS Marketing", 200000, 5800, 2025, 11),
    ("Dec 25 - Year End Clearance", "Facebook Ads", 600000, 7800, 2025, 12),
    ("Dec 25 - Year End Clearance", "TikTok Ads", 500000, 7100, 2025, 12),
    # 2026 Campaigns
    ("Jan 26 - New Year Resolution", "Google Ads", 200000, 1900, 2026, 1),
    ("Feb 26 - Ramzan Preps", "Facebook Ads", 300000, 3100, 2026, 2),
    ("Mar 26 - Ramzan & Eid Festival", "Facebook Ads", 800000, 9500, 2026, 3),
    ("Mar 26 - Ramzan & Eid Festival", "TikTok Ads", 700000, 9200, 2026, 3),
    ("Mar 26 - Ramzan & Eid Festival", "Google Ads", 500000, 6100, 2026, 3),
    ("Apr 26 - Eid Gala", "Facebook Ads", 400000, 4400, 2026, 4),
    ("May 26 - Summer Deals", "TikTok Ads", 200000, 1850, 2026, 5)
]

camp_data = []
for c_id, (name, channel, spend, conversions, year, month) in enumerate(campaigns_list):
    # calculate impressions and clicks based on industry-realistic click-through and conversion rates
    ctr = random.uniform(0.015, 0.035)
    cvr = random.uniform(0.02, 0.05)
    clicks = int(conversions / cvr)
    impressions = int(clicks / ctr)
    
    # Calculate revenue generated based on average order value in November/Eid
    # Make ROI vary by channel: Facebook/Google typically perform better, SMS has low conversions but high ROI due to low spend
    roi_factor = 2.8
    if channel == "SMS Marketing":
        roi_factor = 4.5
    elif channel == "TikTok Ads":
        roi_factor = 2.0
    elif channel == "Google Ads":
        roi_factor = 3.2
    elif channel == "Facebook Ads":
        roi_factor = 3.0
        
    revenue_gen = round(spend * np.random.normal(roi_factor, 0.3), -2)
    
    camp_data.append({
        "campaign_id": c_id + 1,
        "campaign_name": name,
        "channel": channel,
        "spend_pkr": spend,
        "impressions": impressions,
        "clicks": clicks,
        "conversions": conversions,
        "revenue_generated_pkr": revenue_gen,
        "campaign_date": f"{year}-{month:02d}-01"
    })

df_campaigns = pd.DataFrame(camp_data)
df_campaigns.to_csv("Data/marketing_campaigns.csv", index=False)

print(f"Data generation complete! Saved in Data/ directory.")
print(f"Customers: {df_customers.shape[0]}")
print(f"Products: {df_products.shape[0]}")
print(f"Orders: {df_orders.shape[0]}")
print(f"Order Items: {df_order_items.shape[0]}")
print(f"Deliveries: {df_deliveries.shape[0]}")
print(f"Campaigns: {df_campaigns.shape[0]}")
print("Done.")
