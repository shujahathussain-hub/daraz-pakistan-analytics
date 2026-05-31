# Interview Preparation Handbook & Master Q&A
**Company: Daraz Pakistan (E-Commerce)**
**Focus: Data Analyst Portfolio Preparation**

This handbook prepares candidates to confidently present this portfolio project during interviews with recruiters, hiring managers, and technical panels.

---

## 1. Project Walkthroughs

### 1.1 The 2-Minute Elevator Pitch
"I built an end-to-end Data Analytics portfolio project focused on **Daraz Pakistan**, the country’s leading e-commerce platform. The project investigates a classic business challenge: slowing customer retention and logistics leakages over a 2-year period. 

Using a Star Schema database in SQL, I wrote 75 analytical queries to segment customers and audit delivery SLA breaches. I then built a Python pipeline to clean raw transaction records, calculate monthly revenue forecasts using Holt-Winters, and train a Random Forest churn classifier achieving 93% accuracy. Finally, I built a 5-page Power BI dashboard incorporating custom JSON themes, RFM segments, and interactive tooltips.

The key business finding was that customers whose first delivery was delayed experienced a 50% churn rate compared to 20% for on-time deliveries, showing the critical importance of a first impression. I proposed a priority lane for first orders and cashbacks to reduce Cash on Delivery (COD) returns. Executing this playbook is projected to reduce churn to under 30% and save PKR 12.4M in double-shipping return fees."

### 1.2 The 5-Minute Technical Pitch
*   **The Business Problem**: slowing top-line revenue, an executive-level customer churn rate of 47.5%, and profit margins eroded by high return-to-sender rates on Cash on Delivery orders (18.2%).
*   **Data Architecture**: Mapped 10,000+ transaction lines into a SQL Star Schema containing tables for orders, order items, deliveries, customers, products, and marketing campaigns.
*   **SQL Analytics**: Developed 75 structured queries ranging from simple joins to advanced window functions. Computed rolling 3-month sales averages, SQL-based cohort matrices, and SLA breaches by courier partner.
*   **Python Engine**: Engineered a Python pipeline. Used Holt-Winters Exponential Smoothing to forecast revenue (predicting PKR 50.7M for the November 11.11 spike). Built a Scikit-Learn Random Forest model identifying that recency and first-order delay rates are the strongest predictors of churn.
*   **Power BI Visualizations**: Designed a modern Navy/Green/Gold executive dashboard tracking 30+ DAX measures, dynamic parameters, and key operational metrics.
*   **Strategic Recommendations**: Shift remote KPK/Punjab delivery volumes away from underperforming couriers (Leopards), prioritize first-time buyers' orders, and incentivize pre-paid payments to bypass COD returns.

### 1.3 The 10-Minute Executive Walkthrough
1.  **Slide 1-2 (Problem)**: Open by showing that top-line GMV grew by 18.2% to PKR 542M, but profitability is leaking. Point to the customer churn rate of 47.5%.
2.  **Slide 3-4 (Methodology)**: Walk through the star schema and index design that optimizes query execution. Explain the Python pipeline that loads, cleans, and runs predictive models on the data.
3.  **Slide 5-6 (Retention & Operations)**: Present the cohort retention heatmap. Highlight that 35% of customers churn in Month 1. Pivot to logistics: Leopard Courier has a 30% SLA breach rate, which directly triggers customer churn.
4.  **Slide 7-8 (Predictive Analysis)**: Detail the Random Forest model results: first-order delay increases churn likelihood to 50%. Present the Holt-Winters forecast showing the 11.11 sales surge, warning of stockouts.
5.  **Slide 9-10 (Strategy & Impact)**: Outline the prescriptive recommendations. Emphasize that adding a flat COD fee and Easypaisa prepaid cashbacks will lower returns and save PKR 12.4M annually.

---

## 2. Hiring Manager Behavioral Questions

### Q1: Why did you choose this project?
"I chose Daraz Pakistan because it is the largest e-commerce platform in the country, presenting complex operational and logistics challenges. E-commerce allowed me to combine customer analytics (RFM and churn prediction) with logistics data (courier SLAs and returns), creating a multi-dimensional project that reflects actual business operations."

### Q2: What business value did it create?
"The project translates data into concrete financial impacts. By identifying that Leopard Courier's 30% SLA breach rate drives a 50% churn rate among first-time buyers, I was able to propose shifting delivery volumes and introducing prepaid wallet incentives. This directly targets a reduction in churn and saves PKR 12.4M in wasted return logistics costs."

