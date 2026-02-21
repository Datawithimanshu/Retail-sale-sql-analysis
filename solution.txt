SELECT * FROM online_retail.retail_sale;
USE online_retail;

-- 1) HOW MANY TOTAL ROWS(TRASACTION) ARE IN THE DATASET ?
SELECT COUNT(*) AS total_rows
FROM retail_sale;

-- 2) HOW MANY UNIQUE INVOICE VALUE IN THERE ?
SELECT COUNT(DISTINCT customer_id) AS unique_invoice
FROM retail_sale;

-- 3) HOW MANY UNIQUE CUSTOMERS ARE THERE ?
SELECT COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sale
WHERE customer_id IS NOT NULL;

-- 4) HOW MANY UNIQUE PRODUCT (STOCKCODE) ARE THERE ?
  
  SELECT COUNT(DISTINCT stock_code) AS unique_products
  FROM retail_sale;

-- 5) LIST ALL UNIQUE COUNTRIES AVAILABLE IN THE DATASET 

SELECT DISTINCT country
FROM retail_sale
ORDER BY country;

-- 6) HOW MANY TOTAL TRANSACTION ARE FROM THE UNITED KINGDOM ?

SELECT count(*) AS uk_transaction
FROM retail_sale
WHERE country = 'UNITED KINGDOM';

-- 7) HOW MANY ROWS HAVE A NULL CUSTOMER_ID ?

SELECT count(*) AS null_customer_rows
FROM retail_sale
WHERE customer_id IS NULL;

-- 8) HOW MANY CANCELLED INVOICE ARE THERE (INVOICE NUMBER START WITH'C')

SELECT count(DISTINCT invoice_no) AS Cancelled_invoice
FROM retail_sale
WHERE invoice_no LIKE 'C%';

-- 9) FIND THE MINIMUM, MAXIMUM AND AVERAGE QUANTITY

SELECT
MAX(quantity) AS max_qty,
MIN(quantity) AS min_qty,
AVG(quantity) AS avg_qty
FROM retail_sale;

-- 10) FIND THE MAXIMUM, MINIMUM AND AVERAGE UNITPRICE

SELECT
MAX(unit_price) AS max_unit,
MIN(unit_price) AS min_unit,
AVG(unit_price) AS avg_unit
FROM retail_sale;

-- INTERMEDIATE SQL QUESTION 

-- 11) CALCULATE THE TOTAL REVENUE(QUANTITY * UNIT PRICE)

SELECT SUM(quantity * unit_price) AS total_revenue
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0;

-- 12) CALCULATE TOTAL REVENUE BY COUNTRY

SELECT country,
ROUND(SUM(quantity * unit_price),2) AS revenue
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0 
GROUP BY country
ORDER BY country DESC; 

-- 13) FIND THE TOP 10 COUNTRIES BY TOTAL REVENUE

SELECT country,
ROUND(SUM(quantity * unit_price),2) as total_revenue
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0 
AND unit_price > 0
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 10;

-- 14) FIND THE TOP 10 PRODUCT BY TOTAL REVENUE

SELECT stock_code, description,
ROUND(SUM(quantity * unit_price),2) as revenue
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
GROUP BY stock_code, description
ORDER BY revenue DESC
LIMIT 10;

-- 15) FIND THE TOP 10 PRODUCTS BY TOTAL QUANTITY SOLD

SELECT stock_code, description, 
SUM(quantity) as qty_sold
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0 
GROUP BY stock_code, description
order by qty_sold DESC
LIMIT 10;

-- 16) FIND THE TOP 10 CUSTOMER BY TOTAL REVENUE.

SELECT customer_id,
ROUND(SUM(quantity * unit_price),2) as revenue
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
AND customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY revenue
LIMIT 10;

-- 17) FIND THE TOP 10 CUSTOMERS BY NUMBER OF INVOICES.

SELECT customer_id,
COUNT(DISTINCT 	invoice_no) AS total_invoice
FROM retail_sale
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_invoice
LIMIT 10;

-- 18) CALCULATE THE AVERAGE ORDER VALUE (AOV).

SELECT
ROUND(SUM(quantity * unit_price) / COUNT(DISTINCT invoice_no),2) AS AVG_ORDER
FROM retail_sale
WHERE invoice_no NOT LIKE '%C'
AND quantity > 0
AND unit_price > 0;

-- 19) HIGHEST INVOICE VALUE(MAX BILL).

SELECT invoice_no,
SUM(quantity * unit_price) AS max_bill
FROM retail_sale
WHERE invoice_no NOT LIKE '%C'
AND quantity > 0
AND unit_price > 0
GROUP BY invoice_no
ORDER BY max_bill DESC
LIMIT 1;

-- 20) FIND THE LOWEST INVOICE VALUE (MINIMUM BILL AMOUNT).

SELECT invoice_no,
SUM(quantity * unit_price) AS min_bill
FROM retail_sale
WHERE invoice_no NOT LIKE '%C'
AND quantity > 0 
AND unit_price > 0
GROUP BY invoice_no
ORDER BY min_bill ASC
LIMIT 1;

-- INTERMEDIATE SQL QUESTION (DATA ANALYSIS)

