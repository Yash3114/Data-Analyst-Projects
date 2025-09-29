-- Data Cleaning

SELECT * 
FROM new_data;

-- Create a clean copy of your data
CREATE TABLE clean_data AS
SELECT * 
FROM new_data;

-- Renaming the column name to InvoiceNo
ALTER TABLE clean_data
CHANGE COLUMN ï»¿InvoiceNo InvoiceNo VARCHAR(255);

-- Remove rows with missing CustomerID
SELECT *
FROM clean_data
WHERE CustomerID IS NULL OR CustomerID = '';

SELECT TRIM(CustomerID)
FROM clean_data;

DELETE 
FROM clean_data
WHERE CustomerID IS NULL OR TRIM(CustomerID) = '';

-- Remove rows where Quantity <= 0
SELECT *
FROM clean_data
WHERE Quantity <= 0;

DELETE 
FROM clean_data
WHERE Quantity <= 0;

-- Remove rows where UnitPrice <= 0
SELECT *
FROM clean_data
WHERE UnitPrice <= 0;

DELETE 
FROM clean_data
WHERE UnitPrice <= 0;

-- OPTIONAL: Remove rows where InvoiceNo starts with 'C' 
SELECT *
FROM clean_data
WHERE InvoiceNo LIKE 'C%';

DELETE 
FROM clean_data
WHERE InvoiceNo LIKE 'C%';

-- Total rows after cleaning
SELECT COUNT(*) 
FROM clean_data;

-- Any negative prices left?
SELECT * 
FROM clean_data 
WHERE UnitPrice < 0;

-- Any negative quantities?
SELECT * 
FROM clean_data 
WHERE Quantity < 0;

-- Any null or blank CustomerID?
SELECT * 
FROM clean_data 
WHERE CustomerID IS NULL OR TRIM(CustomerID) = '';

-- Removing duplicate rows
SELECT InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country, COUNT(*) AS dup_count
FROM clean_data
GROUP BY ï»¿InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
HAVING dup_count > 1
ORDER BY dup_count DESC;

CREATE TABLE new_clean_data
SELECT DISTINCT *
FROM clean_data;

DROP TABLE clean_data;

RENAME TABLE new_clean_data TO clean_data;

SELECT COUNT(*)
FROM clean_data;

SELECT *
FROM clean_data;


-- Exploration

SELECT MIN(Quantity)
FROM clean_data;

SELECT MAX(Quantity)
FROM clean_data;

SELECT MIN(InvoiceDate)
FROM clean_data;

SELECT MAX(InvoiceDate)
FROM clean_data;

SELECT Description, Quantity
FROM clean_data
WHERE Description lIKE 'WORLD WAR 2 GLIDERS ASSTD DESIGNS'
ORDER BY Quantity DESC;

SELECT InvoiceNo, AVG(Quantity) AS AvgQuantityPerInvoice
FROM clean_data
GROUP BY InvoiceNo
ORDER BY AVG(Quantity) DESC;

SELECT Quantity, COUNT(*) AS FrequentlyOrderedQuantity
FROM clean_data
GROUP BY Quantity
ORDER BY FrequentlyOrderedQuantity DESC;

SELECT StockCode, Description, SUM(Quantity) AS total_quantity_sold
FROM clean_data
GROUP BY StockCode, Description
ORDER BY total_quantity_sold DESC
LIMIT 10;

SELECT StockCode, Description, SUM(Quantity * UnitPrice) AS total_revenue
FROM clean_data
GROUP BY StockCode, Description
ORDER BY total_revenue DESC
LIMIT 10;

SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS month, ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM clean_data
GROUP BY month
ORDER BY Revenue DESC;

SELECT DATE_FORMAT(InvoiceDate, '%Y-%m') AS month, COUNT(DISTINCT InvoiceNo) AS total_orders
FROM clean_data
GROUP BY month
ORDER BY month;



-- Analysis and insight genaration

SELECT DISTINCT StockCode, Description, CustomerID, ROUND(SUM(Quantity*UnitPrice), 2) AS Revenue
FROM clean_data
GROUP BY StockCode, Description, CustomerID
ORDER BY Revenue DESC
LIMIT 10;

SELECT DISTINCT StockCode, Description, ROUND(SUM(Quantity*UnitPrice), 2) AS Revenue
FROM clean_data
GROUP BY StockCode, Description
ORDER BY Revenue DESC
LIMIT 10;

SELECT DISTINCT Country, ROUND(SUM(Quantity*UnitPrice), 2) AS Revenue
FROM clean_data
GROUP BY Country
ORDER BY Revenue DESC
LIMIT 10;

SELECT Month, ROUND(AVG(monthly_total), 2) AS AvgOrderValue
FROM (
  SELECT InvoiceNo, DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month, SUM(Quantity * UnitPrice) AS monthly_total
  FROM clean_data
  GROUP BY InvoiceNo, DATE_FORMAT(InvoiceDate, '%Y-%m')
) AS sub
GROUP BY Month
ORDER BY Month;

SELECT CustomerID, COUNT(DISTINCT InvoiceNo) AS NumOrders
FROM clean_data
GROUP BY CustomerID
ORDER BY NumOrders DESC
LIMIT 10;

SELECT DAYNAME(InvoiceDate) AS Weekday, ROUND(SUM(Quantity * UnitPrice), 2) AS Revenue
FROM clean_data
GROUP BY Weekday
ORDER BY FIELD(Weekday, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');


SELECT *
FROM clean_data;