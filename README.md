# Project Overview:
**Project Title**: Retail Sales Data Analysis<br>
**Level**: Beginner<br>
This project analyzes a retail sales dataset using SQL, starting with data cleaning and basic EDA before moving into deeper analysis of real-world business problems. The analysis will turn data findings into business insights and recommendations. The project is designed as a practical learning project for aspiring Data Analysts.

# Project Objective:<br>
Explore and prepare the retail sales data for analysis.
Develop and solve 8 unique real-world business problems using SQL.
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

## Business Problems
**1. What percentage of total revenue comes from each category, and which categories contribute disproportionately to revenue?**
```sql
with Total_revenue as (
select 
category,
sum(total_sale) as total_revenue,
count(*) as total_transactions,
ROUND ((sum(total_sale) / sum(sum(total_sale)) over() *100) ::numeric) as revenue_percentage,
Round((count(*) / sum(count(*)) over() * 100) :: numeric) as transaction_percentage 
from retail_sale
group by category
)
select 
category, 
total_revenue,
total_transactions,
revenue_percentage,
transaction_percentage,
revenue_percentage - transaction_percentage as revenu_transaction_gap
from total_revenue
ORDER BY revenu_transaction_gap DESC;
```
### Findings
Electronics and Beauty have almost the same revenue percentage and transaction percentage.
Clothing has a slightly higher transaction percentage (35%) than revenue percentage (34%).

### Insights
Electronics and Beauty have a balanced sales performance.
Clothing has more transactions but slightly lower revenue.

### Recommendation
The business can focus on cross-selling related products in the Clothing category to increase revenue per transaction.



**2. Who are the top 10 revenue-generating customers, and what are their revenue contributions as a percentage?**
```sql
WITH top10_customer AS (
    SELECT 
        customer_id, 
        SUM(total_sale) AS customer_revenue
    FROM retail_sale
    GROUP BY customer_id
    ORDER BY customer_revenue DESC 
    LIMIT 10
)
SELECT 
    customer_id, 
    customer_revenue,
    SUM(customer_revenue) OVER() AS top10_total_revenue,
    ROUND(
        (customer_revenue / SUM(customer_revenue) OVER()) * 100
    ) AS revenue_percentage
FROM top10_customer;
```

### Findings
Customer 3 generated the highest revenue among the top 10 customers, contributing 18%.<br>
The top 10 customers generated a total revenue of $214,400.<br>
### Insights
The top 10 customers are important contributors to the business revenue.<br>
Customer 3 is the highest contributor among them.<br>
###Recommendation
The business can give loyalty rewards or gift cards to these top 10 customers to encourage them to buy again.



**3. Which customers have high transaction frequency but relatively low average transaction value?**
```sql
with metrics as (
select 
customer_id,
count(*) as transaction_frequency,
round(avg(count(*)) over()) as overall_avg_transaction_frequency,
sum(total_sale) as transaction_value,
round(avg(total_sale))as avg_transaction_value,
round(avg(avg(total_sale)) over()) as overall_avg_transaction_value
from retail_sale 
group by customer_id
)
select 
customer_id,
transaction_frequency,
overall_avg_transaction_frequency,
avg_transaction_value,
overall_avg_transaction_value
from metrics
where transaction_frequency > overall_avg_transaction_frequency and 
	   avg_transaction_value < overall_avg_transaction_value ;
```
### Findings
- 33 customers make more transactions than the average customer.
- Their average transaction value is less than the overall average of $472.
- Customer 1 has the highest number of transactions with 76 transactions.
- Customer 78 has the lowest average transaction value of $131.
### Insights
- These customers buy more often but spend less each time.
- There is a chance to increase the amount they spend on each purchase.
### Recommendation
The business can offer discounts, combo offers, or related products to encourage these customers to spend more.



