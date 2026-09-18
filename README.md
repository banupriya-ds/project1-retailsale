# Project Overview:
**Project Title**: Retail Sales Data Analysis<br>
**Level**: Beginner<br>
This project analyzes a retail sales dataset using SQL, starting with data cleaning and basic EDA before moving into deeper analysis of real-world business problems. The analysis will turn data findings into business insights and recommendations. The project is designed as a practical learning project for aspiring Data Analysts.

# Project Objective:<br>
Explore and prepare the retail sales data for analysis.
Develop and solve 10 unique real-world business problems using SQL.
Apply SQL techniques such as aggregations, subqueries, CTEs, and window functions.
Identify meaningful findings and translate them into business insights.
Provide data-driven recommendations based on the analysis to support business decision-making and improve overall performance.

# Project Structure:<br>
## 1. Data setup<br>
**Database:**<br>
The dataset is stored in a PostgreSQL database named retail_sale_db.

**Table:**<br>
The database contains a table named retail_sale with the following columns:
transactions_id	INT,
sale_date	    DATE,
sale_time	    TIME,
customer_id	    INT,
gender	        VARCHAR(15),
age	            INT,
category	    VARCHAR(20),
quantity	    INT,
price_per_unit	FLOAT,
cogs	        FLOAT,
total_sale	    FLOAT

**Database and Table creation:**
```sql
create table retail_sale 
(
	transactions_id int,
	sale_date date,	
	sale_time time,
	customer_id int,	
	gender varchar(15),	
	age int,	
	category varchar(20),	
	quantity int,
	price_per_unit float,	
	cogs float, 	
	total_sale float
);	
```

## 2. Data Import<br>
The retail sales dataset was imported into the retail_sale table for further data cleaning, exploratory analysis, and SQL-based business analysis.

## 3.Data Profiling(Understanding Data)<br>
**1. Total number of records**
```sql
 select count(*) as "Total_Records" from retail_sale;
```
**2. Number of columns**
```sql
select count(*) as "Total_Columns" 
from information_schema.columns
where table_name = 'retail_sale';
```

**3. Number of Distinct transactions**
```sql
select count(distinct transactions_id) as "Total_Transactions"
from retail_sale;
```

**4. Number of distinct customers**
```sql
select count(distinct customer_id) as "Total_Customers"
from retail_sale;
```

**5. Available product category**
```sql
select distinct category as "Distinct Category" from retail_sale;
```

**6. Total number of distinct category**
```sql
select count(distinct category) as "Total_Distinct_Category" from retail_sale;
```

**7. Sale_Date Range**
```sql
select min(sale_date) as "First_sale_date", max(sale_date) as "Last_sale_date" 
from retail_sale;
```

**8. Total transactions by gender category**
```sql
select gender, count(transactions_id) from retail_sale
group by gender;
```

**9. Age range**
```sql
select min(age) as "Minimun Age", max(age) as "Maximum Age" 
from retail_sale;
```

**10. Sales Amount Range**
```sql
select min(total_sale) as "Min Sale", max(total_sale) as "Max Sale", round(avg(total_sale)) as "Avg Sale"
from retail_sale;
```

**11. Check customers with multiple transactions**
```sql
select customer_id, count(*) as "Occurrence" from retail_sale 
group by customer_id 
having count(*)>1
order by customer_id;
```
## 4. Data Quality Check<br>
Is my data valid, complete, and reliable enough to analyze?<br>

**1. Check Null value**
```sql
select count(*) as "Total_Null_Records" from retail_sale
where transactions_id is null
or sale_date is null	
or sale_time is null
or customer_id is null
or gender is null	
or age is null	
or category is null
or quantity is null
or price_per_unit is null
or cogs is null
or total_sale is null;
```

**2. Check total NULLs column_wise**
```sql
SELECT
    COUNT(*) FILTER (WHERE transactions_id IS NULL) AS transactions_id_nulls,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS sale_date_nulls,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
    COUNT(*) FILTER (WHERE gender IS NULL) AS gender_nulls,
    COUNT(*) FILTER (WHERE age IS NULL) AS age_nulls,
    COUNT(*) FILTER (WHERE category IS NULL) AS category_nulls,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS quantity_nulls,
    COUNT(*) FILTER (WHERE price_per_unit IS NULL) AS price_nulls,
    COUNT(*) FILTER (WHERE cogs IS NULL) AS cogs_nulls,
    COUNT(*) FILTER (WHERE total_sale IS NULL) AS total_sale_nulls
	FROM retail_sale;
```
	
**3. Check customers with multiple transactions**
```sql
select customer_id, count(*) as "Occurrence" from retail_sale 
group by customer_id 
having count(*)>1
order by customer_id;
```

**4. Check duplicate transactions**
```sql
select transactions_id, count(*) as "Occurrence" from retail_sale
group by transactions_id 
having count(*)>1 
order by transactions_id;
```

**5. Check category for inconsistent formatting**
```sql
select trim(lower(category)) as "Standardized_category", count(*) as "Occurrence"
from retail_sale
group by trim(lower(category))
order by "Standardized_category";
```

**6. Check Invalid age**
```sql
select count(*) as " Invalid Age" from retail_sale 
where age<=0 or age>=100;
```

**7. Check suspicious financial values**
```sql
select * from retail_sale
where price_per_unit<=0 	
	  or cogs<=0 	
	  or total_sale<=0;
```

## 5. Data Cleaning<br>
**1. Replacing NULL age values with the rounded average age.**
```sql
update retail_sale 
set age = round((select avg(age) from retail_sale))
where age is NULL; 
```

**2. Deleting transaction records where quantity, price, COGS, and total sale are NULL**
```sql
delete from retail_sale 
where quantity is null 
and price_per_unit is null 
and cogs is null
and total_sale is null;
```

## 6.Exploratory Data Analysis (EDA)<br>
**1. Overall sales Analysis**
```sql
select min(total_sale) as "Minimum_Sale",
max(total_sale) as "Maximum_Sale",
sum(total_sale) as "Total_sale",
round(avg(total_sale)) as "Average_sale" 
from retail_sale;
```

**2. Category Analysis**
```sql
select category as "Category", 
count(*) as "Total_transactions",
sum(quantity) as "Total_quantity",
sum(total_sale) as "Total_sale",
sum(case when gender ='Male' then 1 else 0 end) as "Sale_by_male",
sum(case when gender ='Female' then 1 else 0 end) as "Sale_by_female"
from retail_sale
group by category; 
```

**3. Gender based Analysis**
```sql
select gender as "Gender",
count(*) as "Total_transactions",
sum(total_sale) as "Total_sale",
sum(quantity) as "Total_quantity"
from retail_sale
group by gender;
```






















