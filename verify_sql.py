import sqlite3
import pandas as pd
import re

print("==================================================")
print("POPULATING SQL DATABASE AND RUNNING VERIFICATION")
print("==================================================")

# Create/Connect to database
db_path = "Data/daraz_pakistan.db"
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# 1. Execute schema.sql to create tables and indexes
print("Creating tables and indexes from schema.sql...")
with open("SQL/schema.sql", "r") as f:
    schema_sql = f.read()

# Execute script (SQLite executes multiple commands separated by semicolon)
cursor.executescript(schema_sql)
conn.commit()
print("Database schema created successfully.")

# 2. Populate tables using Pandas
print("\nLoading CSVs and populating tables...")
tables_csvs = {
    "customers": "Data/processed/customers_cleaned.csv",
    "products": "Data/processed/products_cleaned.csv",
    "orders": "Data/processed/orders_cleaned.csv",
    "order_items": "Data/processed/order_items_cleaned.csv",
    "deliveries": "Data/processed/deliveries_cleaned.csv",
    "marketing_campaigns": "Data/processed/marketing_campaigns_cleaned.csv"
}

for table, csv in tables_csvs.items():
    df = pd.read_csv(csv)
    # Write to table (if it exists, append or replace - we want to keep schema, so we append)
    df.to_sql(table, conn, if_exists="append", index=False)
    print(f"- Loaded {df.shape[0]} records into table '{table}' from {csv}.")

conn.commit()
print("All tables populated successfully.")

# 3. Verify a sample query from each file to check compatibility
def extract_queries(file_path):
    with open(file_path, "r") as f:
        content = f.read()
    
    # Strip comments and split by semicolon
    # Simple regex to remove SQL comments
    content_clean = re.sub(r'--.*$', '', content, flags=re.MULTILINE)
    content_clean = re.sub(r'/\*.*?\*/', '', content_clean, flags=re.DOTALL)
    
    queries = [q.strip() for q in content_clean.split(";") if q.strip()]
    return queries

print("\nVerifying SQL queries execution...")
for query_file in ["SQL/01_beginner_queries.sql", "SQL/02_intermediate_queries.sql", "SQL/03_advanced_queries.sql"]:
    print(f"\nParsing queries in {query_file}...")
    queries = extract_queries(query_file)
    print(f"Found {len(queries)} queries. Testing syntax for each...")
    
    executed_count = 0
    error_count = 0
    for idx, query in enumerate(queries):
        # We don't execute EXPLAIN QUERY PLAN or queries that are very specific to some configurations if they fail on SQLite features
        if "EXPLAIN" in query.upper() or "INDEXED BY" in query.upper():
            # Skip SQLite-specific indexed queries that might fail if indexing names have differences, or test them
            pass
        try:
            # Let's run a test select to check syntax
            # SQLite allows executing standard queries
            # Limit returned rows for safety
            test_query = f"{query} LIMIT 1" if "LIMIT" not in query.upper() and "GROUP BY" not in query.upper() and "UNION" not in query.upper() else query
            # Wait, modifying queries might break syntax for complex CTEs, let's run the raw query but fetch only first 1 row
            cursor.execute(query)
            cursor.fetchone()
            executed_count += 1
        except Exception as e:
            error_count += 1
            print(f"Error on Query {idx+1}: {e}")
            print(f"Query content:\n{query}\n")
            
    print(f"File {query_file}: Checked {len(queries)} queries. Success: {executed_count}, Errors: {error_count}")

conn.close()
print("\nSQL populating and verification script complete.")