### Q3: What challenges did you face?
"The biggest challenge was handling the volume of Cash on Delivery checkouts, which makes up 65% of the market. COD orders have a high return rate. I resolved this by designing SQL queries to isolate COD return patterns and engineering a machine learning feature that calculates return rates by province to feed the churn model."

### Q4: What would you improve?
"If I had more data, I would integrate real-time clickstream data to track shopping cart abandonment patterns. I would also test more complex deep learning models for time-series forecasting."

### Q5: What was your biggest insight?
"The 'First Order SLA' insight: discovering that the very first delivery experience is a binary gate for customer retention. A delay on order 1 increases churn risk to 50%. This taught me that operations and customer experience are tightly linked."

---

## 3. Technical Q&A Bank (210 Questions & Answers)

### 3.1 SQL Technical Questions (50 Q&As)
1.  **Q: What is the difference between JOIN and LEFT JOIN?**
    - *A*: JOIN (Inner) returns rows with matching keys in both tables; LEFT JOIN returns all rows from the left table and matched rows from the right table, filling mismatches with NULLs.
2.  **Q: How do you handle NULL values in a join?**
    - *A*: SQL joins ignore NULL values. To preserve rows with NULL keys, use a LEFT JOIN or check for NULLs using `COALESCE`.
3.  **Q: What is a CTE and why use it?**
    - *A*: A Common Table Expression (CTE) is a temporary result set defined within the execution scope of a query. It improves readability and structure compared to nested subqueries.
4.  **Q: Explain the window function `ROW_NUMBER()`.**
    - *A*: Assigns a unique sequential integer to rows within a partition, ordered by a specified column.
5.  **Q: What is the difference between `RANK()` and `DENSE_RANK()`?**
    - *A*: `RANK()` skips ranks after ties (e.g. 1, 2, 2, 4); `DENSE_RANK()` does not skip ranks (e.g. 1, 2, 2, 3).
6.  **Q: How does `LAG()` work?**
    - *A*: Accesses data from a previous row in the same result set without a self-join. Useful for MoM growth.
7.  **Q: What is the purpose of database indexes?**
    - *A*: Speed up select queries by creating a pointer structure, reducing full table scans.
8.  **Q: How do indexes impact write performance?**
    - *A*: They slow down INSERT, UPDATE, and DELETE operations because the index must be updated.
9.  **Q: What is database normalization?**
    - *A*: Structuring a database to reduce data redundancy and improve data integrity (e.g. separating customers from orders).
10. **Q: Explain a Star Schema.**
    - *A*: A database design where a central Fact table (e.g. Orders) is surrounded by related Dimension tables (e.g. Customers, Products).
11. **Q: What is a Fact table?**
    - *A*: A table containing quantitative metrics, measurements, or events (e.g. transaction prices and quantities).
12. **Q: What is a Dimension table?**
    - *A*: A table containing descriptive attributes or context about a business entity (e.g. customer name and city).
13. **Q: How do you select rows containing a specific string pattern?**
    - *A*: Use the `LIKE` operator with wildcard characters (e.g. `LIKE '%Ali%'`).
14. **Q: What is the difference between WHERE and HAVING?**
    - *A*: `WHERE` filters rows before aggregation; `HAVING` filters aggregated groups after `GROUP BY`.
15. **Q: What does the `EXPLAIN QUERY PLAN` command do?**
    - *A*: Reveals the database optimizer's execution strategy, showing if indexes are being used.
16. **Q: How do you calculate a running total in SQL?**
    - *A*: Use `SUM(column) OVER (ORDER BY date_column ROWS UNBOUNDED PRECEDING)`.
17. **Q: How do you extract the month from a timestamp in SQLite?**
    - *A*: Use `STRFTIME('%m', date_column)`.
18. **Q: What is a cross join?**
    - *A*: Returns the Cartesian product of two tables, matching every row of the first table with every row of the second.
19. **Q: What is the purpose of `COALESCE`?**
    - *A*: Returns the first non-NULL value in a list of arguments. Useful for replacing NULLs with defaults.
20. **Q: How do you implement conditional logic in SQL?**
    - *A*: Use the `CASE WHEN condition THEN result ELSE default END` statement.
21. **Q: What is a composite key?**
    - *A*: A primary key consisting of two or more columns that uniquely identify a row.
22. **Q: How do you avoid duplicate rows in a query output?**
    - *A*: Use the `DISTINCT` keyword.
23. **Q: What are database foreign keys?**
    - *A*: A column or group of columns that enforces a link between data in two tables, ensuring referential integrity.
24. **Q: What is a self-join?**
    - *A*: A query in which a table is joined with itself. Useful for hierarchical data or finding pairs.
