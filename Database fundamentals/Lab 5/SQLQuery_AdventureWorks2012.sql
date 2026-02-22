USE AdventureWorks2012

--1.	Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales schema) to show SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
SELECT SalesOrderID,ShipDate 
from sales.SalesOrderHeader
Where OrderDate between '7/28/2002' and '7/29/2014'

--2.	Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select ProductID,Name 
from Production.Product
where StandardCost < 110

--3.	Display ProductID, Name if its weight is unknown
select ProductID,Name 
from Production.Product
where Weight is null

--4.	 Display all Products with a Silver, Black, or Red Color
select Name,color
from Production.Product
where Color in ('silver','black','red')

--5.	 Display any Product with a Name starting with the letter B
select name 
from Production.Product
Where name like 'B%'

/*6.	Run the following Query
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3
Then write a query that displays any Product description with underscore value in its description.*/
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

Select Description from Production.ProductDescription
WHERE Description like '%[_]%'

--7.	Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table for the period between  '7/1/2001' and '7/31/2014'
SELECT OrderDate,SUM(TotalDue) as 'Total due sum' FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '7/1/2001' and '7/31/2014'
GROUP BY OrderDate

--8.	 Display the Employees HireDate (note no repeated values are allowed)
SELECT DISTINCT HireDate
FROM HumanResources.Employee

--9.	 Calculate the average of the unique ListPrices in the Product table
SELECT AVG(DISTINCT ListPrice)
FROM Production.Product

/*10.	Display the Product Name and its ListPrice within the values of 100 and 120 the list should has the following 
format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)*/
SELECT 'The ' + Name + ' is only! ' + CAST(ListPrice AS VARCHAR(10)) AS ProductInfo
FROM Production.Product
WHERE ListPrice BETWEEN 100 AND 120
ORDER BY Listprice

/*11.	

a)	 Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table  in a newly created table named [store_Archive]
Note: Check your database to see the new table and how many rows in it?
b)	Try the previous query but without transferring the data? */
--data +structure
SELECT rowguid ,Name, SalesPersonID, Demographics into store_Archive
from Sales.Store

SELECT * FROM store_Archive

--structure only
SELECT rowguid, Name, SalesPersonID, Demographics
INTO store_Archive1
FROM Sales.Store
WHERE 1 = 0;

--12.	Using union statement, retrieve the today’s date in different styles using convert or format funtion.

SELECT FORMAT(GETDATE(), 'dd/MM/yyyy') AS TodayDate
UNION
SELECT FORMAT(GETDATE(), 'MM-dd-yyyy')
UNION
SELECT FORMAT(GETDATE(), 'yyyy/MM/dd')
UNION
SELECT FORMAT(GETDATE(), 'dddd, MMMM dd, yyyy');

