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