25. **Q: What is the difference between UNION and UNION ALL?**
    - *A*: `UNION` combines result sets and removes duplicate rows; `UNION ALL` keeps all rows, including duplicates, and is faster.
26. **Q: How do you find the second highest order value in SQL?**
    - *A*: Use `ORDER BY total_amount DESC LIMIT 1 OFFSET 1`.
27. **Q: Explain `PARTITION BY` in window functions.**
    - *A*: Divides the result set into partitions to apply the window function independently (e.g. ranking products within each category).
28. **Q: What is an aggregate function?**
    - *A*: A function that performs a calculation on multiple values and returns a single value (e.g. `SUM`, `AVG`, `COUNT`).
29. **Q: How do you filter orders placed on weekends?**
    - *A*: In SQLite, use `STRFTIME('%w', order_date) IN ('0', '6')` where 0 is Sunday and 6 is Saturday.
30. **Q: What is referential integrity?**
    - *A*: A state where all foreign key values in a table point to valid primary keys in parent tables.
31. **Q: What are the main ACID properties in databases?**
    - *A*: Atomicity, Consistency, Isolation, Durability. They guarantee transaction reliability.
32. **Q: How does indexing impact database storage?**
    - *A*: Indexes occupy additional disk space.
33. **Q: What is a subquery?**
    - *A*: A query nested inside another query (e.g. in the WHERE clause).
34. **Q: What is the difference between a correlated and non-correlated subquery?**
    - *A*: A correlated subquery references columns from the outer query and executes repeatedly; a non-correlated query runs once independently.
35. **Q: How do you calculate a 3-month moving average in SQL?**
    - *A*: Use `AVG(revenue) OVER (ORDER BY year_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)`.
36. **Q: What is the default sort order of `ORDER BY`?**
    - *A*: Ascending (`ASC`).
37. **Q: How do you check for missing/null values in SQL?**
    - *A*: Use the `IS NULL` operator.
38. **Q: What does `GROUP BY 1, 2` mean?**
    - *A*: Groups by the first and second columns specified in the `SELECT` list.
39. **Q: What is the function of `NTILE(N)`?**
    - *A*: Divides an ordered partition into N groups and assigns a bucket number to each row. Useful for RFM scoring.
40. **Q: How do you calculate profit margin percentage in SQL?**
    - *A*: Use `(SUM(net_profit) / SUM(net_amount)) * 100`.
41. **Q: Can you use aliases in the WHERE clause?**
    - *A*: No, because the `WHERE` clause is evaluated before the `SELECT` clause in SQL execution order.
42. **Q: What is the SQL execution order?**
    - *A*: FROM -> JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT.
43. **Q: Explain a non-clustered index.**
    - *A*: A separate database structure that points to the physical storage locations of table rows.
44. **Q: What is the default port for PostgreSQL?**
    - *A*: `5432`.
45. **Q: How do you count only distinct occurrences of a column in SQL?**
    - *A*: Use `COUNT(DISTINCT column_name)`.
46. **Q: What is data redundancy?**
    - *A*: The duplicate storage of the same data fields in multiple tables, which normalize databases aim to prevent.
47. **Q: What is a primary key?**
    - *A*: A column or set of columns that uniquely identifies each row in a table. It cannot contain NULLs.
48. **Q: How do you delete a table structure from a database?**
    - *A*: Use the `DROP TABLE table_name;` command.
49. **Q: What is the difference between `DELETE` and `TRUNCATE`?**
    - *A*: `DELETE` removes rows conditionally and logs each row delete; `TRUNCATE` removes all rows, is faster, and cannot be rolled back easily.
50. **Q: What is a database schema?**
    - *A*: The formal definition of tables, columns, indexes, and relationships in a database.

---

### 3.2 Python Technical Questions (50 Q&As)
51. **Q: What is Pandas?**
    - *A*: A fast, powerful open-source library for data manipulation and analysis in Python.
52. **Q: What is a Pandas DataFrame?**
    - *A*: A 2-dimensional, size-mutable, tabular data structure with labeled axes (rows and columns).
53. **Q: How do you read a CSV file in Pandas?**
    - *A*: Use `pd.read_csv("file.csv")`.
54. **Q: How do you handle missing values in Pandas?**
    - *A*: Use `.fillna(value)` to replace them, or `.dropna()` to remove rows/columns containing missing values.
55. **Q: Explain `.loc` vs `.iloc`.**
    - *A*: `.loc` is label-based indexing; `.iloc` is integer-position-based indexing.
56. **Q: How do you filter rows in a DataFrame based on a condition?**
    - *A*: Use boolean indexing (e.g. `df[df['age'] > 30]`).
