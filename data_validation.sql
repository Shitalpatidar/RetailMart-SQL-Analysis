create database retailmart;
use retailmart;

select * from customers;
select * from products;
select * from regions;
select * from returns_1997_1998;
select * from stores;
select * from transactions_1997;
select * from transactions_1998; ## it a huge file so that we are doing all the below steps fro importing

/*-----------------------------------------------------------
 Step 1 : Enable LOCAL INFILE
 Reason:
 MySQL disables LOCAL INFILE by default for security reasons.
 We enable it so MySQL can import CSV files from our local
 computer.
------------------------------------------------------------*/
SET GLOBAL local_infile = 1;

/*-----------------------------------------------------------
 Step 2 : Verify that LOCAL INFILE is enabled
 Expected Result:
 local_infile = ON
------------------------------------------------------------*/
SHOW VARIABLES LIKE 'local_infile';

/*-----------------------------------------------------------
 Step 3 : Check MySQL secure import directory
 Reason:
 This shows the folder from which MySQL Server is allowed
 to read files when using LOAD DATA INFILE.
------------------------------------------------------------*/
SHOW VARIABLES LIKE 'secure_file_priv';

/*-----------------------------------------------------------
 Step 4 : Import Transactions_1998 CSV
 Reason:
 Import the sales transaction data into the
 transactions_1998 table.

 Notes:
 • CSV file was copied to MySQL's Uploads folder.
 • IGNORE 1 ROWS skips the header row.
 • FIELDS TERMINATED BY ',' specifies comma-separated values.
 • ENCLOSED BY '"' handles values enclosed in double quotes.
 • LINES TERMINATED BY '\r\n' handles Windows line endings.
------------------------------------------------------------*/
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions_1998.csv'
INTO TABLE transactions_1998
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    transaction_date,
    stock_date,
    product_id,
    customer_id,
    store_id,
    quantity
);

### Data Quality Validation
select count(*) as total_rows from customers;
select count(*) as total_rows from products;
select count(*) as total_rows from regions;
select count(*) as total_rows from returns_1997_1998;
select count(*) as total_rows from stores;
select count(*) as total_rows from transactions_1997;
select count(*) as total_rows from transactions_1998;
# Step 1: Column Validation
describe customers;
DESC products;
DESC stores;
DESC regions;
DESC returns_1997_1998;
DESC transactions_1997;
DESC transactions_1998;
# ----------------------------------------------------------------------------------------------------
# Step 2 : Check Duplicate primary keys 1.Customer IDs 2. product_id 3. store_id, 4. region_id, 
select customer_id, count(*)  as duplicateid
from customers
group by customer_id
having count(*) > 1;

select product_id, count(*)  as duplicateid
from products
group by product_id
having count(*) > 1;

select store_id, count(*)  as duplicateid
from stores
group by store_id
having count(*) > 1;

select region_id, count(*)  as duplicateid
from regions
group by region_id
having count(*) > 1;

select transaction_date, product_id,customer_id,store_id,stock_date, quantity, count(*)
from transactions_1997
group by transaction_date, product_id,customer_id,store_id,stock_date, quantity
having count(*) > 1;

 /* Result:
 Found 1 duplicate transaction record.
observation:
 Since the dataset does not contain a transaction_id or
 transaction_time, it is not possible to determine whether
 this is a genuine repeated purchase (The customer visited the store twice on the same day and bought the same product with the same quantity.)
 or an accidental duplicate.
 Action:
 No records were deleted.
 The duplicate was documented for business review.*/

select transaction_date, product_id,customer_id,store_id,stock_date, quantity, count(*)
from transactions_1998
group by transaction_date, product_id,customer_id,store_id,stock_date, quantity
having count(*) > 1; # found 8 duplicate rows (above explaination)

