# 🛒 RetailMart Sales & Business Analysis | SQL Project

## 📌 Project Overview

This project analyzes RetailMart's business data using **SQL** to identify meaningful insights related to products, customers, sales, returns, stores, and regional performance.

The objective of this project was to transform raw retail data into actionable business insights by answering **60+ business questions** using SQL queries, aggregations, joins, Common Table Expressions (CTEs), window functions, and ranking techniques.

The analysis covers:

* 📦 Product Performance
* 👥 Customer Behavior
* 🔄 Return Analysis
* 💰 Sales Performance
* 🏪 Store Performance
* 🌍 Regional Performance
* 📊 Business KPIs

---

# 🎯 Business Objective

The main objective of this project is to help RetailMart understand:

* Which products generate the highest sales and profit?
* Which customers contribute the most to the business?
* How are returns affecting business performance?
* How has sales performance changed over time?
* Which stores are performing well or underperforming?
* Which regions and districts generate the most revenue?
* Where are the major opportunities for business improvement?

---

# 🗂️ Dataset Overview

The RetailMart dataset contains information related to customers, products, stores, transactions, returns, and regions.

| Table        | Description                                                      |
| ------------ | ---------------------------------------------------------------- |
| Customers    | Customer demographic and related information                     |
| Products     | Product details, retail price, cost, brand, and other attributes |
| Transactions | Sales transaction records from 1997 and 1998                     |
| Returns      | Returned product information                                     |
| Stores       | Store-related information and region mapping                     |
| Region       | Sales region and sales district information                      |

### Dataset Scale

* **10,000+ customer records**
* **1,561 products**
* **24 stores**
* **7 sales regions**
* **21 sales districts**
* **60+ business questions analyzed**
* **833,489 total units sold**

---

# 🛠️ Tools & Technologies

* **MySQL**
* SQL
* MySQL Workbench
* Excel
* GitHub

---

# 🧠 SQL Concepts Used

This project demonstrates the use of:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* Aggregate Functions
* `JOIN`
* `CASE`
* Common Table Expressions (`CTEs`)
* Window Functions
* `RANK()`
* `ROW_NUMBER()`
* `LAG()`
* Date Functions
* `COUNT(DISTINCT)`
* Business KPI Calculations

---

# 📊 Analysis Performed

## 1️⃣ Product Analysis

Product analysis was performed to understand product performance based on sales, revenue, profit, quantity, and other product-related metrics.

Key areas analyzed:

* Top-performing products
* Lowest-performing products
* Products generating the highest revenue
* Products generating the highest profit
* Product sales and profitability comparison
* Product-level business performance

### Key Insight

Product analysis helped identify which products contributed most significantly to RetailMart's revenue and profit, allowing high-performing products to be distinguished from weaker-performing products.

---

# 2️⃣ Customer Analysis

Customer analysis focused on understanding customer purchasing behavior and contribution to overall business performance.

Key areas analyzed:

* Customer purchase behavior
* Top customers based on spending
* Customer contribution to revenue
* Customer purchasing patterns
* Customer segmentation and performance

### Key Insight

The analysis helped identify valuable customers and understand differences in customer purchasing behavior across the dataset.

---

# 3️⃣ Return Analysis

Return analysis was performed to understand product returns and identify potential areas requiring further investigation.

Key areas analyzed:

* Total returned products
* Return patterns
* Product-level returns
* Store-level return rates
* Return-related performance

### Key Insight

Store-level return rates were relatively close across the analyzed stores, ranging from approximately **0.91% to 1.17%**.

Store 8 recorded the highest return rate at **1.17%**, while Store 13 maintained a relatively lower return rate of **0.91%** despite generating the highest sales.

---

# 4️⃣ Sales Analysis

Sales analysis focused on understanding RetailMart's overall revenue performance and identifying trends over time.

## 💰 Total Sales Revenue

**Total Sales Revenue: $1,764,546.44**

---

## 📈 Yearly Sales Performance

| Year |   Total Sales |
| ---- | ------------: |
| 1997 |   $565,238.13 |
| 1998 | $1,199,308.31 |

### Key Insight

RetailMart's sales increased by **112.18% in 1998 compared with 1997**.

> Note: The difference in transaction data volume between 1997 and 1998 may have influenced this comparison.

---

## 📅 Monthly Sales Performance

The analysis identified sales patterns across months.

### Key Insight

**December 1998 recorded the highest monthly sales at $120,160.84.**

