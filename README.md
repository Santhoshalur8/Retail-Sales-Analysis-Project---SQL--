## **Retail Sales Analysis SQL Project**

### **Project Overview**

- **Project Title**: Retail Sales Analysis  
- **Level**: Beginner  
- **Database**: `retail_sales`

This project is designed to demonstrate SQL skills commonly used by data analysts to explore, clean, and analyze retail sales data. It involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering business questions using SQL queries. This is ideal for beginners looking to build a solid foundation in SQL.

---

### **Objectives**

1. **Database Setup**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Insights**: Use SQL queries to answer specific business questions and derive insights.

---

### **Project Structure**

#### **1. Database Setup**

- **Database Creation**: The project starts with creating a database named `retail_database`.
- **Table Creation**: The `retail_sales` table is created to store transaction data, including fields like transaction ID, sale date, time, customer details, product category, quantity, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_database;

CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

#### **2. Data Exploration & Cleaning**

- **Total Records in the Dataset**
```sql
SELECT COUNT(*) FROM retail_sales;
```
- **Unique Customers Count**
```sql
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
```
- **Identifying Unique Product Categories**
```sql
SELECT DISTINCT category FROM retail_sales;
```
- **Checking and Removing NULL Values**
```sql
SELECT * FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
      gender IS NULL OR age IS NULL OR category IS NULL OR
      quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
      gender IS NULL OR age IS NULL OR category IS NULL OR
      quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

---

### **3. Data Analysis & Business Insights**

#### **Key SQL Queries & Their Insights**

1. **Retrieve all sales made on '2022-11-05'**
```sql
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
```

2. **Find clothing sales with quantity > 4 in November 2022**
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity > 4;
```

3. **Total sales by product category**
```sql
SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

4. **Average age of customers who purchased 'Beauty' category products**
```sql
SELECT ROUND(AVG(age), 2) AS avg_age FROM retail_sales WHERE category = 'Beauty';
```

5. **Transactions where total sale is greater than 1000**
```sql
SELECT * FROM retail_sales WHERE total_sale > 1000;
```

6. **Number of transactions per gender in each category**
```sql
SELECT category, gender, COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

7. **Best-selling month in each year**
```sql
SELECT year, month, avg_sale
FROM (
    SELECT EXTRACT(YEAR FROM sale_date) AS year,
           EXTRACT(MONTH FROM sale_date) AS month,
           AVG(total_sale) AS avg_sale,
           RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY year, month
) AS t1
WHERE rank = 1;
```

8. **Top 5 customers based on total sales**
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

9. **Number of unique customers per category**
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

10. **Orders per shift (Morning, Afternoon, Evening)**
```sql
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

---

### **Findings & Insights**

- **Customer Demographics**: Sales are distributed across different age groups and product categories.
- **High-Value Transactions**: Several transactions exceed ₹1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis highlights peak sales periods.
- **Top Customers**: The highest spending customers can be identified.
- **Category Insights**: The most popular product categories and their sales volume are clear.

---

### **Reports & Conclusions**

#### **Key Reports Generated**
- **Sales Summary**: Includes total sales, customer demographics, and category performance.
- **Trend Analysis**: Tracks monthly sales fluctuations and best-performing months.
- **Customer Insights**: Identifies top-spending customers and unique customer counts per category.

#### **Final Conclusion**
This project provides a hands-on approach to SQL for data analysts. By performing database setup, data cleaning, exploratory analysis, and business-driven SQL queries, we gain actionable insights into retail sales performance. The findings can support strategic business decisions by identifying sales trends, customer behaviors, and product performance.

---

### **Future Enhancements**
- Implement **Advanced SQL Functions** (e.g., Window Functions, CTEs, Subqueries)
- Integrate with **Power BI or Tableau** for visualization
- Automate data cleaning and EDA tasks
- Expand dataset with **customer feedback or purchase history**

This structured approach ensures that the project covers key aspects of retail sales analysis using SQL. 🚀

