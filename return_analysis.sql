## return analysis
/* Overall return rate
        ↓
 Highest return-rate products
        ↓
 Highest returned quantity products
        ↓
 High sales + high returns
        ↓
 Store return performance
        ↓
 Customers with most returns
        ↓
 % customers making returns
        ↓
 High returns + low profit
        ↓
 Financial impact of returns
        ↓
 Return trend over time*/
 
 # Q1. What is the overall return rate?
 -- Return Rate = Returned Units ÷ Sold Units × 100
 -- we can not join return and transaction directly Because both transactions and returns can contain multiple rows for the same product/store. If we join them directly,
 -- the rows can multiply, and our totals become wrong.
with returns as (select sum(quantity) as return_units from returns_1997_1998),
transaction as (select sum(quantity) as sold_units from transactions)

select round(r.return_units/t.sold_units * 100 ,1) as return_rate from 
returns as r
cross join transaction as t;
/*RetailMart has an overall return rate of only 0.99%, meaning fewer than 1 out of every 100 sold units was returned.*/

##Q2. Which products have the highest return rate?
select  product_id, sum(quantity) sold_products from transactions group by product_id order by sold_products desc;
select product_id, sum(quantity) return_product from returns_1997_1998 group by product_id order by return_product desc;

with sold as (select  product_id, sum(quantity) sold_products from transactions group by product_id order by sold_products desc),

returns as (select product_id, sum(quantity) return_product from returns_1997_1998 group by product_id order by return_product desc)

select r.product_id ,round(r.return_product / s.sold_products * 100, 2) as rate
from sold as s
left join returns as r
on s.product_id = r.product_id
order by rate desc;

select product_name from products where product_id = 574;

/*Product 574 has the highest return rate at 2.93%, followed by products 1432 (2.83%) and 581 (2.79%).
 These products have a relatively higher proportion of their sold units being returned and may require further investigation.*/
 
## Q3: Which products have the highest number of returned units?
#This is worth doing because return rate and return volume tell different stories.
SELECT
    product_id,
    SUM(quantity) AS returned_units
FROM returns_1997_1998
GROUP BY product_id
ORDER BY returned_units DESC;
/*Product 1432 has the highest return volume with 17 returned units, followed by products 581 and 1461 with 15 returns each. These products should be prioritized for further investigation because they generate the highest number of returned units.
Important distinction = 
Product 574 had the highest return rate → 2.93%
Product 1432 has the highest return volume → 17 units*/

##Q4 —  Which products have both high sales volume and high return volume?

WITH returns AS (
                     -- Calculate total units sold for each product
    SELECT
        product_id,
        SUM(quantity) AS return_units
    FROM returns_1997_1998
    GROUP BY product_id
),

sold AS (
             -- Calculate total units returned for each product
    SELECT
        product_id,
        SUM(quantity) AS sold_units
    FROM transactions
    GROUP BY product_id
),

product_data AS (
                     -- Combine sold and returned quantities for each product
    SELECT
        s.product_id,
        s.sold_units,
        COALESCE(r.return_units, 0) AS return_units -- If a product has no return record, treat it as 0 returns
    FROM sold s
               -- left join - Keep every sold product, even if it has no returns
    LEFT JOIN returns r
        ON s.product_id = r.product_id
),

averages AS (
                 -- Calculate the average sold and returned units across all products
    SELECT
        AVG(sold_units) AS avg_sold_units,
        AVG(return_units) AS avg_return_units
    FROM product_data
)

SELECT
    pd.product_id,
    pd.sold_units,
    pd.return_units,
                        -- Calculate return rate for each product
    ROUND(
        pd.return_units / pd.sold_units * 100,
        2
    ) AS return_rate
FROM product_data pd
                    -- Bring the average values into the same query
CROSS JOIN averages a
                     -- Keep only products above average in BOTH sales and returns
WHERE pd.sold_units > a.avg_sold_units
  AND pd.return_units > a.avg_return_units
ORDER BY pd.return_units DESC; -- Show products with the highest number of returns first

/* we used avrages Because we needed to decide what high sales and high returns mean. We used the average of all products as a simple reference.
 Products above both averages were considered high-sales and high-return products.

""Business Insight"" — High Sales + High Returns

Products such as 1432, 1461, and 581 stand out because they have both relatively high sales and high return volumes:

Product 1432: 601 sold, 17 returned → 2.83%
Product 1461: 554 sold, 15 returned → 2.71%
Product 581: 538 sold, 15 returned → 2.79%

These products combine strong sales volume with relatively high return activity, making them important candidates for investigation.
 Since they generate substantial sales, even a modest return rate can create a meaningful operational burden.
 
 But is average always best?
 No.
If a few products have extremely huge sales, they can make the average very high. In that situation, we can use the middle value (median) instead.
But for our RetailMart project, using the average is simple and reasonable for this question.*/

