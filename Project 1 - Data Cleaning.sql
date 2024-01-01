/*

Cleaning Data in SQL queries.
The store we're working with is hosting a giveaway for customers in certain cities.
We have a database containing customer information that we can use to narrow down which customers are eligible for the giveaway.

*/

use PortfolioProject;

Select *
From customer_data;
----------------------------------------------------------------------------------------------
INSERT INTO PortfolioProject..customer_data
   (CustomerID, CustomerName, Country, City, State, PostalCode)

VALUES 
   (13045,	'Darrin Van Huff',	'US', 'Los Angeles',	'California',	90036)

Select *
From customer_data;
------------------------------------------------------------------------------------------------
--Change the name of a customer

Select *
From customer_data;

Update customer_data
Set CustomerName = 'Sung Pak'
Where CustomerID = 15070

Select CustomerID, CustomerName
From customer_data
------------------------------------------------------------------------------------------------
--We want a list of unique customer id

Select DISTINCT CustomerID
From customer_data;
-------------------------------------------------------------------------------------------------
--Remove Duplicates

Select *
From customer_data;

WITH RowNumCTE AS(
Select * , 
   ROW_NUMBER() OVER (
   PARTITION BY CustomerID,
                CustomerName,
				Country,
				City,
				State,
				PostalCode
				ORDER BY
				  CustomerID
				  ) row_num
From customer_data
)
Select * 
From RowNumCTE
Where row_num > 1

Select *
From customer_data
----------------------------------------------------------------------------------------------------
--Let's say we're working with the customer data. We can make sure that all country codes have the same length
--by using LENGTH on each of these strings.

SELECT 
   LEN(Country) AS letters_in_country
FROM customer_data

--Show only customers whose country contains more than two letters

Select Country
From customer_data
Where LEN(Country) > 2 


Select CustomerID , Country

From customer_data

Where SUBSTRING(Country,1,2) = 'US'
----------------------------------------------------------------------------------------------------
--Update table so that this entry shows up as US instead of USA.

Update customer_data
Set Country = 'US'
Where Country = 'USA' 

Select Country
From customer_data;
----------------------------------------------------------------------------------------------------
--Figure out what the incorrectly listed states look like, if we have any.

Select State
From customer_data
Where State = 'OHIO'

Select State, LTRIM(State) AS StateUpdated
From customer_data;

Alter Table customer_data
Add StateUpdated nvarchar(255) ;

Update customer_data
Set StateUpdated = LTRIM(State) 

Select *
From customer_data;
-------------------------------------------------------------------------------------------------