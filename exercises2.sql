--Chapter 6
--1
SELECT DISTINCT VendorName
FROM Vendors
WHERE VendorID IN (SELECT VendorID FROM Invoices)
ORDER BY VendorName

--2
SELECT InvoiceNumber, InvoiceTotal
FROM Invoices
WHERE PaymentTotal > (SELECT AVG(PaymentTotal) FROM Invoices)

--3
SELECT InvoiceNumber, InvoiceTotal
FROM Invoices
WHERE PaymentTotal > ALL
	(SELECT TOP 50 PERCENT PaymentTotal FROM Invoices
		WHERE PaymentTotal <> 0
		ORDER BY PaymentTotal)

--4
SELECT AccountNo, AccountDescription
FROM GLAccounts ga
WHERE NOT EXISTS
 (SELECT *
 FROM InvoiceLineItems li
 WHERE ga.AccountNo = li.AccountNo
 );

--5
SELECT VendorName
FROM Vendors v
JOIN Invoices i  ON v.VendorID = i.VendorID
WHERE i.InvoiceID  IN (
	SELECT li.InvoiceID
	FROM InvoiceLineItems LI
	WHERE InvoiceSequence > 1
)