##Q5 — Which stores have the highest return rate?
#Return Rate = Returned Units ÷ Sold Units × 100
with sold as (select store_id, sum(quantity) sold_units from transactions group by store_id ),
returns as (select store_id, sum(quantity) returns_units from returns_1997_1998 group by store_id )

select s.store_id, s.sold_units,
	   COALESCE(r.returns_units, 0) AS return_units,
	   COALESCE(round(r.returns_units / s.sold_units * 100 , 2),0) as return_rate
from sold s
left join returns r
on s.store_id = r.store_id
order by return_rate desc;

## Q.6 Which products have a high number of returned units but generate low profit?
WITH profit AS (
    SELECT
        t.product_id,
        SUM(t.quantity) AS sold_units,
        p.product_name,
        ROUND(
            SUM((p.product_retail_price - p.product_cost) * t.quantity),
            2
        ) AS profit
    FROM transactions t
    JOIN products p
        ON p.product_id = t.product_id
    GROUP BY
        t.product_id,
        p.product_name
),

product_returns AS (
    SELECT
        product_id,
        SUM(quantity) AS return_units
    FROM returns_1997_1998
    GROUP BY product_id
),

combined AS (
    SELECT
        p.product_id,
        p.product_name,
        p.sold_units,
        COALESCE(r.return_units, 0) AS return_units,
        p.profit
    FROM profit p
    LEFT JOIN product_returns r
        ON p.product_id = r.product_id
)

SELECT
    product_id,
    product_name,
    sold_units,
    return_units,
    profit
FROM combined
WHERE return_units > (
          SELECT AVG(return_units)
          FROM combined
      )
  AND profit < (
          SELECT AVG(profit)
          FROM combined
      )
ORDER BY return_units DESC;
/*I used the average return units and average profit as benchmarks fro comparision products with above-average returns and below-average profit.
""Business Insights"" ===
10 products were identified with above-average returns and below-average profit, indicating potential problem products.
These products have 12–14 returned units, suggesting relatively high return activity.
Atomic Tasty Candy Bar has the lowest profit at ₹168.12, despite 13 returned units.
Fort West Beef Jerky has 13 returns with only ₹306.34 profit, indicating a potential financial concern.
RetailMart should investigate product quality, customer complaints, and return reasons for these products to reduce returns and improve profitability.
*/

## Q.7 How much financial value is associated with the products that customers returned?
/*For Financial Impact of Returns, we'll calculate:
Return Sales Value = returned units × retail price
Return Cost Value = returned units × product cost
Potential Profit Impact = Return Sales Value − Return Cost Value*/
-- Return Cost = Returned Units × Product Cost
select r.product_id,
       p.product_name,
       sum(r.quantity) as return_units,
       ROUND(
        SUM(r.quantity * p.product_retail_price),
        2
    ) AS return_sales_value,
       round(sum(r.quantity*p.product_cost),2) as return_cost_value,
       ROUND(
        SUM(
            r.quantity *
            (p.product_retail_price - p.product_cost)
        ),
        2
    ) AS potential_profit_impact
FROM returns_1997_1998 r
jOIN products p
    ON r.product_id = p.product_id
GROUP BY
    r.product_id,
    p.product_name
ORDER BY
    potential_profit_impact DESC;
/*
2 products are shown with the highest potential profit impact, ranging from ₹20.07 to ₹26.04.
Even Better Large Curd Cottage Cheese has the highest potential profit impact at ₹26.04, making it the first product to investigate.
Nationeel Apple Fruit Roll and Medalist Rice Medly follow with impacts of ₹24.96 and ₹24.20, respectively.
The top products have 8–17 returned units, showing that both return quantity and product margin contribute to the financial impact.
Products with the highest potential profit impact should be prioritized because reducing their returns could help protect profitability.
RetailMart should prioritize these products for investigating return reasons, product quality, and customer complaints.*/

##Q.8 How have product returns changed over time?
select 
      year(returns_date) as year,
      month(returns_date) as months,
      sum(quantity) as return_units
from returns_1997_1998
group by year(returns_date),
      month(returns_date) 
order by year,months;

-- lest find sold unit also
SELECT
    YEAR(transactions_date) AS year,
    SUM(quantity) AS sold_units
FROM transactions
GROUP BY YEAR(transactions_date)
ORDER BY year;

/*Business Insight
Returns increased from 2,638 to 5,657 units (114%).
However, sales volume also increased substantially from 266,773 to 566,716 units (112%).
The return rate remained almost stable at ~1%.
Therefore, the increase in return units is mainly explained by higher sales volume, rather than a major deterioration in return performance.
RetailMart should continue monitoring the monthly trend, especially Nov–Dec 1998, when returns reached 563 and 569 units.*/