57. **Q: What does the `.groupby()` function do?**
    - *A*: Splits data into groups based on criteria, applies a function to each group, and combines the results.
58. **Q: How do you check for duplicate rows in a DataFrame?**
    - *A*: Use `df.duplicated().sum()`.
59. **Q: What is NumPy?**
    - *A*: A Python library for working with multi-dimensional arrays, matrices, and mathematical functions.
60. **Q: What is the difference between a Python list and a NumPy array?**
    - *A*: NumPy arrays are homogeneous (same type), use less memory, and support vectorized element-wise operations.
61. **Q: How do you merge two DataFrames in Pandas?**
    - *A*: Use `pd.merge(df1, df2, on='key_column', how='inner')`.
62. **Q: What does the `.apply()` function do in Pandas?**
    - *A*: Applies a custom function along an axis of the DataFrame or Series.
63. **Q: How do you convert a column to datetime in Pandas?**
    - *A*: Use `pd.to_datetime(df['date_column'])`.
64. **Q: Explain `.value_counts()`.**
    - *A*: Returns a Series containing counts of unique values in descending order. Useful for frequency analysis.
65. **Q: How do you save a DataFrame to a CSV file?**
    - *A*: Use `df.to_csv("output.csv", index=False)`.
66. **Q: What is Scikit-Learn?**
    - *A*: A Python library for machine learning, providing tools for classification, regression, and clustering.
67. **Q: What is a train-test split?**
    - *A*: Dividing data into training (e.g. 80%) and testing (e.g. 20%) sets to evaluate model performance on unseen data.
68. **Q: What is a Random Forest Classifier?**
    - *A*: An ensemble machine learning model that fits multiple decision trees and aggregates their predictions to improve accuracy and control overfitting.
69. **Q: Explain ROC-AUC score.**
    - *A*: Receiver Operating Characteristic - Area Under Curve. Measures a classifier's ability to distinguish between classes (1.0 is perfect, 0.5 is random guessing).
70. **Q: What is a Confusion Matrix?**
    - *A*: A table summarizing classification model performance, showing True Positives, True Negatives, False Positives, and False Negatives.
71. **Q: What is the difference between Precision and Recall?**
    - *A*: Precision is the ratio of correctly predicted positive observations to total predicted positives; Recall is the ratio to all actual positives.
72. **Q: What is the F1-Score?**
    - *A*: The harmonic mean of Precision and Recall. Best for evaluating models with imbalanced datasets.
73. **Q: How do you extract feature importances from a Random Forest model?**
    - *A*: Access the `.feature_importances_` attribute after fitting the model.
74. **Q: What is time-series forecasting?**
    - *A*: Using historical time-stamped data to predict future values.
75. **Q: What is Holt-Winters Exponential Smoothing?**
    - *A*: A forecasting algorithm that models trend and seasonality over time.
76. **Q: What is the difference between additive and multiplicative seasonality?**
    - *A*: Additive seasonality has a constant seasonal amplitude; multiplicative seasonality has seasonal fluctuations that scale with the trend.
77. **Q: How do you reset a DataFrame index?**
    - *A*: Use `df.reset_index(inplace=True)`.
78. **Q: What is Seaborn?**
    - *A*: A Python data visualization library based on Matplotlib that provides a high-level interface for drawing statistical graphics.
79. **Q: How do you create a correlation heatmap in Python?**
    - *A*: Use `sns.heatmap(df.corr(), annot=True)`.
80. **Q: How do you drop a column from a DataFrame?**
    - *A*: Use `df.drop(columns=['column_name'], inplace=True)`.
81. **Q: What is Label Encoding?**
    - *A*: Converting categorical text labels into unique numerical integers.
82. **Q: Explain overfitting in machine learning.**
    - *A*: A scenario where a model learns training data noise, performing well on training data but poorly on unseen test data.
83. **Q: How do you prevent overfitting in Random Forests?**
    - *A*: Restrict `max_depth`, increase `min_samples_split`, or use cross-validation.
84. **Q: What is the purpose of the `random_state` parameter?**
    - *A*: Sets a seed for random number generators to ensure code execution is reproducible.
85. **Q: What is Matplotlib?**
    - *A*: The core plotting library in Python, on which libraries like Seaborn are built.
86. **Q: How do you handle outliers in Python?**
    - *A*: Clip values, remove rows based on z-scores, or use interquartile range (IQR) thresholds.
87. **Q: Explain the `pd.cut()` function.**
    - *A*: Segments and sorts data values into bins. Useful for converting continuous ages into discrete age groups.
88. **Q: What is vectorization in Pandas?**
    - *A*: Running operations on entire arrays instead of looping through individual rows, which increases execution speed.
