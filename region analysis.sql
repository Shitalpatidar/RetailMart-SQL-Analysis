## region analysis 
/*
1. Which sales regions generate the highest revenue?
2. Which sales districts generate the highest revenue?
3. Which sales regions have the highest number of customers?
4. Which sales regions are underperforming? */

## 1. Which regions generate the highest total sales?
SELECT
    r.sales_region,
    ROUND(
        SUM(t.quantity * p.product_retail_price),
        2
    ) AS total_sales
FROM transactions AS t

JOIN products AS p
    ON t.product_id = p.product_id

JOIN stores AS s
    ON t.store_id = s.store_id

JOIN regions AS r
    ON s.region_id = r.region_id

GROUP BY r.sales_region
ORDER BY total_sales DESC;

/*North West (847,826.72) is RetailMart's dominant sales region, contributing approximately 48% of total revenue. 
Mexico Central and South West are the next strongest regions, while Central West (9,324.94) contributes less than 1%, indicating a significant regional 
performance gap.*/

## 2. Which sales districts generate the highest total revenue?
SELECT
    r.sales_district,
    ROUND(
        SUM(t.quantity * p.product_retail_price),
        2
    ) AS total_sales
FROM transactions AS t

JOIN products AS p
    ON t.product_id = p.product_id

JOIN stores AS s
    ON t.store_id = s.store_id

JOIN regions AS r
    ON s.region_id = r.region_id

GROUP BY r.sales_district
ORDER BY total_sales DESC;
/*Los Angeles is the top-performing sales district with $209,426.32 in revenue, while Guadalajara has the lowest at $4,903.20.
 The top three districts contribute approximately 30.5% of total RetailMart revenue, indicating that sales are concentrated among a few leading
 districts.*/
 
 ## 3. Which sales regions have the highest number of unique customers?
 
 SELECT
    r.sales_region,
    COUNT(DISTINCT t.customer_id) AS unique_customers
FROM transactions AS t
JOIN stores AS s
    ON t.store_id = s.store_id
JOIN regions AS r
    ON s.region_id = r.region_id
GROUP BY r.sales_region
ORDER BY unique_customers DESC;

/*North West has the largest customer base with 3,083 unique customers and also generates the highest sales, indicating strong customer
 reach and revenue performance. Mexico South has the smallest customer base with only 98 customers, suggesting an opportunity for customer growth.*/
 
## Which sales regions have the highest revenue per customer?
SELECT
    r.sales_region,

    ROUND(
        SUM(t.quantity * p.product_retail_price),
        2
    ) AS total_sales,

    COUNT(DISTINCT t.customer_id) AS unique_customers,

    ROUND(
        SUM(t.quantity * p.product_retail_price)
        / COUNT(DISTINCT t.customer_id),
        2
    ) AS revenue_per_customer

FROM transactions AS t

JOIN products AS p
    ON t.product_id = p.product_id

JOIN stores AS s
    ON t.store_id = s.store_id

JOIN regions AS r
    ON s.region_id = r.region_id

GROUP BY r.sales_region
ORDER BY revenue_per_customer DESC;

/*North West is RetailMart's largest region by sales and customer reach, while Mexico South generates the highest revenue per customer
 at $890.34 despite having only 98 customers. This suggests North West is the strongest region for scale, whereas Mexico South has a smaller
 but significantly higher-value customer base.*/
 