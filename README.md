#### \#Project Overview:

\*\*Project Title\*\*: Retail Sales Data Analysis

\*\*Level\*\*: Beginner

This project analyzes a retail sales dataset using SQL, starting with data cleaning and basic EDA before moving into deeper analysis of real-world business problems. The analysis will turn data findings into business insights and recommendations. The project is designed as a practical learning project for aspiring Data Analysts.



#### \#Project Objective:

Explore and prepare the retail sales data for analysis.

Develop and solve 10 unique real-world business problems using SQL.

Apply SQL techniques such as aggregations, subqueries, CTEs, and window functions.

Identify meaningful findings and translate them into business insights.

Provide data-driven recommendations based on the analysis to support business decision-making and improve overall performance.



#### \#Project Structure:

##### \##1. Data setup

###### **###Database:**

The dataset is stored in a PostgreSQL database named retail\_sale\_db.



###### \###Table:

The database contains a table named retail\_sale with the following columns:

\*\*Column	Data Type\*\*

transactions\_id	INT

sale\_date	DATE

sale\_time	TIME

customer\_id	INT

gender	        VARCHAR(15)

age	        INT

category	VARCHAR(20)

quantity	INT

price\_per\_unit	FLOAT

cogs	        FLOAT

total\_sale	FLOAT



\*\*Database and Table creation:\*\* 

```sql

create database retail\_sale\_db;

create table retail\_sale 

(

&#x09;transactions\_id int,

&#x09;sale\_date date,	

&#x09;sale\_time time,

&#x09;customer\_id int,	

&#x09;gender varchar(15),	

&#x09;age int,	

&#x09;category varchar(20),	

&#x09;quantity int,

&#x09;price\_per\_unit float,	

&#x09;cogs float, 	

&#x09;total\_sale float

);

```



&#x09;

##### \##2. Data Import

The retail sales dataset was imported into the retail\_sale table for further data cleaning, exploratory analysis, and SQL-based business analysis.



###### \##3.Data Profiling(Understanding Data)



\*\*1. Total number of records\*\*

```sql		

&#x20;  select count(\*) as "Total\_Records" from retail\_sale;

```



\*\*2. Number of columns\*\*

```sql

&#x20;  select count(\*) as "Total\_Columns" 

&#x20;  from information\_schema.columns

&#x20;  where table\_name = 'retail\_sale';

```



\*\*3. Number of Distinct transactions\*\*

```sql

&#x20;  select count(distinct transactions\_id) as "Total\_Transactions"

&#x20;  from retail\_sale;

```



\*\*4. Number of distinct customers\*\*

```sql

&#x20;  select count(distinct customer\_id) as "Total\_Customers"

&#x20;  from retail\_sale;

```



\*\*5. Available product category\*\*

```sql

select distinct category as "Distinct Category" from retail\_sale;

```



\*\*6. Total number of distinct category\*\*

```sql

select count(distinct category) as "Total\_Distinct\_Category" from retail\_sale;

```



\*\*7. Sale\_Date Range\*\*

```sql

select min(sale\_date) as "First\_sale\_date", max(sale\_date) as "Last\_sale\_date" 

from retail\_sale;

```



\*\*8. Total transactions by gender category\*\* 

```sql

select gender, count(transactions\_id) from retail\_sale

group by gender;

```



\*\*9. Age range\*\*

```sql

select min(age) as "Minimun Age", max(age) as "Maximum Age" 

from retail\_sale;

```



\*\*10. Sales Amount Range\*\*

```sql

select min(total\_sale) as "Min Sale", max(total\_sale) as "Max Sale", round(avg(total\_sale)) as "Avg Sale"

from retail\_sale; 

```



\*\*11. Check customers with multiple transactions\*\*

```sql

select customer\_id, count(\*) as "Occurrence" from retail\_sale 

group by customer\_id 

having count(\*)>1

order by customer\_id;

```

&#x09;

\##4. Data Quality Check

Is my data valid, complete, and reliable enough to analyze?