**4. Which category shows the highest month-over-month revenue growth?**
```sql
with monthly_sale as(
select 
category,
date_trunc('month', sale_date)::date  as sale_month,
sum(total_sale) as monthly_revenue
from retail_sale
group by category, date_trunc('month', sale_date)
order by category, date_trunc('month', sale_date)
),
monthly_growth as(
select
category,
sale_month,
monthly_revenue,
lag(monthly_revenue) over(
partition by category
order by sale_month)
as previous_month_revenue
from monthly_sale
)
select 
category,
sale_month,
monthly_revenue,
previous_month_revenue,
round( (monthly_revenue - previous_month_revenue)/previous_month_revenue*100) as growth_percentage
from monthly_growth
where previous_month_revenue is not null 
order by category, sale_month;
```
### Findings
- Electronics had the highest growth of 382% in July 2023.
- All categories had increases and decreases in revenue.
### Insights
- Electronics had the highest monthly growth.
- Sales changed from month to month.
- This shows that monthly sales are not consistent.
### Recommendations
- Check the reasons for high-growth months.
- Use successful promotions or sales strategies again.
- Investigate months with negative growth to improve sales.


**5. Which product categories are most preferred by different age groups (Young, Middle, and Senior)?**
```sql
with age_group as (
select 
category,
case when age between 18 and 30 then 'young'
	 when age between 31 and 55 then 'middle'
	 when age > 55 then 'senior'
end as age_group 
from retail_sale
),

age_category as(
select
age_group,
category,
count(*) as total_transaction,
round(count(*)  / sum(count(*)) over(partition by age_group) * 100 )as category_percentage
from age_group
group by  age_group, category
),

ranked_categories as(
select 
age_group,
category,
total_transaction,
category_percentage,
row_number() over(
partition by age_group 
order by category_percentage desc
) as category_rank
from age_category
)

select 
age_group,
category,
total_transaction,
category_percentage
from ranked_categories
where category_rank = 1
order by age_group;
```

### Findings
- Middle-age customers buy more Electronics.
- Senior customers buy more Clothing.
- Young customers buy more Beauty products.
### Insights
- Product preference changes by age group.
- Different age groups prefer different categories.
### Recommendations
- Promote Electronics to Middle-age customers.
- Promote Clothing to Senior customers.
- Promote Beauty products to Young customers.


**6. Which product categories generate the highest revenue during each time of day?**
```sql
with time_period as(
select 
category,
sum(total_sale) as total_revenue,
case when sale_time < '12:00:00' then 'Morning'
	 when sale_time < '17:00:00' then 'Afternoon'
	 when sale_time < '23:59:00' then 'Evening'
end as time_category
from retail_sale
group by category, time_category
),

ranked_categories as(
select 
time_category,
category,
total_revenue,
rank() over (partition by time_category order by total_revenue desc) as rank_category
from time_period
)

select
time_category,
category,
total_revenue,
rank_category
from ranked_categories 
where rank_category = 1 
order by time_category;
```

### Findings
- Clothing has the highest revenue in the morning.
- Electronics has the highest revenue in the afternoon and evening.
### Insights
- Product sales vary by time of day.
### Recommendations
- Promote Clothing in the morning.
- Promote Electronics in the afternoon and evening.


**7. Which categories have high quantity sales but low average transaction value?**
```sql
with metrics as (
select 
category,
sum(quantity) as total_quantity,
sum(total_sale) as total_transaction_value,
round(avg(total_sale)) as avg_transaction_value
from retail_sale
group by category
),
highest_quantity as(
select 
category,
total_quantity,
total_transaction_value,
avg_transaction_value,
rank() over(order by total_quantity desc) as high_quantity_rank,
rank() over(order by avg_transaction_value) as low_transaction_value_rank
from metrics
)
select 
category,
total_quantity,
avg_transaction_value,
high_quantity_rank,
low_transaction_value_rank
from highest_quantity
where high_quantity_rank = 1 and low_transaction_value_rank = 1
order by category, total_quantity,avg_transaction_value, high_quantity_rank,
low_transaction_value_rank;
```

