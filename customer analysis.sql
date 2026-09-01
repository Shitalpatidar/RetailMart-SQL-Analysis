select * from customers;
#1. How many customers do we have?
select count(*) as total_customers from customers;

#2. Find active customers
select count( distinct customer_id) as active_customers from transactions;

/*RetailMart has 10,281 registered customers, of whom 8,842 have made purchases.
 This means the majority of customers are active, while 1,439 customers have no recorded transactions.*/
 
#3. how many transactions each customer has made
select customer_id,
	count(*) as total_transaction
from transactions
group by customer_id
order by total_transaction desc;

#4. How many customers are repeat customers vs. one-time customers?
select 
      case
          when total_transaction = 1 then "one_time_customers"
          else "repeat_customers"
	  end as types_customer  ,
      count(*)  as total_customers
from 
   ( select customer_id,
	count(*) as total_transaction
    from transactions
    group by customer_id
	order by total_transaction desc) as dt
    
group by types_customer ;
     
/*RetailMart has 8,842 purchasing customers. Out of these, 8,735 are repeat customers and only 107 are one-time customers. 
This means about 98.8% of purchasing customers made more than one transaction, showing very strong repeat purchasing.*/

#5. How much revenue does each customer generate?
/*We'll calculate:
Customer ID
Total units purchased
Total revenue
Total profit*/
select t.customer_id,
       sum(t.quantity) as unit_sold,
       round(sum(p.product_retail_price * t.quantity), 2) as revenue,
       round(sum((p.product_retail_price - p.product_cost) * t.quantity),2) as profit
from transactions t
join products p 
on t.product_id = p.product_id
group by customer_id
order by revenue desc;

/*Customer 5295 generated the highest revenue of $2,235.43 and also the highest profit of $1,340.56, with 1,021 units purchased.
 Customer 4727 ranked second.*/
 
 #6. Which customers generate the lowest revenue?
select t.customer_id,
       sum(t.quantity) as unit_sold,
       round(sum(p.product_retail_price * t.quantity), 2) as revenue,
       round(sum((p.product_retail_price - p.product_cost) * t.quantity),2) as profit
from transactions t
join products p 
on t.product_id = p.product_id
group by customer_id
order by revenue;
/*These customers generated very low revenue because they purchased only one or two units. 
They represent low-value purchasing activity compared with the high-value customers we identified earlier.*/

#7. What is the average revenue generated per customer?
select 
       round(sum(p.product_retail_price * t.quantity)
       /
         count(distinct t.customer_id), 2) as avg_revenue
from transactions t
join products p 
on t.product_id = p.product_id ;

/*On average, each purchasing customer generated about $199.56 in revenue for RetailMart.*/

#8. What is the average number of transactions per customer?
select 
       round(count(*) / count(distinct customer_id), 2) as avg_transactions_per_customer
from transactions;
/*On average, each purchasing customer made about 30.5 transactions during the available period.
 This indicates that customers generally purchased repeatedly rather than making only one purchase.*/
 
 ## 9. Which income group generates the highest revenue and profit?

select c.yearly_income,
       count(distinct t.customer_id) as total_customer,
       sum(t.quantity) as unit_sold,
       round(sum(p.product_retail_price * t.quantity), 2) as revenue,
       round(sum((p.product_retail_price - p.product_cost) * t.quantity),2) as profit
FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
JOIN products p
    ON t.product_id = p.product_id
GROUP BY c.yearly_income
ORDER BY revenue DESC;
/*The $30K–$50K income group is the biggest contributor:
 2,882 customers
 274,154 units
 $580,785.96 revenue
 $346,547.35 profit
The $10K–$30K group is second in both revenue and profit.*/

## 10 Which income group has the highest average revenue per customer?
select c.yearly_income,
       count(distinct t.customer_id) as total_customer,
	   round(sum(p.product_retail_price * t.quantity) /count(distinct t.customer_id), 2) as avg_revenue_per_customer 
FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
JOIN products p
    ON t.product_id = p.product_id
GROUP BY c.yearly_income
ORDER BY avg_revenue_per_customer DESC;
/*Customer income does not show a direct relationship with spending. 
The $130K–$150K group has the highest average revenue per customer, 
while the $150K+ group has a lower average revenue than several middle-income groups.*/

## 11. Which income group has the highest average profit per customer?
select c.yearly_income,
       count(distinct t.customer_id) as total_customer,
	   round(sum((p.product_retail_price - p.product_cost) * t.quantity)/count(distinct t.customer_id),2) as avg_profit_per_customer 
