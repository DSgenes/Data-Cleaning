/*

Cleaning Data in SQL Queries

*/

Select *
From customer_purchase
--------------------------------------------------------------------------------
--Standardize Date Format

Select date , CAST(date AS date) AS date_only
From customer_purchase

Alter Table customer_purchase
Add date_only date;

Update customer_purchase
SET date_only = CAST(date AS date)

Select *
From customer_purchase;
----------------------------------------------------------------------------------
--The furniture store owner has asked us to look at purchases that occurred during their sales promotion period in December.

Select date_only, purchase_price

From customer_purchase;

Where date BETWEEN '2020-12-01' AND '2020-12-31'
----------------------------------------------------------------------------------
--We see that the furniture store sells different colors of the same product.The owner wants to know if the customer prefers 
--certain colors so the owner can manage store inventory accordingly.The problem is the product_code is the same regardless
--of the product color.We need to find another way to separate products by color so we can tell if customers prefer one color
--over the others.So we'll use CONCAT to produce a unique key that will help us tell the products apart by color and count them more easily.

Select CONCAT(product_code, product_color) AS new_product_code
From customer_purchase

Where product = 'couch'

Select *
From customer_purchase;
-----------------------------------------------------------------------------------
--Let's say we wanted a list of all products that were sold.We want to use the product coloumn to understand what kind of product
--was sold.But if names aren't available, then give us the product code.

Select COALESCE(product, product_code) AS product_info
From customer_purchase;

Alter Table customer_purchase
Add product_info nvarchar(255) ;

Update customer_purchase
Set product_info = COALESCE(product, product_code)

Select *
From customer_purchase;
---------------------------------------------------------------------------------
--Delete Unused Coloumns

Select *
From customer_purchase;

Alter Table customer_purchase
Drop Column date, product
---------------------------------------------------------------------------------
