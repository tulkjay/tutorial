--Chapter 3
/****** Script for SelectTopNRows command from SSMS  ******/
--1
SELECT [VendorName]
      ,[VendorContactLName]
      ,[VendorContactFName]
FROM [AP].[dbo].[Vendors]
ORDER BY [VendorContactLName], [VendorContactFName]

--2
SELECT [InvoiceNumber] AS Number
      ,[InvoiceTotal] AS Total
      ,[PaymentTotal] + [CreditTotal] AS Credits,
      [InvoiceTotal] - [PaymentTotal] + [CreditTotal] AS Balance
FROM [AP].[dbo].[Invoices]

--3
--Better to use CONCAT() or ISNULL()
SELECT [VendorContactLName] + ', ' + [VendorContactFName] AS 'Full Name'
FROM [AP].[dbo].[Vendors]
ORDER BY [VendorContactLName], [VendorContactFName]

--4
SELECT [InvoiceTotal],
	[InvoiceTotal] / 10 AS '10%',
	[InvoiceTotal] * 1.1 AS 'Plus 10%'
FROM [AP].[dbo].[Invoices]
WHERE [InvoiceTotal] - [PaymentTotal] - [CreditTotal] > 1000
ORDER BY [InvoiceTotal] DESC

--5
SELECT [InvoiceNumber] AS Number
      ,[InvoiceTotal] AS Total
      ,[PaymentTotal] + [CreditTotal] AS Credits,
      [InvoiceTotal] - [PaymentTotal] + [CreditTotal] AS Balance
FROM [AP].[dbo].[Invoices]
WHERE [InvoiceTotal] >= 500 AND [InvoiceTotal] <= 10000
--Alternative: WHERE [InvoiceTotal] BETWEEN 500 AND 10000

--6
SELECT [VendorContactLName] + ', ' + [VendorContactFName] AS 'Full Name'
FROM [AP].[dbo].[Vendors]
WHERE [VendorContactLName] LIKE '[ABCE]%'
ORDER BY [VendorContactLName], [VendorContactFName]
--Alternative: '[A-C, E]' or using NOT LIKE
-- OR LEFT(1) IN ('A', 'B', 'C', 'E') A little faster

--7
SELECT [InvoiceNumber] AS 'Valid Invoice Number'
      ,[InvoiceTotal] AS Total
      ,[PaymentTotal] + [CreditTotal] AS Credits,
      [InvoiceTotal] - [PaymentTotal] + [CreditTotal] AS Balance,
	  [PaymentDate]
FROM [AP].[dbo].[Invoices]
WHERE ([InvoiceTotal] - [PaymentTotal] + [CreditTotal] <= 0.00 AND PaymentDate IS NULL)
	OR
	([InvoiceTotal] - [PaymentTotal] + [CreditTotal] > 0.00 AND PaymentDate IS NOT NULL)
ORDER BY PaymentDate

--Chapter 4
--1
SELECT * from Vendors JOIN Invoices ON Vendors.VendorID = Invoices.VendorID

--2
SELECT DISTINCT
v.VendorName,
i.InvoiceNumber,
i.InvoiceDate,
i.InvoiceTotal - i.PaymentTotal + i.CreditTotal AS Balance
FROM Vendors v JOIN Invoices i ON v.VendorID = i.VendorID
WHERE i.InvoiceTotal - i.PaymentTotal + i.CreditTotal > 0
ORDER BY v.VendorName

--3
SELECT
v.VendorName,
v.DefaultAccountNo,
ga.AccountDescription
FROM Vendors v 
JOIN GLAccounts ga ON v.DefaultAccountNo = ga.AccountNo
ORDER BY ga.AccountDescription, v.VendorName

--4
--skip

--5
SELECT 
v.VendorName AS Vendor,
i.InvoiceDate AS 'Date',
i.InvoiceNumber AS Number,
li.InvoiceSequence AS '#',
li.InvoiceLineItemAmount AS LineItem
FROM Vendors v
	JOIN Invoices i ON v.VendorID = i.VendorID
	JOIN InvoiceLineItems li ON i.InvoiceID = li.InvoiceID
ORDER BY v.VendorName, i.InvoiceDate, i.InvoiceNumber, li.InvoiceSequence

--6
SELECT v1.VendorName,
	v1.VendorID,
	CONCAT(v1.VendorContactFName, ' ', v1.VendorContactLName) AS 'Name'
FROM Vendors v1 JOIN Vendors v2
ON v1.VendorContactFName = v2.VendorContactFName AND v1.VendorID <> v2.VendorID
ORDER BY Name

--7
SELECT ga.AccountNo, ga.AccountDescription
FROM GLAccounts ga
LEFT JOIN InvoiceLineItems li ON ga.AccountNo = li.AccountNo
WHERE li.AccountNo IS NULL
ORDER BY ga.AccountNo

--8
	SELECT VendorName, VendorState 
	FROM Vendors 
	WHERE VendorState = 'CA'
UNION
	SELECT VendorName, 'Outside CA' AS VendorState 
	FROM Vendors 
	WHERE VendorState <> 'CA'
ORDER BY VendorName
