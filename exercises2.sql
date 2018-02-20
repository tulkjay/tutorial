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

--5
SELECT VendorName, Invoices.InvoiceID, InvoiceSequence, InvoiceLineItemAmount
FROM Vendors JOIN Invoices 
  ON Vendors.VendorID = Invoices.VendorID
JOIN InvoiceLineItems
  ON Invoices.InvoiceID = InvoiceLineItems.InvoiceID
WHERE Invoices.InvoiceID IN
      (SELECT InvoiceID
       FROM InvoiceLineItems
       WHERE InvoiceSequence > 1)
ORDER BY VendorName, Invoices.InvoiceID, InvoiceSequence;

--6
SELECT SUM(InvoiceMax) AS SumOfMaximums
FROM (SELECT VendorID, MAX(InvoiceTotal) AS InvoiceMax
      FROM Invoices
      WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0
      GROUP BY VendorID) AS MaxInvoice;

--7
SELECT VendorName, VendorCity, VendorState
FROM Vendors
WHERE VendorState + VendorCity NOT IN 
	(SELECT VendorState + VendorCity
	FROM Vendors
	GROUP BY VendorState + VendorCity
	HAVING COUNT(*) > 1)
ORDER BY VendorState, VendorCity;

--8
SELECT VendorName, InvoiceNumber AS FirstInv,
       InvoiceDate, InvoiceTotal
FROM Invoices AS I_Main JOIN Vendors
  ON I_Main.VendorID = Vendors.VendorID
WHERE InvoiceDate =
  (SELECT MIN(InvoiceDate)
   FROM Invoices AS I_Sub
   WHERE I_Sub.VendorID = I_Main.VendorID)
ORDER BY VendorName;

--9
WITH MaxInvoice AS
(
    SELECT VendorID, MAX(InvoiceTotal) AS InvoiceMax
    FROM Invoices
    WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0
    GROUP BY VendorID
)
SELECT SUM(InvoiceMax) AS SumOfMaximums
FROM MaxInvoice;

--Chapter 7
--1
DROP TABLE VendorCopy
SELECT * INTO VendorCopy
FROM Vendors

DROP TABLE InvoiceCopy
SELECT * INTO InvoiceCopy
FROM Invoices

--2
INSERT INTO InvoiceCopy (VendorID, InvoiceTotal, TermsID, InvoiceNumber, PaymentTotal, InvoiceDueDate, InvoiceDate, CreditTotal, PaymentDate)
VALUES (32, 434.58, 2, 'AX-014-027', 0.00, '07/8/2016', '06/21/2016', 0.00, NULL)

--3
BEGIN TRAN
INSERT INTO VendorCopy
SELECT [VendorName], [VendorAddress1], [VendorAddress2], [VendorCity], [VendorState], [VendorZipCode], [VendorPhone], [VendorContactLName], [VendorContactFName], [DefaultTermsID], [DefaultAccountNo] FROM Vendors
WHERE VendorState <> 'CA'
ROLLBACK TRAN

--4
UPDATE VendorCopy
SET DefaultAccountNo = 403
WHERE DefaultAccountNo = 400

--5
UPDATE InvoiceCopy
SET PaymentDate = GETDATE(),
PaymentTotal = InvoiceTotal - PaymentTotal + CreditTotal
WHERE InvoiceTotal - PaymentTotal + CreditTotal > 0

--6
UPDATE InvoiceCopy
SET TermsID = 2
WHERE InvoiceCopy.VendorID IN (
	SELECT VendorCopy.VendorID FROM VendorCopy
	WHERE VendorCopy.DefaultTermsID = 2
)

--7
UPDATE InvoiceCopy
SET TermsID = 2
FROM InvoiceCopy i JOIN VendorCopy v
ON i.VendorID = v.VendorID
WHERE v.DefaultTermsID = 2