89. **Q: How do you check DataFrame column data types?**
    - *A*: Use `df.dtypes` or `df.info()`.
90. **Q: Explain list comprehension in Python.**
    - *A*: A concise way to create lists using a single line of code (e.g. `[x**2 for x in range(10)]`).
91. **Q: What is the difference between `append` and `concat` in Pandas?**
    - *A*: `pd.concat` is more general and efficient, allowing concatenation along rows or columns; `append` has been deprecated in newer Pandas versions.
92. **Q: How do you handle date indexing in time series?**
    - *A*: Convert date strings to datetime objects and set them as the DataFrame index using `df.set_index()`.
93. **Q: What is Statsmodels?**
    - *A*: A Python package that provides classes and functions for estimating statistical models and performing statistical tests.
94. **Q: What is the purpose of `plt.tight_layout()`?**
    - *A*: Automatically adjusts subplot parameters to give plots clean padding.
95. **Q: How do you calculate percentages inside a groupby aggregation?**
    - *A*: Use `df.groupby('group').size() / len(df) * 100`.
96. **Q: What is the difference between classification and regression?**
    - *A*: Classification predicts discrete class labels (e.g. churn = 1 or 0); regression predicts continuous numerical values (e.g. future sales revenue).
97. **Q: Explain the utility of `df.sample()`.**
    - *A*: Returns a random sample of items from an axis of a DataFrame. Useful for bootstrapping.
98. **Q: What is cross-validation?**
    - *A*: A resampling procedure used to evaluate machine learning models on a limited data sample by partitioning it into folds.
99. **Q: How do you list files in a directory using Python?**
    - *A*: Use `os.listdir(path)`.
100. **Q: What does the `sys.executable` parameter do?**
     - *A*: Returns the absolute path of the executable binary for the running Python interpreter.

---

### 3.3 Power BI & DAX Questions (30 Q&As)
101. **Q: What is Power BI?**
     - *A*: A business analytics service by Microsoft that provides interactive visualizations and business intelligence capabilities.
102. **Q: What is DAX?**
     - *A*: Data Analysis Expressions. A library of formulas and operators used to build formulas and expressions in Power BI.
103. **Q: Explain the difference between a Calculated Column and a Measure.**
     - *A*: Calculated Columns are computed during data load and occupy disk space; Measures are calculated dynamically at query execution based on visual filters.
104. **Q: What is the Power BI Filter Context?**
     - *A*: The filtering applied to a visual based on row and column coordinates, slicers, and report filters.
105. **Q: What is Row Context in DAX?**
     - *A*: The concept of the current row during iteration. Used in calculated columns or iterator functions (e.g. `SUMX`).
106. **Q: How do you change filter context in DAX?**
     - *A*: Use the `CALCULATE` function.
107. **Q: What does the `DIVIDE` function do?**
     - *A*: Performs division and automatically handles division-by-zero errors by returning a specified default value (e.g. 0).
108. **Q: Explain the DAX Time Intelligence function `SAMEPERIODLASTYEAR`.**
     - *A*: Returns a set of dates in the prior year corresponding to the dates in the current filter context.
109. **Q: How does `TOTALYTD` work?**
     - *A*: Evaluates the year-to-date value of an expression in the current filter context.
110. **Q: What is the difference between `SUM` and `SUMX`?**
     - *A*: `SUM` aggregates a single column; `SUMX` is an iterator that evaluates an expression for each row of a table and then sums the results.
111. **Q: How do you create a relationship between two tables in Power BI?**
     - *A*: Map the primary key of a dimension table to the foreign key of a fact table in the Model view.
112. **Q: What is cross-filtering direction?**
     - *A*: Defines how filters propagate between tables. Can be Single (one-way) or Both (two-way). Single is preferred to avoid ambiguity.
113. **Q: What are Field Parameters?**
     - *A*: A feature allowing users to dynamically change measures or columns displayed in visuals using a slicer.
114. **Q: What is a Power BI Bookmark?**
     - *A*: Saves the current configured view of a report page (filters, visual visibility), allowing custom navigation flows.
115. **Q: What is drill-through in Power BI?**
     - *A*: Allows users to right-click a data point in a visual and navigate to a detailed report page filtered on that specific entity.
116. **Q: Explain Tooltip Pages.**
     - *A*: Designing a custom report page that appears as a pop-up when hovering over data points in a visual.
117. **Q: What is Power Query?**
     - *A*: The data transformation and ETL engine in Power BI, using the M formula language.
118. **Q: What is the M language?**
     - *A*: The functional language used behind the scenes in Power Query to define ETL transformation steps.