### Findings
- Clothing has the highest quantity sold, with 1,785 units.
- Clothing also has the lowest average transaction value, at $444.

### Insights
- Clothing has strong sales volume, but there is an opportunity to increase the amount spent per transaction.

### Recommendations
- Offer combo deals or bundle related Clothing products.
- Recommend complementary products to encourage customers to buy more items in each transaction.
- Use promotions that encourage customers to increase their purchase value.

**8. Which sales dates generated higher revenue than the average daily revenue?**
```sql
with daily_sale as(
select 
sale_date,
sum(total_sale) as daily_revenue
from retail_sale
group by sale_date
),

avg_daily_sale as(
select 
round(avg(daily_revenue)) as avg_daily_revenue
from daily_sale
)

select 
d.sale_date,
d.daily_revenue,
a.avg_daily_revenue
from daily_sale d
cross join avg_daily_sale a
where d.daily_revenue > a.avg_daily_revenue
order by d.daily_revenue;
```

### Findings
- Average daily revenue was $1,409.
- Several dates had revenue above the average.
- The highest daily revenue was $8,500 on October 10, 2022.
### Insights
- Sales are higher on some dates than others.
- Some dates generate much more revenue than the average.
### Recommendations
- Find out what caused the high sales on those dates.
- Use successful strategies from high-sales dates to improve sales on other dates.



# Power BI Dashboard

The cleaned retail sales data was also visualized using Power BI to create an interactive dashboard.

**Dashboard KPIs**
- Total Sales: $911,720
- Total Transactions: 1,997
- Total Quantity Sold: 5,018
- Total Customers: Unique customers in the dataset
- Average Sale: $456.54
- Dashboard Visuals

**The dashboard includes:**
- Sales by Category
- Monthly Sales Trend
- Top 10 Customers by Total Sales
- Sales by Age Group
- Quantity Sold by Category
- Total Sales by Gender
- Interactive Filters

**The dashboard includes three slicers:**
- Category
- Gender
- Age Group

These slicers allow users to filter the dashboard and explore the sales data from different perspectives.

#Overall Project Summary
This project analyzed retail sales data using PostgreSQL and Power BI.<br>
The project included:<br>
- Data cleaning and handling missing values.
- Exploratory data analysis to understand the dataset.
- Analysis of 8 real-world business problems.
- Use of SQL techniques such as aggregations, CTEs, subqueries, window functions, CASE, RANK(), ROW_NUMBER(), and LAG().
- Analysis of sales by category, customers, age groups, gender, time, and sales trends.
- Creation of an interactive Power BI dashboard to visualize key sales and customer insights.
- Use of KPIs, charts, and slicers to explore the data from different perspectives.
- Identifying findings and turning them into simple business insights and recommendations.

Overall, this project demonstrates how SQL and Power BI can be used together to analyze retail data, identify business patterns, and support data-driven decision-making.

# Conclusion

This project provided practical experience in using PostgreSQL to clean, explore, and analyze retail sales data and Power BI to visualize the results. The analysis identified customer, category, demographic, and time-based patterns and converted the findings into simple business insights and recommendations.

The project demonstrates an end-to-end data analysis workflow, from data cleaning and SQL analysis to interactive dashboard creation and business interpretation.

# How to Use
- Clone the repository from GitHub.
- Set up the PostgreSQL database and retail_sale table.
- Load the cleaned retail sales data.
- Run the SQL queries to perform the analysis.
- Review the findings, insights, and recommendations for each business problem.
- Open the Power BI dashboard to explore the sales data using KPIs, charts, and slicers.
- Modify the SQL queries to explore additional business questions.

## Author
Banu Priya<br>
Aspiring Data Analyst<br>
This project is part of my portfolio and demonstrates practical skills in SQL and Power BI, including data cleaning, exploratory analysis, business problem solving, data visualization, and translating data findings into business insights and recommendations.

























