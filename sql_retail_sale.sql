-- Database creation
create database retail_sale_db;

drop table if exists retail_sale;

-- Table creation
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

-- Data Profiling
-- 1. Total number of records
select count(*) as "Total_Records" from retail_sale;

-- 2. Number of columns
select count(*) as "Total_Columns" 
from information_schema.columns
where table_name = 'retail_sale';

-- 3. Number of Distinct transactions
select count(distinct transactions_id) as "Total_Transactions"
from retail_sale;

-- 4. Number of distinct customers
select count(distinct customer_id) as "Total_Customers"
from retail_sale;

-- 5. Available product category
select distinct category as "Distinct Category" from retail_sale;

-- 6. Total number of distinct category
select count(distinct category) as "Total_Distinct_Category" from retail_sale;

-- 7. Sale_Date Range
select min(sale_date) as "First_sale_date", max(sale_date) as "Last_sale_date" 
from retail_sale;

-- 8. Total transactions by gender category 
select gender, count(transactions_id) from retail_sale
group by gender;

-- 9. Age range
select min(age) as "Minimun Age", max(age) as "Maximum Age" 
from retail_sale;

-- 10. Sales Amount Range
select min(total_sale) as "Min Sale", max(total_sale) as "Max Sale", round(avg(total_sale)) as "Avg Sale"
from retail_sale;

-- 11. Check customers with multiple transactions
select customer_id, count(*) as "Occurrence" from retail_sale 
group by customer_id 
having count(*)>1
order by customer_id;

-- 4. Data Quality Check
-- Is my data valid, complete, and reliable enough to analyze?
-- 1. Check Null value
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

-- 2. Check total NULLs column_wise
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
	
-- 3. Check customers with multiple transactions
select customer_id, count(*) as "Occurrence" from retail_sale 
group by customer_id 
having count(*)>1
order by customer_id;

-- 4. Check duplicate transactions
select transactions_id, count(*) as "Occurrence" from retail_sale
group by transactions_id 
having count(*)>1 
order by transactions_id;

-- 5. Check category for inconsistent formatting
select trim(lower(category)) as "Standardized_category", count(*) as "Occurrence"
from retail_sale
group by trim(lower(category))
order by "Standardized_category";

-- 6. Check Invalid age
select count(*) as " Invalid Age" from retail_sale 
where age<=0 or age>=100;

-- 7. Check suspicious financial values
select * from retail_sale
where price_per_unit<=0 	
	  or cogs<=0 	
	  or total_sale<=0;


-- Data Cleaning
-- 1. Replacing NULL age values with the rounded average age.
update retail_sale 
set age = round((select avg(age) from retail_sale))
where age is NULL; 

-- 2. Deleting transaction records where quantity, price, COGS, and total sale are NULL
delete from retail_sale 
where quantity is null 
and price_per_unit is null 
and cogs is null
and total_sale is null;

-- EDA
-- 1. Overall sales Analysis
select min(total_sale) as "Minimum_Sale",
max(total_sale) as "Maximum_Sale",
sum(total_sale) as "Total_sale",
round(avg(total_sale)) as "Average_sale" 
from retail_sale;

-- 2. Category Analysis
select category as "Category", 
count(*) as "Total_transactions",
sum(quantity) as "Total_quantity",
sum(total_sale) as "Total_sale",
sum(case when gender ='Male' then 1 else 0 end) as "Sale_by_male",
sum(case when gender ='Female' then 1 else 0 end) as "Sale_by_female"
from retail_sale
group by category; 

-- 3. Gender based Analysis
select gender as "Gender",
count(*) as "Total_transactions",
sum(total_sale) as "Total_sale",
sum(quantity) as "Total_quantity"
from retail_sale
group by gender;


-- Business Problems
-- 1. What percentage of total revenue comes from each category, and which categories contribute disproportionately to revenue?
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

-- 2. Who are the top 10 revenue-generating customers, and what are their revenue contributions as a percentage?
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


-- 3. Which customers have high transaction frequency but relatively low average transaction value?
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
	   

-- 4. Which category shows the highest month-over-month revenue growth?
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

-- 5. Which product categories are most preferred by different age groups (Young, Middle, and Senior)?
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


-- 6. Which product categories generate the highest revenue during each time of day?
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


-- 7. Which categories have high quantity sales but low average transaction value?
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

-- 8. Which sales dates generated higher revenue than the average daily revenue?
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



