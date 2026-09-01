#product analysis
##1. Which products generate the highest revenue? 
select p.product_id ,
       p.product_name,
       sum(t.quantity) as unit_sold,
       round(sum(product_retail_price * quantity),2) as total_revenue
from products p 
join transactions t
on p.product_id = t.product_id
group by p.product_id ,
        p.product_name
order by total_revenue desc;

/*Hermanos Green Pepper generated the highest revenue at $2,489.70, with 645 units sold.
 Hilltop Mint Mouthwash was second with $2,447.12 from 676 units sold.
 it means: The product with the highest units sold is not necessarily the product with the highest revenue.*/
 
 
## 2: Which products generate the highest profit?
#Profit = (Retail Price − Product Cost) × Units Sold

select p.product_id,
       p.product_name,
       sum(t.quantity) as unit_sold,
       round(sum((p.product_retail_price - p.product_cost) * t.quantity),2) as profit
from products p 
join transactions t
on p.product_id = t.product_id
group by p.product_id ,
        p.product_name
order by profit desc;

/*Hermanos Green Pepper generated the highest profit of $1,670.55 from 645 units sold.
 Imagine Popsicles ranked second with $1,513.89 profit. alter
 it means : Hermanos Green Pepper is #1 in both revenue and profit.
 The product with the highest units sold is not necessarily the product with the highest profit*/
 
 ## 3.Which products have the highest profit margin? : This tells us which products are most profitable relative to their selling price, rather than just which products make the most total money.
 #Profit Margin = (Retail Price − Cost)* unit_sold ÷ (Retail Price * unit_sold) × 100
 
 select p.product_id,
       p.product_name,
       sum(t.quantity) as unit_sold,
       round(
             sum((p.product_retail_price - p.product_cost) * t.quantity)
             / 
             sum(p.product_retail_price * t.quantity)* 100, 2) as profit_margin
from products p 
join transactions t
on p.product_id = t.product_id
group by p.product_id ,
        p.product_name
order by profit_margin desc;

/*Landslide Sesame Oil has the highest profit margin at 70.69%. 
This means around 71% of its selling price is profit after product cost.
*/
/*Profit vs  Profit Margin %

Profit = How much money you actually earn.

Profit Margin % = What percentage of your sales is profit.

Example

Suppose you sell a product for $100.

Product cost = $60
Selling price = $100

So:

Profit = $100 − $60 = $40

Profit margin:

$40 ÷ $100 × 100 = 40%

So:

 Profit = $40 → actual money earned
 Profit Margin = 40% → percentage of sales that is profit

In our RetailMart project

If:

Hermanos Green Pepper

Profit = $1,670.55
Profit Margin ≈ 67% (depending on the exact calculation)

It means:

RetailMart earned $1,670.55 total profit from this product, while around 67% of its revenue was profit.
 Easy trick

Profit → "How much?" ]
Profit Margin → "How much %?" 
*/

##4: Which products sell the most units?
 select p.product_id,
       p.product_name,
       sum(t.quantity) as unit_sold
from products p 
join transactions t
on p.product_id = t.product_id
group by p.product_id ,
        p.product_name
order by unit_sold desc;

/*business insight

Tell Tale Fresh Lima Beans was the best-selling product, with 698 units sold. Steady Whitening Toothpast was second with 684 units.

And here's an interesting finding:

Hilltop Mint Mouthwash appears in both lists:

 676 units sold → 3rd highest in volume
 $2,447.12 revenue → 2nd highest revenue
 $1,493.96 profit → 3rd highest profit

So this product is a strong overall performer because it sells a lot and also generates high revenue and profit.*/

#5. Which products sell the least units?

select p.product_id,
       p.product_name,
       sum(t.quantity) as unit_sold
from products p 
join transactions t
on p.product_id = t.product_id
group by p.product_id ,
        p.product_name
order by unit_sold asc;

/*CDR Apple Preserves had the lowest sales volume, with only 240 units sold. Washington Berry Juice was second lowest with 245 units.
 These products may have lower customer demand and could be considered slow-moving products.
 One important point: We shouldn't say these products are definitely poor performers just because they sell fewer units.
 A product could sell fewer units but have a high selling price and high profit margin.*/
 
 # 6. Which products have the highest selling price?
 select product_id,
        product_name,
        product_cost,
        product_retail_price
from products
order by product_retail_price desc;

/*The highest product retail price is $3.98. Several products have the same highest selling price.*/

## 7. Which products perform best based on units sold, revenue, profit, and profit margin?
select p.product_id ,
       p.product_name,
       sum(t.quantity) as unit_sold,
       round(sum(product_retail_price * quantity),2) as total_revenue,
       round(sum((p.product_retail_price - p.product_cost) * t.quantity),2) as profit,
        round(
             sum((p.product_retail_price - p.product_cost) * t.quantity)
             / 
             sum(p.product_retail_price * t.quantity)* 100, 2) as profit_margin
from products p 
join transactions t
on p.product_id = t.product_id
group by p.product_id ,
        p.product_name
order by total_revenue desc;

/*Simple business insights

 Best overall performer:
Hermanos Green Pepper — highest revenue, highest profit, and highest margin among these products.

 Most sold:
Hilltop Mint Mouthwash — 676 units, but it doesn't have the highest profit because its margin is lower.

High-margin performer:
Hermanos Green Pepper — 67.10% margin.

 Needs attention:
Moms Foot-Long Hot Dogs — it sells 604 units and generates $2,325.40 revenue, but its profit is only $1,183.84 with a 50.91% margin,
 the lowest among these products.*/
 
 
 