Create database if not exists Salesdatawalmart;

Create table if not exists sales (
 invoice_id  varchar(30) Not null primary Key,
 branch  varchar (5) not null,
    city varchar (30) not null,
    customer_type varchar (30) not null,
    gender  varchar(10) not null,
    product_line varchar (100) not null,
    unit_price  decimal(10,2) not null,
    quantity int not null,
    VAT  float(6,4) not null,
    total decimal (12,4) not null,
    date datetime not null,
    time TIME not null,
    payment_method varchar (15)  not null, 
    cogs  decimal (10, 2) not null,
    gross_margin_pct float (11,9),
    gross_income decimal(12, 4) not null,
    rating float (2, 1)
);

-- Feature Engineering

-- time_of_day
Select
     time,
     (Case 
          when 'time' between '00:00:00' and '12:00:00' then 'Morning'
          when 'time' between '12:00:01' and '16:00:00' then 'Afternoon'
          Else 'Evening'
      End    
          ) as time_of_date
From sales;


alter table sales add column time_of_day varchar(20);

update sales
set time_of_day=(
case 
when time between "00:00:00" and "12:00:00" then "Morning"
	when time between "12:00:01" and "16:00:00" then "Afternoon"
		else "Evening"
      end);

-- day_name
select 
    date,
    Dayname(date) as day_name
From sales;

Alter table sales add column day_name varchar(10);

update sales
set day_name=dayname(date);

-- month_name
select 
date, monthname(date)
from sales;

alter table sales add column month_name varchar(10);

update sales
set month_name=monthname(date);

-- -------------------------------------------------------------
-- General

-- distinct city (3 cities)
Select 
distinct city
from sales;

-- distinct branch  (3 branches)
Select 
distinct branch
from sales;

-- in wich city is each branch
select 
distinct city, branch
from sales;

-- -------------------------------------------
-- PRODUCT ANALYSIS

-- 1. unique product line (6)
select
count(distinct product_line)
from sales;

-- 2. common payment method (Cash)
Select 
payment_method, count(payment_method) as cnt
From sales
Group by payment_method
Order by cnt DESC;

-- 3. What is the most selling product line? (Fashion accessories)
SELECT 
product_line,
count(product_line) as cnt
from sales
group by product_line
order by cnt DESC;

-- 4. What is the total revenue by month?
select
month_name as month, sum(total) as total_revenue
from sales
group by month;

-- 5. What month had the largest COGS? (January)
select 
month_name as month, sum(cogs) as month_COGS
From sales
group by month
order by month_COGS DESC;

-- 6. What product line had the largest revenue? (Food and beverages)
Select
product_line, sum(total) as total_revenue
From sales
group by product_line
order by total_revenue DESC;

-- 7. What is the city with the largest revenue? (Naypyitaw)
Select
city, sum(total) as total_revenue
From sales
group by city
order by total_revenue DESC;

-- 8. What product line had the largest VAT? (Food and beverages)
Select
product_line, Sum(VAT) as Valueable_Tax
From sales
group by product_line
order by Valueable_Tax DESC;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


-- 10. Which branch sold more products than average product sold?
select 
branch, sum(quantity) as product_sold
From sales
group by branch
having product_sold > (select AVG(quantity) from sales);

-- 11. What is the most common product line by gender?
Select
gender, product_line, count(product_line) as cnt
From sales
group by gender, product_line
order by cnt DESC;

-- 12. What is the average rating of each product line?
select
product_line, round(AVG(rating),2) as avg_rating
from sales
group by product_line
order by avg_rating DESC;


-- SALES ANALYSIS

-- 1. Number of sales made in each time of the day per weekday, check for "Sunday"
select
time_of_day, count(*) as number_of_sales
from sales
where day_name = "Sunday"
group by time_of_day;

-- 2. Which of the customer types brings the most revenue? (Member)
select
customer_type, sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue DESC;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?(Naypyitaw)
select
city, avg(VAT) as VAT
from sales
group by city
order by VAT DESC;

-- 4. Which customer type pays the most in VAT? (Member)
select
customer_type, AVG(VAT) as VAT
from sales
group by customer_type
order by VAT DESC;


-- CUSTOMER ANALYSIS

-- 1. How many unique customer types does the data have? (2)
select 
distinct(customer_type)
from sales;

-- 2. How many unique payment methods does the data have? (3)
select
distinct(payment_method)
from sales;

-- 3.What is the most common customer type? (Member)
select
customer_type,count(customer_type) as cnt
from sales
group by customer_type
order by cnt DESC;

-- 4. Which customer type buys the most? (Member)
select 
customer_type, sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue DESC;

-- 5. What is the gender of most of the customers? (Male)
select
gender, count(*) as gender_count
from sales
group by gender
order by gender_count DESC;

-- 6. What is the gender distribution per branch? for branch A
select
gender, count(*) as gender_count
from sales
where branch = "A"
group by gender
order by gender_count DESC;

-- 7. Which time of the day do customers give most ratings? (Afternoon)
select
time_of_day, avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

-- 8. Which time of the day do customers give most ratings per branch?
select
time_of_day, branch, avg(rating) as avg_rating
from sales
group by time_of_day, branch
order by avg_rating ;

-- 9. Which day of the week has the best avg ratings?
select
day_name, avg(rating)
from sales
group by day_name
order by avg(rating) DESC;

-- 10. Which day of the week has the best average ratings per branch? for branch "B"
select
day_name, avg(rating) as avg_rating
from sales
where branch= "B"
group by day_name
order by avg_rating desc;


-- Revenue And Profit Calculations

-- $ total(gross_sales)--
select
 sum(VAT+cogs) as total_grass_sales
from  sales;
-- gross profit-----------
SELECT 
SUM(gross_income)
FROM sales;

