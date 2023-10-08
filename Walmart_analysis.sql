
-----------------------------------CREATING DATABASE-----------------------------------------------;

CREATE DATABASE IF NOT EXISTS walmartSales ;

----------------------------------CREATING TABLE---------------------------------------------------;

 Create table ;
 
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
); 

--------------------------------- DATA CLEANING-----------------------------------------------------;

SELECT *
FROM 
sales ;

SELECT * FROM salesdatawalmart.sales;

-----------------------------------FEATURE ENGINEERING--------------------------------------------------;
-------------------------------------------------------------------------------------------------------;
------------------------------------- month_name------------------------------------------------------------;
select 
date ,
monthname(date)
from sales;

alter table sales add column month_name varchar(10);
update sales
set month_name=monthname(date);

--------------------------------the time_of_day----------------------------------------------------;

SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);
------------------------------------day_name ------------------------------------------------------------------ ;

SELECT
	date,
	DAYNAME(date)
FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales
SET day_name = DAYNAME(date);

-----------------------------------------------------------------------------------------------
------------------------------------EXPLORATORY DATA ANALYSIS-----------------------------------
LETS BEGIN ;
------------------------------------------------------------------------------------------------;
------------------------------------------GENERIC_EDA----------------------------------------------------;

1) HOW MANY UNIQUE CITIES DOES THE DATA HAVE? ;

select 
distinct city
from sales;

2) HOW MANY UNIQUE BRANCHES DOES THE DATA HAVE? ;   
 
select 
distinct branch
from sales;

3) IN WHICH CITY IS EACH BRANCH?  ;

select 
distinct city ,
branch 
from sales;

--------------------------------------------------------------------------------------------------;
--------------------------------- Product EDA-------------------------------------------------------------;


1) HOW MANY UNNIQUE PRODUCT LINES DOES THE DATA HAVE? ;

Select 
count(distinct product_line)
from 
sales;

2) WHAT IS THE MOST COMMON PAYMENT METHOD?   ;

Select 
payment_method,
count(payment_method) as cnt 
from 
sales
Group by payment_method
order by cnt DESC; 

3) WHAT IS THE MOST SELLING PRODUCT LINE?  ;

Select  
    product_line,
	count(product_line) as cnt 
from  sales
Group by product_line
order by cnt DESC; 

4) WHAT IS TOTAL REVENUE BY MONTH? ;

SELECT 
month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

5) WHAT MONTH HAS THE LARGEST COGS? ;

SELECT 
month_name as month,
sum(cogs) as cogs
from sales
group by month_name
order by cogs desc; 

6) WHAT PRODUCT LINE HAD  THE LARGEST REVENUE? ;

Select 
product_line, 
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

7) WHAT IS THE LARGEST CITY REVENUE?;
 
 select 
 branch,
 city, 
sum(total) as total_revenue
from sales
group by city, branch
order by total_revenue desc;

8) WHAT  PRODUCT LINE HAD THE LARGEST VAT ? ;

select 
product_line,
avg(vat) as avg_Tax
from sales
group by product_line 
order by avg_tax desc;

9) WHICH BRAND SOLD MORE PRODUCTS THAN AVERAGE PRODUCT SOLD? ;

select 
branch, 
sum(quantity) as qty
from sales
group by branch 
having sum(quantity) > (select avg(quantity) from sales)  ;

10) WHAT IS THE MOST  COMMON PRODUCT LINE BY GENDER? ;

Select 
gender, product_line,
count(gender) as total_cnt
from sales
group by gender, product_line
order by  total_cnt desc;

11) WHAT IS THE AVERAGE RATING OF EACH PRODUCT LINE? ;

select 
round(avg(rating), 2) as avg_rating,
product_line
from sales
group by product_line
order by avg_rating desc;

------------------------------------------------------------------------------------------------?
---------------------------------------SALES EDA-------------------------------------------------;

1) WHAT IS THE NUMBER OF SALES MADE IN EACH TIME OF THE DAT PER WEEKDAY? ;

select 
time_of_day,
count(*) as total_sales
from sales
where day_name ="Monday"
group by time_of_day
order by total_sales desc;

2) WHICH OF THE CUSTOER TYPES BRINGS THE MOST REVENUE? ;

select 
customer_type,
sum(total) as total_rev
from sales
group by customer_type
order by total_rev desc;

3) WHICH CITY HAS THE LARGEST TAX PERCENT / VAT(VALUE ADDED TAX)? ;

select   
city ,
avg(vat) as VAT
from sales
group by city
order by  VAT desc;

 4) WHICH CUSTOMER TYPE PAYS THE MOST IN VAT? ;
 
 select
 customer_type,
 avg(vat) as VAT
 from sales
 group by customer_type
 order by vat desc;
 -----------------------------------------------------------------------------------------------;
 ----------------------------------CUSTOMER INFORMATION----------------------------------------;
 
1) HOW MANY UNIQUE CUSTOMER TYPE DOES THE DATA HAVE? ;

 Select  
 distinct customer_type
 from sales;
 
2) HOW MANY UNIQUE PAYMENT METHODS DOES THE DATA HAVE? ;

 Select
 distinct payment_method
 from 
 sales;
 
3) WHICH CUTOMER TYPES BUYS THE MOST? ;
 
 Select 
 customer_type ,
 count(*) as cstm_cnt
 from sales
 group by customer_type;
 
 4) WHAT IS THE GENDER OF THE MOST OF THE CUSTOMERS? ;
 
 select 
 gender,
 count(*) as gender_cnt
 from sales
 group by gender
 order by gender_cnt desc;
 
 5) WHAT IS THE GENDER DISTRIBUTION PER BRANCH? ;
 
 select 
 gender,
 count(*) as gender_cnt
 from sales
 where branch ="A"
 group by gender
 order by gender_cnt desc;
 
6) WHICH TIME OF THE DAY DO CUSTOMERS GIVE MOST RATINGS?;
 
 select 
 time_of_day,
 avg(rating) as avg_rating
 from sales
 group by time_of_day
 order by avg_rating  desc;
 
7) WHICH TIME OF THE DAY DO CUSTOMERS GIVES MOST RATING PER BRANCH ;
 
 Select 
 time_of_day ,
 avg(rating) as avg_rating
 from sales
 where branch="A"
  group by time_of_day
  order by avg_rating desc;
 
  
 8) WHICH DAY OF THE WEEK HAS THE BEST AVG RATING ?  ;
 
   select
   day_name,
   avg(rating) as avg_rating
    from sales
    group by day_name
    order by avg_rating desc;
    
 9)  WHICH DAY OF THE WEEK HAS THE BEST AVERAGE RATING PER BRANCH?;
    Select
   day_name,
   avg(rating) as avg_rating
    from sales
    WHERE BRANCH ="B"
    group by day_name
    order by avg_rating desc;
    
    
--------------------------------------------------------------------------------------------------;
--------------------------------------END---------------------------------------------------------;
----------------------------------------------------------------------------------------------------;
 
 






  
