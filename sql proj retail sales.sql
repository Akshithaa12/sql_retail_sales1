--  Sql Retail sales Analysis -----------------------------------------
create database project1;
use project1;
-- Create table ------------------
drop table retail_sales; 
CREATE TABLE retail_sales
					(
						  transactions_id int primary key,
						  sale_date	date,
						  sale_time time,
						  customer_id int,
						  gender varchar(15),
						  age int default null,
						  category varchar(15),
						  quantiy int,
						  price_per_unit float,
						  cogs	float,
						  total_sale float
                     );
select * from retail_sales;
select count(*) from retail_sales; 
select  transactions_id,age from retail_sales where  transactions_id =  432; 
select * from retail_sales where  
				transactions_id is null or  sale_date is null or sale_time is null or
						  customer_id is null or
						  gender is null or
						  age is null or
						  category is null or
						  quantiy is null or
						  price_per_unit is null or 
						  cogs is null or
						  total_sale is null;
                          
-- no.of customers we have?
select count(customer_id) from retail_sales;
select count(Distinct customer_id) from retail_sales;
 -- no.of categories -------
select count(Distinct category) from retail_sales; 
select distinct category from retail_sales;
select distinct sale_date from retail_sales;
-- data Analysis & Business key problems and answers
-- 1) write a sql query to retrive all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date = '2022-11-05';

-- 2) write a sql query to retrive all transactions where the category is clothing and quantity sold more than 10 in the month of nov-2022 ----
select * from retail_sales
where category = 'Clothing'
and sale_date like '2022-11%'
and quantiy >= 4;

-- calculate the totalsales (total_sales) for each category---------
select  distinct category, sum(total_sale),count(*) as total_ordes
from retail_sales group by category;

-- to find avg age of customers who purchased items from the 'Beauty' category----
select avg(age) from retail_sales where category = 'Beauty';
select round(avg(age),2) from retail_sales where category = 'Beauty';

-- find all transaction where the total_sale is greater than 1000-----
select * from retail_sales where total_sale > 1000;

-- total number of transactions(transaction_id) each gender in each category---
select gender,
	 category,
     count(transactions_id) as tot_trans
     from retail_sales
     group by gender,
	 category;
     
 SELECT gender,
       category,
       COUNT(transactions_id) AS tot_trans
FROM retail_sales
GROUP BY gender, category
ORDER BY tot_trans ASC;
    
-- to calculate the avg sale for each month.find out best selling month----
select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
round(avg(total_sale),2) as avg_sale from retail_sales
group by 1,2
order by year,avg_sale desc;

-- find top 5 customers based on the highest total_sales-----------
select customer_id, sum(total_sale) as tot_sal from retail_sales group by 1
order by 2 desc limit 5;

-- find unique customers who purchased items from each category--------
select count(distinct(customer_id)),category from retail_sales group by category;

-- to create each shift and number of orders( example mroning <12,afternoon between 12 and 17 evening>17--
-- === create shift ====================================
select *, 
 case
	when extract(hour from sale_time) < 12 then 'Morning' 
    when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
    else 'Evening'
   end as shift
from retail_sales;
-- ============================
--  no.of orders
with hourly_sale as(
select *, 
 case
	when extract(hour from sale_time) < 12 then 'Morning' 
    when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
    else 'Evening'
   end as shift
from retail_sales
)
select shift, count(*) as total_sales
from hourly_sale
group by shift;