119. **Q: What is the Power BI Gateway?**
     - *A*: Software required to keep on-premises data sources updated by facilitating secure data transfer between sources and the Power BI service.
120. **Q: Explain the Key Influencers visual.**
     - *A*: An AI-driven visual that analyzes data, ranks the factors that influence a target metric, and displays them.
121. **Q: What is the Decomposition Tree visual?**
     - *A*: An AI visual that allows users to drill down into dimensions to understand the root drivers of aggregated values.
122. **Q: How do you implement conditional formatting in Power BI?**
     - *A*: Access the visual formatting options and set color rules based on measures or values.
123. **Q: What does the `ALL` function do in DAX?**
     - *A*: Ignores all filters applied to a table or column, returning all rows. Useful for calculating share percentages.
124. **Q: Explain `CALCULATE(Total, ALL(table))`.**
     - *A*: Computes the total metric across the entire table, bypassing slicers or visual coordinates.
125. **Q: What is Star Schema database design in Power BI?**
     - *A*: Modeling data using central fact tables joined to surrounding dimension tables. It is the recommended best practice.
126. **Q: What is a snowflaked dimension?**
     - *A*: A dimension table that has been normalized and splits into sub-dimension tables. Try to avoid this to keep models simple.
127. **Q: How do you format currency dynamically in Power BI?**
     - *A*: Use the format settings or DAX `FORMAT(value, "Currency_String")`.
128. **Q: Explain what a date table is and why it's required.**
     - *A*: A table containing continuous dates. It is required for Time Intelligence functions to calculate periods correctly.
129. **Q: What is the difference between Power BI Desktop and Power BI Service?**
     - *A*: Desktop is a local application used for authoring and modeling; Service is cloud-based, used for publishing and sharing reports.
130. **Q: How do you define a custom theme in Power BI?**
     - *A*: Import a structured JSON theme file specifying default color palettes and visual styles.

---

### 3.4 Statistics Technical Questions (20 Q&As)
131. **Q: What is the Central Limit Theorem?**
     - *A*: States that the distribution of sample means approaches a normal distribution as sample size increases, regardless of the population distribution.
132. **Q: Explain the difference between Mean, Median, and Mode.**
     - *A*: Mean is the arithmetic average; Median is the middle value when sorted; Mode is the most frequent value.
133. **Q: When is the Median preferred over the Mean?**
     - *A*: When the dataset is highly skewed or contains extreme outliers (e.g. e-commerce purchase values skewed by VIP customers).
134. **Q: What is Standard Deviation?**
     - *A*: A metric measuring the dispersion of data points relative to their mean.
135. **Q: What is a z-score?**
     - *A*: The number of standard deviations a data point is from the mean.
136. **Q: Explain the difference between Descriptive and Inferential Statistics.**
     - *A*: Descriptive statistics summarize historical data characteristics; Inferential statistics make predictions about a population based on sample data.
137. **Q: What is a Hypothesis Test?**
     - *A*: A statistical method used to determine if there is enough evidence in a sample to support a specific hypothesis.
138. **Q: What is the p-value?**
     - *A*: The probability of obtaining test results at least as extreme as the observed results, assuming the null hypothesis is true. A p-value < 0.05 indicates statistical significance.
139. **Q: Explain Type I vs Type II Errors.**
     - *A*: Type I is a False Positive (rejecting a true null hypothesis); Type II is a False Negative (failing to reject a false null hypothesis).
140. **Q: What is correlation?**
     - *A*: A statistical measure of the strength and direction of the linear relationship between two variables. It does not imply causation.
141. **Q: What is linear regression?**
     - *A*: A statistical method that models the relationship between a dependent variable and one or more independent variables.
142. **Q: What is multicollinearity?**
     - *A*: A scenario in regression where two or more independent variables are highly correlated, which can distort model coefficients.
143. **Q: Explain R-squared.**
     - *A*: The proportion of variance in the dependent variable that is predictable from the independent variables.
144. **Q: What is the difference between correlation and causation?**
     - *A*: Correlation shows a relationship between variables; causation proves that change in one variable directly causes change in the other.
145. **Q: What is a normal distribution?**
     - *A*: A symmetric, bell-shaped probability distribution where the mean, median, and mode are equal.
146. **Q: What is skewed data?**
     - *A*: A distribution that is asymmetrical. Positive skew has a long right tail; negative skew has a long left tail.
147. **Q: Explain the Interquartile Range (IQR).**
     - *A*: The range between the 25th percentile (Q1) and 75th percentile (Q3), representing the middle 50% of the data.