FROM customers c
JOIN transactions t
    ON c.customer_id = t.customer_id
JOIN products p
    ON t.product_id = p.product_id
GROUP BY c.yearly_income
ORDER BY avg_profit_per_customer DESC;
/*Higher income does not necessarily mean higher customer value. 
The $130K–$150K group is the most valuable based on both average revenue ($222.28) and 
average profit ($132.67), while the $150K+ group ranks relatively low on both measures.*/

## 12. Which age group generates the highest revenue and profit?
desc customers;
SELECT
    customer_id,
    birth_date
FROM customers
LIMIT 10;

#Find each customer's first transaction date
SELECT
    customer_id,
    MIN(transactions_date) AS first_transaction_date
FROM transactions
GROUP BY customer_id
order by customer_id ;

#create column agegroup
ALTER TABLE customers
ADD COLUMN age_group_at_first_purchase VARCHAR(20);

set sql_safe_updates =0;
# insert data
UPDATE customers c
JOIN (
    SELECT
        customer_id,
        MIN(transactions_date) AS first_transaction_date
    FROM transactions
    GROUP BY customer_id
) ft
    ON c.customer_id = ft.customer_id
SET c.age_group_at_first_purchase =
    CASE
        WHEN TIMESTAMPDIFF(YEAR, c.birth_date, ft.first_transaction_date) < 25
            THEN 'Under 25'

        WHEN TIMESTAMPDIFF(YEAR, c.birth_date, ft.first_transaction_date)
             BETWEEN 25 AND 34
            THEN '25-34'

        WHEN TIMESTAMPDIFF(YEAR, c.birth_date, ft.first_transaction_date)
             BETWEEN 35 AND 44
            THEN '35-44'

        WHEN TIMESTAMPDIFF(YEAR, c.birth_date, ft.first_transaction_date)
             BETWEEN 45 AND 54
            THEN '45-54'

        WHEN TIMESTAMPDIFF(YEAR, c.birth_date, ft.first_transaction_date)
             BETWEEN 55 AND 64
            THEN '55-64'

        ELSE '65+'
    END;
    
 select age_group_at_first_purchase from customers;
 # validate total_customers, customers_with_age_group, customers_without_age_group
 SELECT
    COUNT(*) AS total_customers,
    COUNT(age_group_at_first_purchase) AS customers_with_age_group,
    SUM(age_group_at_first_purchase IS NULL) AS customers_without_age_group
FROM customers;

# check total customers of each age group 
SELECT
    age_group_at_first_purchase,
    COUNT(*) AS total_customers
FROM customers
WHERE age_group_at_first_purchase IS NOT NULL
GROUP BY age_group_at_first_purchase
ORDER BY total_customers DESC;

# then which age group generate the highest revenue
SELECT
    c.age_group_at_first_purchase AS age_group,

    COUNT(DISTINCT c.customer_id) AS total_customers,

    SUM(t.quantity) AS unit_sold,

    ROUND(
        SUM(p.product_retail_price * t.quantity),
        2
    ) AS revenue,

    ROUND(
        SUM((p.product_retail_price - p.product_cost) * t.quantity),
        2
    ) AS profit,

    ROUND(
        SUM(p.product_retail_price * t.quantity)
        / COUNT(DISTINCT c.customer_id),
        2
    ) AS avg_revenue_per_customer,

    ROUND(
        SUM((p.product_retail_price - p.product_cost) * t.quantity)
        / COUNT(DISTINCT c.customer_id),
        2
    ) AS avg_profit_per_customer

FROM customers c

JOIN transactions t
    ON c.customer_id = t.customer_id

JOIN products p
    ON t.product_id = p.product_id

WHERE c.age_group_at_first_purchase IS NOT NULL

GROUP BY c.age_group_at_first_purchase

ORDER BY revenue DESC;

/*Customers aged 65+ generate the highest total revenue and profit because they represent the largest customer group.
 However, customers aged 35–44 have the highest average revenue and profit per customer, making them the most valuable
 customer segment on an individual basis. Customers under 25 have the lowest average revenue and profit per customer.*/
 
 #13. How many customers purchased in both 1997 & 1998?
 
 select count(*) as customers_both_year
 from
      (select customer_id,
        count(distinct year(transactions_date))
        from transactions 
        group by customer_id
        having count( distinct year(transactions_date)) = 2) as customer_year;

/*RetailMart retained 4,799 customers who made purchases in both 1997 and 1998, indicating a significant base of returning customers.*/