The lowest monthly sales in the dataset occurred in **October 1997 at $42,342.27**.

---

## 🏪 Store Sales Performance

Store 13 generated the highest overall sales:

**$170,398.94**

Store 17 ranked second with:

**$157,695.90**

---

## 📦 Units Sold

| Year | Units Sold |
| ---- | ---------: |
| 1997 |    266,773 |
| 1998 |    566,716 |

### Total Units Sold

**833,489 units**

---

## 📅 Day-Wise Sales

Thursday generated the highest sales:

**$266,162.12**

Tuesday generated the lowest sales:

**$234,129.83**

---

# 5️⃣ Store Analysis

Store analysis was performed using multiple performance indicators rather than relying only on sales revenue.

The following **7 key questions** were analyzed:

### 1. Which stores have the highest number of transactions?

* **Store 13:** 25,865 transactions
* **Store 17:** 23,600 transactions
* **Store 5:** 1,470 transactions

### Insight

Store 13 processed the highest number of transaction records, while Store 5 had the lowest transaction activity.

---

### 2. Which stores sell the highest number of units?

* **Store 13:** 80,762 units
* **Store 17:** 74,347 units
* **Store 5:** 2,401 units

### Insight

Store 13 ranked first in both transaction volume and units sold.

---

### 3. Which stores have the highest average transaction value?

* **Store 20:** $6.75 per transaction
* **Store 24:** $6.73
* **Store 8:** $6.70

### Insight

Store 20 had the highest average transaction value but relatively low overall sales because of lower transaction volume.

This demonstrates that:

> **Overall sales depend on both transaction volume and transaction value.**

---

### 4. Which stores have the highest customer reach?

* **Store 7:** 1,470 unique customers
* **Store 6:** 1,445 unique customers
* **Store 24:** 1,146 unique customers

### Insight

Store 7 had the highest customer reach, while Store 13 generated the highest sales despite reaching fewer unique customers.

This suggests that Store 13's strong performance may be influenced by repeat purchasing activity.

---

### 5. Which stores have the highest return rate?

Return Rate Formula:

**Return Rate = Returned Units ÷ Sold Units × 100**

* **Store 8:** 1.17%
* **Store 20:** 1.14%
* **Store 23:** 1.12%
* **Store 13:** 0.91%

### Insight

Store 8 had the highest return rate, while Store 13 maintained a relatively low return rate despite being the highest-selling store.

---

### 6. Which stores have the best overall performance?

Store performance was evaluated using four metrics:

* Total Sales
* Number of Transactions
* Units Sold
* Unique Customers

Each store was ranked, and the ranks were combined into an **Overall Rank Score**.

### Top Performing Stores

| Store    | Overall Rank Score |
| -------- | -----------------: |
| Store 13 |                 12 |
| Store 15 |                 13 |
| Store 7  |                 18 |
| Store 11 |                 18 |
| Store 17 |                 18 |

### Key Insight

Store 13 was the strongest overall performer, ranking:

* #1 in Sales
* #1 in Transactions
* #1 in Units Sold

---

### 7. Which stores are underperforming?

The lowest-performing stores based on the combined ranking were:

| Store    | Overall Rank Score |
| -------- | -----------------: |
| Store 5  |                 88 |
| Store 22 |                 82 |
| Store 2  |                 79 |
| Store 14 |                 76 |
| Store 18 |                 74 |

### Key Insight

Store 5 showed the weakest overall performance, with:

* **$4,903.20 in sales**
* **1,470 transactions**
* **2,401 units sold**

These stores may require further investigation into customer traffic, demand, product availability, and local market conditions.

---

# 6️⃣ Region Analysis

Region analysis was performed using the relationship:

**Transactions → Stores → Region**

The following four key questions were analyzed.

---

## 1. Which sales regions generate the highest revenue?

| Sales Region   | Total Sales |
| -------------- | ----------: |
| North West     | $847,826.72 |
| Mexico Central | $330,362.03 |
| South West     | $320,804.78 |
| Canada West    | $107,674.34 |
| Mexico South   |  $87,253.65 |
| Mexico West    |  $61,299.98 |
| Central West   |   $9,324.94 |

### Key Insight

**North West was the dominant sales region**, generating:

**$847,826.72**

This represents approximately **48% of total RetailMart revenue**.

---

## 2. Which sales districts generate the highest revenue?

Top sales districts included:

* **Los Angeles:** $209,426.32
* **Salem:** $170,398.94
* **Tacoma:** $157,695.90