148. **Q: How do you identify outliers using IQR?**
     - *A*: Any data point below `Q1 - 1.5 * IQR` or above `Q3 + 1.5 * IQR`.
149. **Q: What is the difference between sample and population?**
     - *A*: Population is the entire dataset; sample is a representative subset selected from the population.
150. **Q: What is A/B testing?**
     - *A*: A statistical experiment comparing two versions (A and B) to determine which performs better based on metrics.

---

### 3.5 Business Analysis Questions (20 Q&As)
151. **Q: What is the primary role of a Business Analyst?**
     - *A*: Bridging the gap between IT and business teams, using data to analyze requirements and deliver recommendations.
152. **Q: What does RFM stand for?**
     - *A*: Recency, Frequency, and Monetary value. A customer segmentation method.
153. **Q: Define Customer Lifetime Value (CLV).**
     - *A*: The total revenue a business expects to earn from a customer throughout their relationship.
154. **Q: What is Customer Acquisition Cost (CAC)?**
     - *A*: The total cost spent to acquire a new customer, calculated as total marketing spend divided by new customers acquired.
155. **Q: Explain ROAS.**
     - *A*: Return on Ad Spend. Total revenue generated from advertising divided by ad spend.
156. **Q: What is Churn Rate?**
     - *A*: The percentage of customers who stop doing business with an entity over a specified period.
157. **Q: Explain GMV.**
     - *A*: Gross Merchandise Value. The total dollar value of sales transactions over a given time period on a platform.
158. **Q: What is AOV?**
     - *A*: Average Order Value. The average amount spent by customers per transaction.
159. **Q: How do you calculate Customer Retention Rate?**
     - *A*: `((E - N) / S) * 100` where E is customers at end of period, N is new customers acquired, and S is customers at start of period.
160. **Q: What is cohort analysis?**
     - *A*: Grouping users who share common characteristics (e.g. signup month) and tracking their behavior over time.
161. **Q: Explain the Pareto Principle (80/20 Rule) in business.**
     - *A*: The concept that roughly 80% of consequences come from 20% of causes (e.g. 20% of customers generate 80% of revenue).
162. **Q: What are KPIs?**
     - *A*: Key Performance Indicators. Quantifiable metrics used to evaluate success against targets.
163. **Q: Explain NPS.**
     - *A*: Net Promoter Score. Measures customer loyalty and likelihood to recommend a brand.
164. **Q: What is a bottleneck?**
     - *A*: A point of congestion in a system (e.g. late couriers) that delays operations.
165. **Q: What is a conversion funnel?**
     - *A*: A structured path a customer takes towards a purchase (e.g. view ad -> click -> checkout).
166. **Q: What is gross margin?**
     - *A*: The difference between revenue and cost of goods sold, divided by revenue.
167. **Q: Explain market basket analysis.**
     - *A*: A modeling technique based on the theory that if you buy a certain group of items, you are more likely to buy another.
168. **Q: What is a SLA?**
     - *A*: Service Level Agreement. A commitment between a service provider and a client regarding service speed and quality.
169. **Q: What is return-on-investment (ROI)?**
     - *A*: A performance measure used to evaluate the efficiency of an investment.
170. **Q: Explain dynamic pricing.**
     - *A*: Adjusting prices in real-time based on demand, supply, and competitor prices.

---

### 3.6 Stakeholder Management Questions (20 Q&As)
171. **Q: How do you communicate technical findings to non-technical stakeholders?**
     - *A*: Avoid technical jargon, focus on business KPIs (revenue, cost, churn), and use clean visualizations.
172. **Q: How do you handle conflicting requests from different directors (e.g. CFO vs CMO)?**
     - *A*: Focus on data-driven trade-offs. Show how CMW discount campaigns (CMO) impact net profit margins (CFO).
173. **Q: What do you do if a stakeholder disagrees with your findings?**
     - *A*: Walk them through the data sources, assumptions, and validation steps. Remain objective.
174. **Q: How do you prioritize requests from multiple stakeholders?**
     - *A*: Evaluate requests using a matrix of business impact versus implementation effort, prioritizing high-impact, low-effort tasks.
175. **Q: What is the best way to present a dashboard to a CEO?**
     - *A*: Keep it to a single page, highlight the primary KPIs first, and focus on the actions recommended based on the data.
176. **Q: How do you handle a change in project requirements mid-way?**
     - *A*: Assess the impact on timelines, update the implementation plan, and align with stakeholders on priority adjustments.
177. **Q: What is a stakeholder analysis?**
     - *A*: Identifying key project stakeholders, mapping their influence, and understanding their goals.