#---------------------------------------------------------------------------------------------------
#Step 3 : Check NULL values in all table
# customers
select 
sum(customer_id is null) as customerid_null,
sum(first_name is null) as first_name_null,
sum(last_name is null) as last_name_null,
sum(gender is null) as gender_null,
sum(birthdate is null) as birthdate_null,
sum(customer_country is null) as country_null
from customers;
# products
select 
sum(product_id is null) as product_id_null,
sum(product_name is null) as product_name_null,
sum(product_retail_price is null) as product_retail_price_null,
sum(product_cost is null) as product_cost_null,
sum(product_brand is null) as product_brand_null
from products;
# regions
select 
sum(region_id is null) as region_id_null,
sum(sales_district is null) as sales_district_null,
sum(sales_region is null) as sales_region_null
from regions;
# return
select 
sum(return_date is null) as return_date_null,
sum(product_id is null) as product_id_null,
sum(store_id is null) as store_id_null,
sum(quantity is null) as quantity_null
from returns_1997_1998;
#stores
select 
sum(store_id is null) as store_id_null,
sum(region_id is null) as region_id_null,
sum(store_type is null) as store_type_null,
sum(store_name is null) as store_name_null,
sum(store_street_address is null) as store_street_address_null,
sum(store_country is null) as store_country_null,
sum(store_city is null) as store_city_null,
sum(store_state is null) as store_state_null
from stores;

#transaction 1997
select 
sum(transaction_date is null) as transaction_date_null,
sum(stock_date is null) as stock_date_null,
sum(product_id is null) as product_id_null,
sum(customer_id is null) as customer_id_null,
sum(store_id is null) as store_id_null,
sum(quantity is null) as quantity_null
from transactions_1997;

#transactions_1998
select 
sum(transaction_date is null) as transaction_date_null,
sum(stock_date is null) as stock_date_null,
sum(product_id is null) as product_id_null,
sum(customer_id is null) as customer_id_null,
sum(store_id is null) as store_id_null,
sum(quantity is null) as quantity_null
from transactions_1998;

# ------------------------------------------------------------------------------
## 4.Foreign Key Validation  (Are there any customer_ids in transactions_1997 that do NOT exist in the customers table?"
# for transactions 1997
select customer_id
from transactions_1997
where customer_id not in (select customer_id from customers);

select product_id
from transactions_1997
where product_id not in (select product_id from products);

select store_id
from transactions_1997
where store_id not in (select store_id from stores);

# from tansaction 1998
select customer_id
from transactions_1998
where customer_id not in (select customer_id from customers);

select product_id
from transactions_1998
where product_id not in (select product_id from products);

select store_id
from transactions_1998
where store_id not in (select store_id from stores);

# returns
select store_id
from returns_1997_1998
where store_id not in (select store_id from stores);

select product_id
from returns_1997_1998
where product_id not in (select product_id from products);

# stores
select region_id
from stores
where region_id not in (select region_id from regions);
#------------------------------------------------------------
## 5. Domain Validation - A domain means the set of allowed values for a column.
#customers
select distinct gender from customers;
select distinct education from customers;
select distinct marital_status from customers;

#products
select * from products where product_cost <= 0;
select * from products where product_retail_price <= 0;
select * from products where product_retail_price < product_cost ;

# return
select * from returns_1997_1998 where quantity <= 0;

#transactions
select * from transactions_1997 where quantity<= 0;
select * from transactions_1998 where quantity<= 0;
#-------------------------------------------------------------------
## Date Validation 
# in customer birthdate  and account open date
#1. birthdate
/*
 Step : Convert Birthdate from TEXT to DATE

 Problem:
 Birthdate column contained mixed date formats:
 1. MM/DD/YYYY
 2. MM-DD-YYYY

 Solution:
 Used CASE with STR_TO_DATE() to convert both formats
 into MySQL DATE format (YYYY-MM-DD).*/
 
alter table customers
add column birth_date date;

select birthdate from customers;

#check / and - dates
select birthdate as slash
from customers where birthdate like '%/%';
select birthdate as slash
from customers where birthdate like '%-%';

set sql_safe_updates = 0;

update customers 
set birth_date = 
 case 
     when birthdate like '%/%'
          then str_to_date(birthdate, '%m/%d/%Y')
     when birthdate like '%-%'
		  then str_to_date(birthdate, '%m-%d-%Y')
end;

select birthdate , birth_date from customers limit 10;

SELECT COUNT(*) AS total_rows,
       COUNT(birth_date) AS converted_rows
FROM customers;

SELECT *
FROM customers
WHERE birth_date IS NULL;

# drop the old column birthdate
alter table customers
drop column birthdate ;

alter table customers
modify column birth_date date after customer_country;

select * from customers;

# account open date------------------
alter table customers
add column account_open_date date;

update customers 
set account_open_date =
case
    when acct_open_date like '%/%'
        then str_to_date(acct_open_date, '%m/%d/%Y')
	when acct_open_date like '%-%'
        then str_to_date(acct_open_date, '%m-%d-%Y')