The lowest-performing district was:

* **Guadalajara:** $4,903.20

### Key Insight

The top three sales districts generated approximately **30.5% of total RetailMart revenue**, indicating that a significant portion of sales was concentrated in a few leading districts.

---

## 3. Which sales regions have the highest customer reach?

| Sales Region   | Unique Customers |
| -------------- | ---------------: |
| North West     |            3,083 |
| South West     |            2,756 |
| Canada West    |            1,380 |
| Mexico Central |              724 |
| Central West   |              518 |
| Mexico West    |              283 |
| Mexico South   |               98 |

### Key Insight

North West had both the **highest customer reach** and the **highest total sales**, making it the strongest region in terms of business scale.

---

## 4. Which regions generate the highest revenue per customer?

| Sales Region   | Revenue per Customer |
| -------------- | -------------------: |
| Mexico South   |              $890.34 |
| Mexico Central |              $456.30 |
| North West     |              $275.00 |
| Mexico West    |              $216.61 |
| South West     |              $116.40 |
| Canada West    |               $78.02 |
| Central West   |               $18.00 |

### Key Insight

Mexico South generated the highest revenue per customer at **$890.34**, despite having only **98 unique customers**.

This indicates that:

> **North West is strongest in terms of scale, while Mexico South has a smaller but higher-value customer base.**

---

# 🔑 Overall Business Insights

The analysis revealed several important findings:

### 🥇 1. Strong Sales Growth

RetailMart generated **$1.76M in total sales**, with sales increasing by **112.18% from 1997 to 1998**.

---

### 🏪 2. Store 13 Is the Strongest Overall Store

Store 13 ranked:

* #1 in Sales
* #1 in Transactions
* #1 in Units Sold

It generated **$170,398.94 in total sales**.

---

### 🌍 3. North West Dominates Regional Sales

North West generated approximately **48% of total company revenue** and had the largest customer base with **3,083 unique customers**.

---

### 👥 4. High Customer Count Does Not Always Mean Higher Revenue

South West had **2,756 unique customers**, but North West generated significantly more revenue.

This shows that customer quantity alone does not determine regional revenue performance.

---

### 💎 5. Mexico South Has the Highest-Value Customers

Mexico South generated:

**$890.34 revenue per customer**

This was the highest among all sales regions despite having the smallest customer base.

---

### 📉 6. Some Stores Require Further Investigation

Stores 5, 22, 2, 14, and 18 consistently ranked lower across multiple performance metrics.

These stores may require further analysis of:

* Customer traffic
* Local demand
* Product availability
* Store operations

---

# 📈 Business Recommendations

Based on the analysis, the following recommendations can be considered:

1. **Investigate underperforming stores** to identify factors affecting low sales and transaction activity.

2. **Analyze the success of Store 13** and identify practices that could potentially be applied to other stores.

3. **Focus on Central West**, which generated the lowest regional sales and revenue per customer.

4. **Explore customer expansion opportunities in Mexico South**, which has a small customer base but the highest revenue per customer.

5. **Investigate Store 8's return rate** to identify potential product, quality, or customer expectation issues.

6. **Maintain and strengthen the North West region**, which is the largest contributor to overall business revenue.

---

# 📂 Project Structure

```text
RetailMart-SQL-Analysis/
│
├── README.md
├── data/
│   ├── customers.csv
│   ├── products.csv
│   ├── stores.csv
│   ├── region.csv
│   ├── transactions_1997.csv
│   ├── transactions_1998.csv
│   └── returns_1997_1998.csv
│
├── sql/
│   ├── data_cleaning&data_validation.sql
│   ├── EDA.sql
│   ├── product_analysis.sql
│   ├── customer_analysis.sql
│   ├── return_analysis.sql
│   ├── sales_analysis.sql
│   ├── store_analysis.sql
│   └── region_analysis.sql
│
└── images/
    └── dashboard_screenshots/
```

---

# 🚀 Conclusion

This project demonstrates how SQL can be used to transform raw retail data into meaningful business insights.

The analysis covered product performance, customer behavior, returns, sales trends, store performance, and regional performance using **60+ business questions and multiple SQL techniques**.

The project highlights the importance of evaluating business performance from multiple perspectives instead of relying on a single metric such as sales revenue.

---

## 👩‍💻 Author

**Shital Patidar**

MCA | Data Analytics | SQL | Excel | Tableau | Python