-- 21) CALCULATE TOTAL REVENUE BY YEAR 

SELECT YEAR(invoice_date) AS YEAR,
SUM(quantity * unit_price) AS total_revenue
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
GROUP BY YEAR(invoice_date)
ORDER BY YEAR;

-- 22) CALCULATE TOTAL REVENUE BY MONTH

SELECT DATE_FORMAT(invoice_date, '%y-%m') AS MONTH,
SUM(quantity * unit_price) AS REVENUE
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
GROUP BY DATE_FORMAT(invoice_date, '%y-%m')
ORDER BY MONTH;

-- 23) CALCULATE THE TOTAL NUMBER OF INVOICE PER MONTH.

SELECT DATE_FORMAT(invoice_date,'%Y-%M') AS PER_MONTH,
COUNT(DISTINCT invoice_no) AS TOTALA_INVOICE
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0 
AND unit_price > 0
GROUP BY DATE_FORMAT(invoice_date,'%Y-%M')
ORDER BY PER_MONTH;

-- 24) CALCULATE TOTAL REVENUE PER DAY(DATE ONLY)

SELECT DATE(invoice_date) AS DATE,
SUM(quantity * unit_price) AS REVENUE
FROM retail_sale
WHERE invoice_no NOT LIKE '%C'
AND quantity > 0
AND unit_price > 0
GROUP BY DATE(invoice_date)
ORDER BY DATE;

-- 25) IDENTIFY THE PEAK MONTH(HIGHEST REVENUE)

SELECT DATE_FORMAT(invoice_date,'%Y-%M') AS MONTH,
SUM(quantity * unit_price) AS REVENUE
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
GROUP BY DATE_FORMAT(invoice_date,'%Y-%M') 
ORDER BY REVENUE DESC
LIMIT 1;

-- 26) IDENTIFY THE PEAK SALES DAY(HIGHEST REVENUE).

SELECT DATE(invoice_date) AS DAY,
SUM(quantity * unit_price) AS HIGHEST_REVENUE
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
GROUP BY DATE(invoice_date)
ORDER BY HIGHEST_REVENUE DESC
LIMIT 1;

-- ADVANCE(WINDOW FUNCTION AND CTE)

-- 27) FIND THE PRODUCT IN EACH COUNTRY USING RANKING.

WITH product_sale AS ( SELECT country, stock_code, description,
SUM(quantity * unit_price) AS revenue
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
GROUP BY country, stock_code, description
),
ranked AS ( SELECT *,
DENSE_RANK() OVER( PARTITION BY country ORDER BY REVENUE DESC) AS rnk
FROM product_sale
)
SELECT country, stock_code, description AS revenue
FROM RANKED
WHERE rnk = 1
ORDER BY revenue DESC;
-- This query calculate product- wise revenue for each country, then rank product within each country using DENSE_RANK(), the finally select the top-performing product per country. 

-- 28) CALCULATE RUNNING TOTAL REVENUE OVER TIME.

WITH daily_revenue AS ( SELECT DATE(invoice_date) AS DAY,
SUM(quantity * unit_price) AS revenue
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
GROUP BY DATE(invoice_date)
)
SELECT day,
ROUND(revenue,2) AS revenue,
ROUND(SUM(revenue) OVER (ORDER BY day),2) AS RUNNING_TOTAL
FROM daily_revenue
ORDER BY day;
-- This query first calculate daily revenue and then uses a window function to complete comulative revenue over time, ordered by date.

-- 29) RANK CUSTOMER BASED ON TOTAL REVENUE. 

WITH customer_rev AS (
SELECT customer_id,
SUM(quantity * unit_price) AS revenue
FROM retail_sale
WHERE invoice_no NOT LIKE 'C%'
AND quantity > 0
AND unit_price > 0
AND customer_id IS NOT NULL
GROUP BY customer_id
)
SELECT customer_id,
ROUND(revenue,2) AS revenue,
DENSE_RANK() OVER (ORDER BY revenue DESC) AS customer_rnk
FROM customer_rev
ORDER BY customer_rnk;
-- THIS QUERY FIRST CALCULATE TOTAL REVENUE PER CUSTOMER USING A CTE, THEN APPLIS DENSE_RANK() TO RANK CUSTOMER BASED ON REVENUE IN DESCENDING ORDER. 

-- 30) CALCUALTE MONTH-OVER-MONTH (MoM) REVENUE GROWTH PERCENTAGE

	WITH monthly AS (
    SELECT DATE_FORMAT(invoice_date, '%Y-%M') AS month,
    SUM(quantity * unit_price) AS revenue
    FROM retail_sale
    WHERE invoice_no NOT LIKE 'C%'
    AND quantity > 0
    AND unit_price > 0
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%M')
    )
    SELECT month,
    ROUND(revenue,2) AS revenue,
    ROUND((revenue - LAG(REVENUE) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month) * 100,2) AS mom_growth_percentage
    FROM monthly
    ORDER BY month;
-- THIS QUERY CALCULATE MONTHLY REVENUE THEN MONTH OVER MONTH GROWTH PERCENTAGE USING THE LAG WINDOW FUNCTION TO ACCESS THE PREVIOUS MONTH'S REVENUE. 



