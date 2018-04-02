--chapter 14

--1
DECLARE @TotalBalanceDue money;

SET @TotalBalanceDue = 
	(SELECT SUM(InvoiceTotal - PaymentTotal - CreditTotal)
	FROM Invoices
	WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0);

IF @TotalBalanceDue > 10000
	PRINT 'Total Balance is over 10000'
	--Do the query here for balances over $0
ELSE
	PRINT 'Total Balance Due is $' + CONVERT(varchar, @TotalBalanceDue, 1) + ', and is less than $10,000'

--2
USE AP;

DROP TABLE IF EXISTS #FirstInvoiceTable

SELECT VendorID, MIN(InvoiceDate) AS FirstInvoiceDate
INTO #FirstInvoiceTable
FROM Invoices
GROUP BY VendorID

SELECT v.VendorName, t.FirstInvoiceDate, i.InvoiceTotal
FROM Invoices i
JOIN #FirstInvoiceTable t ON t.VendorID = i.VendorID
	AND t.FirstInvoiceDate = i.InvoiceDate
JOIN Vendors v ON v.VendorID = t.VendorID
ORDER BY v.VendorName, t.FirstInvoiceDate


--3
DROP VIEW IF EXISTS FirstInvoices
GO

CREATE VIEW FirstInvoices
AS
SELECT VendorID, MIN(InvoiceDate) AS FirstInvoiceDate
FROM Invoices
GROUP BY VendorID
GO

SELECT v.VendorName, t.FirstInvoiceDate, i.InvoiceTotal
FROM Invoices i
JOIN FirstInvoices t ON t.VendorID = i.VendorID
	AND t.FirstInvoiceDate = i.InvoiceDate
JOIN Vendors v ON v.VendorID = t.VendorID
ORDER BY v.VendorName, t.FirstInvoiceDate

--4
DECLARE @TableName varchar(128);

SELECT @TableName = MIN(name)
FROM sys.tables
WHERE name <> 'dtproperties' AND name <> 'sysdiagrams';

EXEC ('SELECT COUNT(*) AS CountOf' + @TableName + ' FROM ' + @TableName + ';');