# 14.What percentage of 1997 customers returned and purchased again in 1998
/* Retention Rate =
Customers who purchased in BOTH years
÷
Customers who purchased in 1997
× 100 */
# USING CTE
with customers_bothyear as 
(select count(*) as customers_bothyear
 from
      (select customer_id,
        count(distinct year(transactions_date))
        from transactions 
        group by customer_id
        having count( distinct year(transactions_date)) = 2) as customer_year),

customers_1997 as
(select count(distinct customer_id) as customers_1997 from transactions
where year(transactions_date) = 1997)


select cb.customers_bothyear,
	c97. customers_1997,
    round(cb.customers_bothyear/c97.customers_1997 * 100 ,2) as retention_percentage
from customers_bothyear cb
cross join customers_1997 c97;

/*RetailMart retained 4,799 out of 5,581 customers from 1997, resulting in an 85.99% year-over-year customer retention rate.*/

#15. How much revenue comes from retained customers vs new customers in 1998?
#using cte

with customer_year as (
      select customer_id,
			 min(year(transactions_date)) as frist_purchesh_year,
             max(year(transactions_date)) as last_purchase_year
	  from transactions
      group by customer_id),
      
customer_type as(
       select customer_id ,
              case when frist_purchesh_year = 1997 and last_purchase_year = 1998 then "retained_customer"
                   when frist_purchesh_year = 1998 and last_purchase_year = 1998 then "new_customers"
		      end as customer_type
		from customer_year)

select ct.customer_type,
	   count(distinct ct.customer_id) as total_customers,
       round(sum(p.product_retail_price * t.quantity),2) as revenue
from customer_type ct
join transactions as t
on ct.customer_id = t.customer_id
join products p
on t.product_id = p.product_id
where year(t.transactions_date) = 1998
group by ct.customer_type;
/*In 1998, new customers generated higher total revenue ($625.37K) than retained customers ($573.93K), 
despite having fewer customers (3,261 vs 4,799).
 What does this tell us?
New customers contributed more total revenue in 1998.
Retained customers were a larger customer group, but their combined 1998 revenue was lower.
This suggests that new-customer acquisition made a significant contribution to 1998 revenue.
However, we should not conclude that new customers are more valuable than retained customers yet,
because total revenue is affected by the number and purchasing behavior of customers in each group.*/

# 16. Do retained customers or new customers generate more revenue per customer in 1998?
with customer_year as (
      select customer_id,
			 min(year(transactions_date)) as frist_purchesh_year,
             max(year(transactions_date)) as last_purchase_year
	  from transactions
      group by customer_id),
      
customer_type as(
       select customer_id ,
              case when frist_purchesh_year = 1997 and last_purchase_year = 1998 then "retained_customer"
                   when frist_purchesh_year = 1998 and last_purchase_year = 1998 then "new_customers"
		      end as customer_type
		from customer_year)

select ct.customer_type,
	   count(distinct ct.customer_id) as total_customers,
       round(sum(p.product_retail_price * t.quantity) /
       count(distinct ct.customer_id),2) as avg_revenue_per_customer
	
from customer_type ct
join transactions as t
on ct.customer_id = t.customer_id
join products p
on t.product_id = p.product_id
where year(t.transactions_date) = 1998
group by ct.customer_type;

/*New customers generated significantly higher average revenue per customer ($191.77) than retained customers ($119.59) in 1998, 
indicating that newly acquired customers had stronger revenue contribution per customer during the year. Further analysis of purchase
 frequency and units sold can help identify the reason. */
 
 # 17. Which customers contribute the largest share of total revenue?
 select t.customer_id ,
        round(sum(p.product_retail_price * t.quantity),2) revenue
from transactions as t
join products as p
on p.product_id =t.product_id
group by customer_id
order by revenue desc;

/*ustomer 5295 is the highest revenue-generating customer, contributing $2,235.43, followed by customers 4727 ($2,121.31) and 4676 ($1,995.21).*/

## 18. total revenue comes from the top 10 customers?
SELECT
    ROUND(SUM(p.product_retail_price * t.quantity), 2) AS total_revenue
FROM transactions t
JOIN products p
    ON p.product_id = t.product_id; # total revenue
    
WITH customer_revenue AS (
    SELECT
        t.customer_id,
        SUM(p.product_retail_price * t.quantity) AS revenue
    FROM transactions t
    JOIN products p
        ON p.product_id = t.product_id
    GROUP BY t.customer_id
)
SELECT
    ROUND(SUM(revenue), 2) AS top_10_revenue
FROM (
    SELECT revenue
    FROM customer_revenue
    ORDER BY revenue DESC
    LIMIT 10
) x; # top 10 customer revenue