\*\*1. Check Null values\*\*

```sql 

select count(\*) as "Total\_Null\_Records" from retail\_sale

where transactions\_id is null

or sale\_date is null	

or sale\_time is null

or customer\_id is null

or gender is null	

or age is null	

or category is null

or quantity is null

or price\_per\_unit is null

or cogs is null

or total\_sale is null;

```



\*\*2. Check total NULLs column\_wise\*\*

SELECT

&#x20;   COUNT(\*) FILTER (WHERE transactions\_id IS NULL) AS transactions\_id\_nulls,

&#x20;   COUNT(\*) FILTER (WHERE sale\_date IS NULL) AS sale\_date\_nulls,

&#x20;   COUNT(\*) FILTER (WHERE customer\_id IS NULL) AS customer\_id\_nulls,

&#x20;   COUNT(\*) FILTER (WHERE gender IS NULL) AS gender\_nulls,

&#x20;   COUNT(\*) FILTER (WHERE age IS NULL) AS age\_nulls,

&#x20;   COUNT(\*) FILTER (WHERE category IS NULL) AS category\_nulls,

&#x20;   COUNT(\*) FILTER (WHERE quantity IS NULL) AS quantity\_nulls,

&#x20;   COUNT(\*) FILTER (WHERE price\_per\_unit IS NULL) AS price\_nulls,

&#x20;   COUNT(\*) FILTER (WHERE cogs IS NULL) AS cogs\_nulls,

&#x20;   COUNT(\*) FILTER (WHERE total\_sale IS NULL) AS total\_sale\_nulls

&#x09;FROM retail\_sale;





\*\*3. Check duplicate transactions\*\*

```sql

select transactions\_id, count(\*) as "Occurrence" from retail\_sale

group by transactions\_id 

having count(\*)>1 

order by transactions\_id;

```



\*\*4. Check category for inconsistent formatting\*\*

```sql

select trim(lower(category)) as "Standardized\_category", count(\*) as "Occurrence"

from retail\_sale

group by trim(lower(category))

order by "Standardized\_category";

```



\*\*5. Check Invalid age\*\*

```sql

select count(\*) as " Invalid Age" from retail\_sale 

where age<=0 or age>=100;   

```



\*\*6. Check suspicious financial values\*\*

```sql

select \* from retail\_sale

where price\_per\_unit<=0 	

&#x09;  or cogs<=0 	

&#x09;  or total\_sale<=0;

```



\##5. Data Cleaning

\*\*1. Replacing NULL age values with the rounded average age\*\*

```sql

update retail\_sale 

set age = round((select avg(age) from retail\_sale))

where age is NULL; 

```



\*\*2. Deleting transaction records where quantity, price, COGS, and total sale are NULL\*\*

```sql

DELETE FROM retail\_sale

WHERE quantity IS NULL

&#x20; AND price\_per\_unit IS NULL

&#x20; AND cogs IS NULL

&#x20; AND total\_sale IS NULL;

```



\##6. Exploratory Data Analysis (EDA)

\*\*1. Overall sales Analysis\*\*

```sql

select min(total\_sale) as "Minimum\_Sale",

max(total\_sale) as "Maximum\_Sale",

sum(total\_sale) as "Total\_sale",

round(avg(total\_sale)) as "Average\_sale" 

from retail\_sale;

```



\*\*2. Category Analysis\*\*

```sql

select category as "Category", 

count(\*) as "Total\_transactions",

sum(quantity) as "Total\_quantity",

sum(total\_sale) as "Total\_sale",

sum(case when gender ='Male' then 1 else 0 end) as "Sale\_by\_male",

sum(case when gender ='Female' then 1 else 0 end) as "Sale\_by\_female"

from retail\_sale

group by category;

``` 



\*\*3. Gender based Analysis\*\*

```sql

select gender as "Gender",

count(\*) as "Total\_transactions",

sum(total\_sale) as "Total\_sale",

sum(quantity) as "Total\_quantity"

from retail\_sale

group by gender;

```





















