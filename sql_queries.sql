-- ============================================================
-- Retail Sales Portfolio Project - SQL queries (MySQL)
-- Database: retail_project | Table: sales
-- Source: retail_sales_clean_data.csv (cleaned in Python)
-- NOTE: column names follow the cleaned CSV headers. If your table
-- uses different names (e.g. order_year), adjust them before running.
-- ============================================================

USE retail_project;

-- 21. Total sales and profit per year
SELECT `Order Year`,
       ROUND(SUM(Sales), 2)  AS total_sales,
       ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY `Order Year`
ORDER BY `Order Year`;

-- 22. Top 5 customers by total sales
SELECT `Customer ID`,
       ROUND(SUM(Sales), 2) AS total_sales
FROM sales
GROUP BY `Customer ID`
ORDER BY total_sales DESC
LIMIT 5;
-- Expected: C1400 8,271.71 | C1072 7,848.64 | C1479 7,184.71 | C1200 7,069.55 | C1069 6,682.96

-- 23. Sales by Region and Category, highest first
SELECT Region, Category,
       ROUND(SUM(Sales), 2) AS total_sales
FROM sales
GROUP BY Region, Category
ORDER BY total_sales DESC;

-- 24. Month-over-month sales growth using LAG()
WITH monthly AS (
    SELECT `Order Year` AS yr,
           `Order Month Num` AS mth,
           SUM(Sales) AS sales
    FROM sales
    GROUP BY `Order Year`, `Order Month Num`
)
SELECT yr, mth,
       ROUND(sales, 2) AS sales,
       ROUND(LAG(sales) OVER (ORDER BY yr, mth), 2) AS prev_month_sales,
       ROUND((sales - LAG(sales) OVER (ORDER BY yr, mth))
             / LAG(sales) OVER (ORDER BY yr, mth) * 100, 2) AS mom_growth_pct
FROM monthly
ORDER BY yr, mth;

-- 25. Rank products inside each Category by profit
SELECT Category, `Product Name`,
       ROUND(SUM(Profit), 2) AS total_profit,
       DENSE_RANK() OVER (PARTITION BY Category ORDER BY SUM(Profit) DESC) AS profit_rank
FROM sales
GROUP BY Category, `Product Name`;

-- 26. Customers with more than 10 orders
SELECT `Customer ID`,
       COUNT(DISTINCT `Order ID`) AS orders
FROM sales
GROUP BY `Customer ID`
HAVING COUNT(DISTINCT `Order ID`) > 10
ORDER BY orders DESC;

-- 27. Running total of sales per month
WITH monthly AS (
    SELECT `Order Year` AS yr,
           `Order Month Num` AS mth,
           SUM(Sales) AS sales
    FROM sales
    GROUP BY `Order Year`, `Order Month Num`
)
SELECT yr, mth,
       ROUND(sales, 2) AS sales,
       ROUND(SUM(sales) OVER (ORDER BY yr, mth), 2) AS running_total
FROM monthly
ORDER BY yr, mth;

-- 28. Average delivery days per Ship Mode
SELECT `Ship Mode`,
       ROUND(AVG(`Delivery Days`), 2) AS avg_delivery_days
FROM sales
GROUP BY `Ship Mode`
ORDER BY avg_delivery_days;

-- 29. Return rate per Region
SELECT Region,
       COUNT(DISTINCT `Order ID`) AS total_orders,
       COUNT(DISTINCT CASE WHEN Returned = 'Yes' THEN `Order ID` END) AS returned_orders,
       ROUND(COUNT(DISTINCT CASE WHEN Returned = 'Yes' THEN `Order ID` END)
             / COUNT(DISTINCT `Order ID`) * 100, 2) AS return_rate_pct
FROM sales
GROUP BY Region
ORDER BY return_rate_pct DESC;
-- Overall return rate: 12.11% (4,847 unique orders)

-- 30. View: monthly KPIs
CREATE OR REPLACE VIEW v_monthly_kpi AS
SELECT `Order Year`      AS order_year,
       `Order Month Num` AS order_month,
       ROUND(SUM(Sales), 2)  AS total_sales,
       ROUND(SUM(Profit), 2) AS total_profit,
       COUNT(DISTINCT `Order ID`) AS total_orders
FROM sales
GROUP BY `Order Year`, `Order Month Num`;

SELECT * FROM v_monthly_kpi ORDER BY order_year, order_month;

-- 31. Normalization challenge: customers / products / orders
-- (Replace with your own tested CREATE TABLE ... SELECT DISTINCT statements.
--  Example of the pattern, using the columns present in your table:)
-- CREATE TABLE customers AS
--   SELECT DISTINCT `Customer ID`, `Customer Name`, Segment FROM sales;
-- CREATE TABLE products AS
--   SELECT DISTINCT `Product Name`, Category FROM sales;
-- CREATE TABLE orders AS
--   SELECT `Order ID`, `Customer ID`, `Product Name`, Region, Sales, Profit,
--          Returned, `Order Year`, `Order Month Num`
--   FROM sales;
--
-- Query rebuilt with JOIN: sales by customer segment
-- SELECT c.Segment, ROUND(SUM(o.Sales), 2) AS total_sales
-- FROM orders o
-- JOIN customers c ON o.`Customer ID` = c.`Customer ID`
-- GROUP BY c.Segment
-- ORDER BY total_sales DESC;
