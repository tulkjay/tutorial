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
SELECT [VendorContactLName] + ', ' + [VendorContactFName] AS 'Full Name'
FROM [AP].[dbo].[Vendors]
ORDER BY [VendorContactLName], [VendorContactFName]

--4
SELECT [InvoiceTotal],
	[InvoiceTotal] / 10 AS '10%',
	[InvoiceTotal] * 1.1 AS 'Plus 10%'
FROM [AP].[dbo].[Invoices]
ORDER BY [InvoiceTotal] DESC

--5
SELECT [InvoiceNumber] AS Number
      ,[InvoiceTotal] AS Total
      ,[PaymentTotal] + [CreditTotal] AS Credits,
      [InvoiceTotal] - [PaymentTotal] + [CreditTotal] AS Balance
FROM [AP].[dbo].[Invoices]
WHERE [InvoiceTotal] >= 500 AND [InvoiceTotal] <= 10000

--6
SELECT [VendorContactLName] + ', ' + [VendorContactFName] AS 'Full Name'
FROM [AP].[dbo].[Vendors]
WHERE [VendorContactLName] LIKE '[ABCE]%'
ORDER BY [VendorContactLName], [VendorContactFName]

--7
SELECT [InvoiceNumber] AS 'Valid Invoice Number'
      ,[InvoiceTotal] AS Total
      ,[PaymentTotal] + [CreditTotal] AS Credits,
      [InvoiceTotal] - [PaymentTotal] + [CreditTotal] AS Balance,
	  [PaymentDate]
FROM [AP].[dbo].[Invoices]
WHERE ([InvoiceTotal] - [PaymentTotal] + [CreditTotal] <> 0.00 and PaymentDate IS NULL)
	OR
	([InvoiceTotal] - [PaymentTotal] + [CreditTotal] = 0.00 and PaymentDate IS NOT NULL)
ORDER BY PaymentDate