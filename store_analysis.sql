/* store analysis ===

Which stores have the highest number of transactions?
Which stores sell the highest number of units?
Which stores have the highest average transaction value?
Which stores have the highest customer reach? (if customer data supports it)
Which stores have the highest return rate?
Which stores have the best overall performance?
Which stores are underperforming?
*/

## Question 1: Which stores have the highest number of transactions?
select store_id,
       count(*) as total_transactions
from transactions
group by store_id
order by total_transactions desc;

/*Store 13 processed the highest number of transactions (25,865), while Store 5 processed the fewest (1,470). 
The similar ranking between transaction volume and sales suggests that stores handling more transactions generally generate higher sales.*/

## Q.2 Which stores sell the highest number of units?
select store_id,
	   sum(quantity) as unit_sold
from transactions
group by store_id
order by unit_sold desc;

/*Store 13 sold the highest number of units (80,762), while Store 5 sold the fewest (2,401).
 The close alignment between transaction volume and units sold suggests that stores with more transactions also tend to sell more units.*/
 
 ## Q 3. Which stores have the highest average transaction value?
 -- Average Transaction Value = Total Sales Revenue ÷ Number of Transactions
 select store_id,
      round(sum(p.product_retail_price * t.quantity),2) as revenue_per_store,
      count(*) as number_transaction,
      round(
      sum(p.product_retail_price * t.quantity) /count(*)
      ,2) as avg_transaction_value
from transactions t
join products p
on t.product_id = p.product_id
group by store_id
order by avg_transaction_value desc;
/*
Store 20:
High value per transaction + low transaction volume → Low overall sales.
Store 13:
Slightly lower value per transaction + very high transaction volume → Highest overall sales.
So:
Overall sales depend on both transaction volume and average transaction value.
 Project Insight ====
Store 20 had the highest average transaction value at $6.75, while Store 5 had the lowest at $3.34. Store 13 generated 
the highest overall revenue despite having a lower average transaction value of $6.59, because of its significantly higher transaction volume.*/

## Q. 4 Which stores have the highest customer reach?(count customer for each store)
-- This tells us how many unique customers purchased from each store.

select store_id,
      count(distinct customer_id) as total_customer
from transactions
group by store_id
order by total_customer desc;

/*Store 7 reached the highest number of unique customers (1,470), while Store 13 generated the highest sales with only 474 unique customers.
 This suggests that Store 13's strong sales performance may be driven more by repeat purchasing, whereas Store 7 has a broader customer base.*/
 
 ## Q.5  Which stores have the highest return rate?
 -- Return Rate % = Returned Units ÷ Sold Units × 100
 
with returns as( select store_id,
        sum(quantity) as return_unites
from returns_1997_1998
group by store_id
),

sold as (select store_id,
      sum(quantity) as sold_units
from transactions
group by store_id
)


select r.store_id,
r.return_unites,
s.sold_units,
round((r.return_unites / s.sold_units) * 100 ,2) as return_rate
from returns r
join sold s
on r.store_id = s.store_id
order by return_rate desc;

/*Store 8 recorded the highest return rate at 1.17%, while Store 13 had a lower return rate of 0.91% despite being the highest-selling store.
 Overall, store return rates remained relatively low and close to each other, ranging from 0.91% to 1.17%.*/
 
 
## 6. Which stores have the best overall performance?
/*Since "overall performance" depends on more than one metric, we'll evaluate stores using 4 KPIs:
 Total Sales
 Number of Transactions
 Units Sold
 Unique Customers*/
 
WITH store_metrics AS (
    SELECT
        t.store_id,

        ROUND(
            SUM(t.quantity * p.product_retail_price),
            2
        ) AS total_sales,

        COUNT(*) AS total_transactions,

        SUM(t.quantity) AS total_units_sold,

        COUNT(DISTINCT t.customer_id) AS unique_customers

    FROM transactions AS t
    JOIN products AS p
        ON t.product_id = p.product_id

    GROUP BY t.store_id
),

store_ranking AS (
    SELECT
        *,
        
        RANK() OVER (
            ORDER BY total_sales DESC
        ) AS sales_rank,

        RANK() OVER (
            ORDER BY total_transactions DESC
        ) AS transaction_rank,

        RANK() OVER (
            ORDER BY total_units_sold DESC
        ) AS units_rank,

        RANK() OVER (
            ORDER BY unique_customers DESC
        ) AS customer_rank

    FROM store_metrics
)

SELECT
    store_id,
    total_sales,
    total_transactions,
    total_units_sold,
    unique_customers,
    sales_rank,
    transaction_rank,
    units_rank,
    customer_rank,

    (
        sales_rank +
        transaction_rank +
        units_rank +
        customer_rank
    ) AS overall_rank_score

FROM store_ranking

ORDER BY overall_rank_score; -- rank is lowest means best score / performance
/*
Store 13 is RetailMart's strongest overall performer, ranking first in sales, transactions, and units sold.
 Store 15 is the second strongest based on the combined ranking, while Stores 5, 22, 2, and 14 show comparatively weaker overall performance.
*/

## Q. 7 Which stores are underperforming?
WITH store_metrics AS (
    SELECT
        t.store_id,

        ROUND(
            SUM(t.quantity * p.product_retail_price),
            2
        ) AS total_sales,

        COUNT(*) AS total_transactions,

        SUM(t.quantity) AS total_units_sold,

        COUNT(DISTINCT t.customer_id) AS unique_customers

    FROM transactions AS t
    JOIN products AS p
        ON t.product_id = p.product_id

    GROUP BY t.store_id
),

store_ranking AS (
    SELECT
        *,
        
        RANK() OVER (
            ORDER BY total_sales DESC
        ) AS sales_rank,

        RANK() OVER (
            ORDER BY total_transactions DESC
        ) AS transaction_rank,

        RANK() OVER (
            ORDER BY total_units_sold DESC
        ) AS units_rank,

        RANK() OVER (
            ORDER BY unique_customers DESC
        ) AS customer_rank

    FROM store_metrics
),

final_ranking AS (
    SELECT
        *,
        sales_rank
        + transaction_rank
        + units_rank
        + customer_rank AS overall_rank_score
    FROM store_ranking
)

SELECT
    store_id,
    total_sales,
    total_transactions,
    total_units_sold,
    unique_customers,
    overall_rank_score
FROM final_ranking
ORDER BY overall_rank_score DESC
LIMIT 5;

/*Stores 5, 22, 2, 14, and 18 are the weakest-performing stores based on the combined ranking of sales, transactions, units sold, 
and unique customers. Store 5 is the most underperforming, with only $4,903.20 in sales and 1,470 transactions. 
These stores may require further investigation into customer traffic, product availability, and local demand.*/