end;

SELECT COUNT(*) AS total_rows,
       COUNT(acct_open_date) AS converted_rows
FROM customers;

SELECT *
FROM customers
WHERE acct_open_date IS NULL;

# drop the column
alter table customers
drop column acct_open_date;

alter table customers
modify column account_open_date date after education;

select * from customers;

## return---------------------
select return_date from returns_1997_1998;

alter table returns_1997_1998
add column returns_date date;

update returns_1997_1998 
set returns_date = str_to_date(return_date, '%m/%d/%Y');
	
#check exact count row
SELECT COUNT(*) AS total_rows,
       COUNT(returns_date) AS converted_rows
FROM returns_1997_1998;

# check from null
SELECT *
FROM returns_1997_1998
WHERE returns_date IS NULL;

# drop the column
alter table returns_1997_1998
drop column return_date;

alter table returns_1997_1998
modify column returns_date date first;

select * from returns_1997_1998;

# store-------------------------------------------------------------------
select first_opened_date, last_remodel_date from stores;

alter table stores
add column first_open_date date, 
add column last_remodell_date date;


update stores 
set first_open_date = str_to_date(first_opened_date, '%m/%d/%Y'), 
 last_remodell_date = str_to_date(last_remodel_date, '%m/%d/%Y');
	
#check count rows
SELECT COUNT(*) AS total_rows,
       COUNT(first_open_date) AS converted_rows,
	    COUNT(last_remodell_date) AS converted_rows2
FROM stores;

# check null values
SELECT sum(first_open_date is null) as nulls,
       sum(last_remodell_date is null) as nulls2
from stores;

# drop the column
alter table stores
drop column first_opened_date,
drop column last_remodel_date;

alter table stores
modify column first_open_date date after store_phone,
modify column last_remodell_date date after first_open_date;


ALTER TABLE stores
RENAME COLUMN last_remodell_date TO last_remodel_date;

select * from stores;

##transection 1997------------------------------------------------------------------
select transaction_date, stock_date from transactions_1997;

SELECT COUNT(*) AS slash_format
FROM transactions_1997
WHERE transaction_date LIKE '%/%';

SELECT COUNT(*) AS slash_format
FROM transactions_1997
where stock_date like '%/%';

alter table transactions_1997
add column transactions_date date, 
add column stocks_date date;


update transactions_1997 
set transactions_date = str_to_date(transaction_date, '%m/%d/%Y'), 
stocks_date = str_to_date(stock_date, '%m/%d/%Y');
	
#check count rows
SELECT COUNT(*) AS total_rows,
       COUNT(transactions_date) AS converted_rows,
	    COUNT(stock_date) AS converted_rows2
FROM transactions_1997;

# check null values
SELECT sum(transactions_date is null) as nulls,
       sum(stock_date is null) as nulls2
from transactions_1997;

select transactions_date, stocks_date from transactions_1997;
# drop the column
alter table transactions_1997
drop column transaction_date,
drop column stock_date;

alter table transactions_1997
modify column transactions_date date first ,
modify column stocks_date date after transactions_date;

select * from transactions_1997;

## transaction 1998----------------------------------------
select transaction_date, stock_date from transactions_1998;

SELECT COUNT(*) AS slash_format
FROM transactions_1998
WHERE transaction_date LIKE '%/%';

SELECT COUNT(*) AS slash_format
FROM transactions_1998
where stock_date like '%/%';

alter table transactions_1998
add column transactions_date date, 
add column stocks_date date;


update transactions_1998
set transactions_date = str_to_date(transaction_date, '%m/%d/%Y'), 
stocks_date = str_to_date(stock_date, '%m/%d/%Y');
	
#check count rows
SELECT COUNT(*) AS total_rows,
       COUNT(transactions_date) AS converted_rows,
	    COUNT(stocks_date) AS converted_rows2
FROM transactions_1998;

# check null values
SELECT sum(transactions_date is null) as nulls,
       sum(stocks_date is null) as nulls2
from transactions_1998;

select transactions_date, stocks_date from transactions_1998;
# drop the column
alter table transactions_1998
drop column transaction_date,
drop column stock_date;

alter table transactions_1998
modify column transactions_date date first,
modify column stocks_date date after transactions_date;

select * from transactions_1998;

#----------------------------------------------------------------------------------------
