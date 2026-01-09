CREATE TABLE super_store_sales (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    region VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name TEXT,
    sales NUMERIC(10,2),
    quantity INT,
    discount NUMERIC(4,2),
    profit NUMERIC(10,2)
);

-- =====================================================

--  IMPORT CSV DATA (Change path if needed)
COPY super_store_sales
FROM 'C:/temp/super_store_sales.csv'
DELIMITER ','
CSV HEADER;

-- =====================================================

--  DATA CHECK
SELECT * FROM super_store_sales LIMIT 10;
SELECT COUNT(*) AS total_orders FROM super_store_sales;

-- =====================================================

-- TOTAL SALES & TOTAL PROFIT
SELECT 
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM super_store_sales;

-- =====================================================

--  SALES BY CATEGORY
SELECT 
    category,
    ROUND(SUM(sales),2) AS total_sales
FROM super_store_sales
GROUP BY category
ORDER BY total_sales DESC;

-- =====================================================

-- SALES BY SUB-CATEGORY
SELECT 
    sub_category,
    ROUND(SUM(sales),2) AS total_sales
FROM super_store_sales
GROUP BY sub_category
ORDER BY total_sales DESC;

-- =====================================================

--  PROFIT VS LOSS ORDERS
SELECT 
    CASE 
        WHEN profit > 0 THEN 'Profit'
        ELSE 'Loss'
    END AS profit_status,
    COUNT(*) AS total_orders
FROM super_store_sales
GROUP BY profit_status;

-- =====================================================

--  REGION-WISE SALES
SELECT 
    region,
    ROUND(SUM(sales),2) AS region_sales
FROM super_store_sales
GROUP BY region
ORDER BY region_sales DESC;

-- =====================================================

--  TOP 10 CITIES BY SALES
SELECT 
    city,
    ROUND(SUM(sales),2) AS total_sales
FROM super_store_sales
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;

-- =====================================================

--  CUSTOMER SEGMENT PERFORMANCE
SELECT 
    segment,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(profit),2) AS total_profit
FROM super_store_sales
GROUP BY segment;

-- =====================================================

--  DISCOUNT IMPACT ON PROFIT
SELECT 
    discount,
    ROUND(AVG(profit),2) AS avg_profit
FROM super_store_sales
GROUP BY discount
ORDER BY discount;

-- =====================================================

--  BEST SELLING PRODUCTS
SELECT 
    product_name,
    SUM(quantity) AS total_quantity
FROM super_store_sales
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 10;

-- =====================================================

--  MONTHLY SALES TREND
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    ROUND(SUM(sales),2) AS monthly_sales
FROM super_store_sales
GROUP BY month
ORDER BY month;

-- =====================================================

-- LOSS MAKING SUB-CATEGORIES
SELECT 
    sub_category,
    ROUND(SUM(profit),2) AS total_loss
FROM super_store_sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_loss;

-- =====================================================

--  HIGH DISCOUNT BUT LOSS ORDERS
SELECT 
    order_id,
    sales,
    discount,
    profit
FROM super_store_sales
WHERE discount >= 0.3
AND profit < 0;

-- =====================================================

--  CREATE VIEW FOR DASHBOARD (POWER BI / TABLEAU)
CREATE OR REPLACE VIEW super_store_dashboard AS
SELECT 
    order_date,
    region,
    category,
    sub_category,
    segment,
    sales,
    profit,
    discount,
    quantity
FROM super_store_sales;