178. **Q: How do you deliver bad news (e.g. project delay or poor campaign performance) to a director?**
     - *A*: Deliver the news early, present the data objectively, and come prepared with options and solutions.
179. **Q: How do you run a project alignment workshop?**
     - *A*: Set clear agendas, prepare mockups, and run interactive Q&A sessions to align on KPIs.
180. **Q: What is the purpose of executive summaries?**
     - *A*: To provide a brief overview of key findings and recommendations for busy executives.
181. **Q: How do you handle pushback on data quality?**
     - *A*: Present the data profiling results, clean-up actions, and error margins.
182. **Q: What are the key KPIs for a COO?**
     - *A*: Delivery speed, courier SLA compliance, return rate, and fulfillment costs.
183. **Q: What are the key KPIs for a CMO?**
     - *A*: Customer acquisition cost (CAC), conversion rates, campaign ROAS, and signup volume.
184. **Q: What are the key KPIs for a CFO?**
     - *A*: Profit margin, cash flow cycle, cost of goods sold, and customer lifetime value.
185. **Q: How do you write a project update report?**
     - *A*: Focus on accomplishments, upcoming milestones, and key risks.
186. **Q: How do you engage disengaged stakeholders?**
     - *A*: Connect the project to their specific targets and KPIs.
187. **Q: What is stakeholder mapping?**
     - *A*: Grouping stakeholders by interest and influence to determine communication strategies.
188. **Q: How do you handle a stakeholder who requests a complex visual that is not a good fit?**
     - *A*: Explain the visual best practices and offer a simpler alternative that answers their question more effectively.
189. **Q: What is scope creep?**
     - *A*: Continuous, uncontrolled growth in project scope without adjustments to time, cost, or resources.
190. **Q: How do you manage scope creep?**
     - *A*: Document requirements, use a formal change request process, and communicate impacts on timelines.

---

### 3.7 Dashboard Design Questions (20 Q&As)
191. **Q: What is the golden rule of dashboard design?**
     - *A*: Design for the end-user. Keep the interface clean, structured, and easy to understand in 30 seconds.
192. **Q: Why avoid pie charts with more than 3 categories?**
     - *A*: They make it hard for the human eye to compare slice angles. Bar charts are better for comparing categories.
193. **Q: What is information hierarchy?**
     - *A*: Placing the most critical KPIs at the top-left (following reading patterns) and detail-oriented charts lower down.
194. **Q: What is the role of white space?**
     - *A*: Gives design breathing room, separates visual components, and reduces cognitive load.
195. **Q: Why use HSL/specific colors over standard bright colors?**
     - *A*: Bright, saturated colors distract users. Curated color palettes build a premium look and direct focus to key insights.
196. **Q: What is visual noise?**
     - *A*: Unnecessary lines, dark backgrounds, or detailed labels that distract from the data.
197. **Q: How do you choose between a table and a visual?**
     - *A*: Use tables for looking up exact numbers; use visuals for identifying trends, comparisons, and relationships.
198. **Q: Why keep page layout consistent?**
     - *A*: Consistency reduces the learning curve as users navigate between pages.
199. **Q: What is cognitive load?**
     - *A*: The mental effort required to process information. Lowering cognitive load makes dashboards more effective.
200. **Q: Why are borders and rounded corners used on visual boxes?**
     - *A*: They frame data points and create a clean interface.
201. **Q: What is the purpose of conditional formatting?**
     - *A*: Directs attention to performance outliers (e.g. green for high performance, red for warnings).
202. **Q: How does color blindness impact dashboard design?**
     - *A*: Can make red-green color indicators hard to read. Use shapes or text labels alongside colors for accessibility.
203. **Q: What is chart junk?**
     - *A*: Graphic elements inside charts that do not represent data (e.g. 3D effects, heavy gridlines).
204. **Q: Why use small multiples?**
     - *A*: Allows users to compare trends across categories in a single visual.
205. **Q: How do you choose the right chart for time series?**
     - *A*: Use line charts, as they are the standard for showing changes over continuous time periods.
206. **Q: What is mobile responsiveness?**
     - *A*: Designing layouts that adjust to fit phone or tablet screens.
207. **Q: What is the role of titles in charts?**
     - *A*: To explain the chart's purpose and key takeaway clearly.
208. **Q: How do you design a dashboard for a non-technical audience?**
     - *A*: Keep visuals simple, explain terms, and use tooltips to provide context.
209. **Q: What is user testing in dashboards?**
     - *A*: Having end-users navigate the dashboard to identify usability issues before launching.
210. **Q: How often should dashboards be updated?**
     - *A*: Depends on the business need. Operations dashboards may update hourly, while executive dashboards update daily or weekly.
