CREATE DATABASE retail_sales

CREATE TABLE RETAIL_SALES (
	TRANSACTIONS_ID INT PRIMARY KEY,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(10),
	AGE INT,
	CATEGORY VARCHAR(35),
	QUANTITY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALE FLOAT
);

-- Display All Data
SELECT
	*
FROM
	RETAIL_SALES;

-- count number of Rows in the Dataset (2000)
SELECT
	COUNT(*)
FROM
	RETAIL_SALES;

--count unique customer_id in the datasets (155)
SELECT
	COUNT(DISTINCT CUSTOMER_ID)
FROM
	RETAIL_SALES;

-- see how manu null values are present (13rows)
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTITY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL;

-- Deleting NULL values 
DELETE FROM RETAIL_SALES
WHERE
	SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR CUSTOMER_ID IS NULL
	OR GENDER IS NULL
	OR AGE IS NULL
	OR CATEGORY IS NULL
	OR QUANTITY IS NULL
	OR PRICE_PER_UNIT IS NULL
	OR COGS IS NULL;

--(Optional) to combine date and time columns into timestamp new column
ALTER TABLE RETAIL_SALES
ADD COLUMN SALE_TIMESTAMP TIMESTAMP;

UPDATE RETAIL_SALES
SET
	SALE_TIMESTAMP = SALE_DATE + SALE_TIME;

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05';

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT
  *
FROM retail_sales
WHERE
    category = 'Clothing'AND
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'AND
    quantity >= 4

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT
    category, -- (1st column in select)
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1 -- (group by 1st column in select(category))

-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retail_sales
WHERE total_sale > 1000

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP
    BY
    category,
    gender
ORDER BY 1

-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT
       year,
       month,
    avg_sale
FROM
(
SELECT
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT
    category,
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)

SELECT
    shift,
    COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift
