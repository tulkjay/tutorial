--1
DECLARE @UnitedVendorId int = 122;
DECLARE @FederalVendorId int = 123;

BEGIN TRAN
	UPDATE Vendors
	SET VendorName = 'FedUP'
	WHERE VendorID = @FederalVendorId;

	UPDATE Invoices
	SET VendorID = @FederalVendorId
	WHERE VendorID = @UnitedVendorId

	DELETE FROM Vendors
	WHERE VendorID = @UnitedVendorId;
COMMIT TRAN

--2
BEGIN TRAN;
  INSERT InvoiceArchive
  SELECT Invoices.*
  FROM Invoices LEFT JOIN InvoiceArchive
    ON Invoices.InvoiceID = InvoiceArchive.InvoiceID
  WHERE Invoices.InvoiceTotal - Invoices.CreditTotal -
          Invoices.PaymentTotal = 0 AND
        InvoiceArchive.InvoiceID IS NULL;

  DELETE Invoices
  WHERE InvoiceID IN
    (SELECT InvoiceID
     FROM InvoiceArchive);
COMMIT TRAN;