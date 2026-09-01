create table transactions as
select * from transactions_1997;

insert into transactions 
select * from transactions_1998;

SELECT * FROM transactions;

SELECT YEAR(transactions_date) AS year,
       COUNT(*) AS total_transactions
FROM transactions
GROUP BY YEAR(transactions_date);

#---------------------------------------------------------------------
#Step 1: Business Overview
#How many customers are in the database?
select count(*) as total_customer from customers;

# Total Products.
select  count( DISTINCT product_id) total_products from products;
select * from products;

# total stores
select count(DISTINCT store_id) as total_store from stores;

# total transaction
SELECT COUNT(*) AS total_transactions FROM transactions;

# How many units were sold?(total units)
select sum(quantity) as total_units_sold from transactions;

#What is the total sales/revenue?
select * from products;

select round(sum(p.product_retail_price * t.quantity),2) as revenue
from products as p
join transactions as t
on p.product_id = t.product_id;


# Sales by Year
select year(transactions_date) as years,
       round(sum(p.product_retail_price * t.quantity),2) as revenue
from transactions t 
join products p 
on p.product_id = t.product_id
group by year(transactions_date)
order by years;

# average units per transaction means: On average, how many units are included in one transaction?
# total_qantity / total transaction records
select round((sum(quantity) / count(*)),2) as avg_unit_prtran
from transactions;


#Total Cost = How much did RetailMart spend on the products that were sold?
select round(sum(p.product_cost* t.quantity),2) as total_cost
from products as p
join transactions as t
on p.product_id = t.product_id;

#Gross Profit : How much money remains after subtracting the product cost from sales revenue.
# revenue - total_cost
select round((sum(p.product_retail_price * t.quantity) - sum(p.product_cost* t.quantity)),2) as gross_profit
from products as p
join transactions as t
on p.product_id = t.product_id;

#Profit Margin % = Shows the percentage of revenue remaining as gross profit margin after product cost.

# Profit Margin % = (Gross Profit ÷ Revenue) × 100

select round(((sum((p.product_retail_price - p.product_cost) * t.quantity))
			   / (sum(p.product_retail_price * t.quantity)))* 100, 2) as gross_profit_margin
from products as p
join transactions as t
on p.product_id = t.product_id; # For every $100 of revenue, about $59.67 is gross profit after product cost.

#average Order Value (AOV = On average, how much money is generated from each transaction?
#Total Revenue ÷ Total Transaction Records
select round(sum(p.product_retail_price * t.quantity)/ count(*),2) as AOV
from products as p
join transactions as t
on p.product_id = t.product_id;

# Average Selling Price (ASP): the average revenue generated per unit sold
# Total Revenue ÷ Total Units Sold
select round(sum(p.product_retail_price * t.quantity)/ sum(quantity) , 2) as ASP
from products as p
join transactions as t
on p.product_id = t.product_id;

/*| KPI                       |Result| Meaning                                    |
| Average Units / Transaction |  3.09| Average quantity in one transaction record |
| AOV                         | $6.54| Average revenue per transaction record     |
| ASP                         | $2.12| Average revenue generated per unit         | 

And look at the relationship:

3.09 × $2.12 = $6.55
*/

#===========================================================================================

# Year-over-Year Revenue Growth
#Growth % = (1998 Revenue − 1997 Revenue) ÷ 1997 Revenue × 100
select 
     round(
     (
     sum(case when year(transactions_date) = 1998
		 then p.product_retail_price * t.quantity else 0 end)
	-
     sum(case when year(transactions_date) = 1997
		then p.product_retail_price * t.quantity else 0 end))
	/
	 (sum(case when year(transactions_date) = 1997
		then p.product_retail_price * t.quantity else 0 end)
     ) * 100, 2
	) as revenue_growth_percent
from transactions t
join products p
on t.product_id = p.product_id;
/*
Business insight

RetailMart's revenue increased by 112.18% from 1997 to 1998, meaning that 1998 revenue was more than twice the 1997 revenue.
But We should identify what drove this growth before moving to the next business question. */
	
#Compare the two years
select 
       year(t.transactions_date) as years,
       count(*) as transactions_records,
       sum(t.quantity) as units_sold,
       round(sum(p.product_retail_price * t.quantity),2) as revenue
from transactions t
join products p
on t.product_id = p.product_id
group by year(transactions_date)
order by years;
     
#comparable date coverage:We should verify that both years actually have comparable date coverage
    
select
      year(transactions_date) as years,
      min(transactions_date) as first_date,
      max(transactions_date) as last_date,
      count(distinct month(transactions_date)) as months_present
from transactions
group by year(transactions_date)
order by years;
     
/* RetailMart's revenue increased by 112.18% in 1998 compared to 1997.
 The main reason was that the company sold more units and had more transactions in 1998.
 Both years have data for all 12 months, so the comparison is fair. */      
 
 
      

     
     
     