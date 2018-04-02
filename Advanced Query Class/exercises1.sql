--1
CREATE VIEW InvoiceBasic
AS
SELECT v.VendorName, i.InvoiceNumber, i.InvoiceTotal
FROM Vendors v
JOIN Invoices i on v.VendorID = i.VendorID


SELECT VendorName, InvoiceNumber, InvoiceTotal
FROM InvoiceBasic
WHERE VendorName LIKE '[N-P]%'
-- Or WHERE LEFT(VendorName, 1) IN('N', 'O', 'P')
-- Or WHERE SUBSTRING(VendorName, 1, 1) IN('N', 'O', 'P')
ORDER By VendorName

--2
CREATE VIEW Top10PaidInvoices
AS
SELECT TOP 10 
	v.VendorName,
	MAX(i.InvoiceDate) AS LastInvoice,
	SUM(i.InvoiceTotal) AS SumOfInvoices
FROM Vendors v
JOIN Invoices i ON v.VendorID = i.VendorID
GROUP BY v.VendorName

--3
CREATE VIEW VendorAddress
AS
SELECT VendorID AS Id, VendorAddress1 AS Address1, VendorAddress2 AS Address2, VendorCity AS City, VendorState AS 'State', VendorZipCode AS ZipCode
FROM Vendors

SELECT * FROM VendorAddress
WHERE Id = 4
UPDATE VendorAddress
SET Address1 = '1990 Westwood Blvd',
    Address2 = 'Ste 260'
WHERE Id = 4

--4
SELECT name as Name
FROM sys.foreign_keys

SELECT * FROM sys.foreign_keys

--5
--View modified to:
SELECT        TOP (100) PERCENT v.VendorName, i.InvoiceNumber, i.InvoiceTotal
FROM            dbo.Vendors AS v INNER JOIN
                         dbo.Invoices AS i ON v.VendorID = i.VendorID
ORDER BY v.VendorName

