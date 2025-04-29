Drop database if exists online_sales;
create database online_sales;
use online_sales;

drop database online_sales;

select *
from orders;


# What is the total revenue and order volume for each month?

SELECT
    year(date) AS Year,
    month(date) AS Month,
    SUM(total_revenue) AS total_revenue,
    COUNT(DISTINCT Transaction_ID) AS order_volume
FROM orders
GROUP BY year, month
ORDER BY year, month;

# Highest-Grossing Month by Revenue

SELECT
    year(date) AS Year,
    month(date) AS Month,
    SUM(total_revenue) AS total_revenue
FROM orders
GROUP BY year, month
ORDER BY total_revenue desc;

#  Monthly Revenue by Product Category

SELECT
    year(date) AS Year,
    month(date) AS Month,
    product_category,
    SUM(total_revenue) AS total_revenue
FROM orders
GROUP BY year, month , product_category
ORDER BY year, month , total_revenue desc;

# Top 5 Products by Units Sold

select product_name, sum(units_sold) as Total_units
from orders
group by product_name
order by Total_units Desc
limit 5;

# What is the total revenue by region for each month?

select month(date) as Months, region, Round(sum(Total_revenue),2) as total_revenue
from orders
group by Months , region
order by Months;

# Which payment method generated the most revenue overall?

select payment_method, round(sum(total_revenue),2) as total_revenue
from orders
group by payment_method
order by total_revenue desc;

# Find the month-over-month growth rate in revenue.

with monthly_revenue as (select year(date) as Years, month(date) as Months, sum(total_revenue) as Current_revenue
						from orders 
                        group by Years, Months),
revenue_with_lag as    (select Years, Months,Current_revenue, lag(Current_revenue) over (order by Years, Months) as previous_revenue
                        from monthly_revenue)
                        
select Years, Months, Current_revenue, previous_revenue, round(((Current_revenue - previous_revenue) / previous_revenue ) * 100,2) as mom_growth_percentage
from revenue_with_lag;
