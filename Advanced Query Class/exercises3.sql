--Chapter 15
--1
CREATE PROC dbo.spBalanceRange
    @VendorVar varchar(50) = '%',
    @BalanceMin money = 0,  
	@BalanceMax money = 0
AS
    SELECT v.VendorName,
		i.InvoiceTotal,
		i.InvoiceTotal - i.PaymentTotal - i.CreditTotal AS Balance
	FROM Invoices i JOIN Vendors v
		ON i.VendorID = v.VendorID
	WHERE v.VendorName LIKE @VendorVar
		AND (i.InvoiceTotal - i.PaymentTotal - i.CreditTotal ) > 0
		AND (((i.InvoiceTotal - i.PaymentTotal - i.CreditTotal) BETWEEN @BalanceMin AND @BalanceMax) OR (@BalanceMax = 0))
	ORDER BY Balance DESC

--2
    --a
    EXEC	[dbo].[spBalanceRange]
		@VendorVar = 'M%'
    --b
    EXEC	[dbo].[spBalanceRange]
		@BalanceMin = 200,
		@BalanceMax = 1000
    --c
    EXEC	[dbo].[spBalanceRange]
		@VendorVar = '[C,F]%', @BalanceMax = 200

--3
ALTER PROCEDURE dbo.spDateRange 
    @DateMin varchar(MAX) = NULL,
    @DateMax varchar(MAX) = NULL  
AS
    IF @DateMin IS NULL
		THROW 50001, 'Minimum Date is required.', 1
	IF @DateMax IS NULL
		THROW 50001, 'Maximum Date is required.', 1
	IF (ISDATE(@DateMin) <> 1)
		THROW 50001, 'Invalid minimum date.', 1
	IF (ISDATE(@DateMax) <> 1)
		THROW 50001, 'Invalid maximum date.', 1
	IF(CAST(@DateMin AS datetime) > CAST(@DateMax AS datetime))
		THROW 50001, 'Minimum date cannot be later than maximum date.', 1;
	SELECT
		InvoiceNumber, InvoiceDate, InvoiceTotal, InvoiceTotal - PaymentTotal - CreditTotal AS Balance
	FROM Invoices
	WHERE InvoiceDate BETWEEN @DateMin AND @DateMax
		AND InvoiceTotal - PaymentTotal - CreditTotal > 0
	ORDER BY InvoiceDate

--4
BEGIN TRY
EXEC	[dbo].[spDateRange]
		@DateMin = '2015-10-12',
		@DateMax = '2015-12-20'
END TRY
BEGIN CATCH
	PRINT CONVERT(varchar, ERROR_NUMBER()) + ': ' + CONVERT(varchar, ERROR_MESSAGE())
END CATCH
GO

--5
ALTER FUNCTION [dbo].[fnUnpaidInvoiceID]()
RETURNS INT
AS
BEGIN
	RETURN (SELECT TOP 1 InvoiceID
		FROM Invoices
		WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
		ORDER BY InvoiceDate DESC);
END

SELECT VendorName, 
	   InvoiceNumber,
	   InvoiceDueDate,
	   InvoiceTotal - PaymentTotal - CreditTotal as Balance
from Vendors 
	JOIN Invoices ON Vendors.VendorId = Invoices.VendorID 
Where InvoiceId = [dbo].[fnUnpaidInvoiceID]();

--6
ALTER FUNCTION [dbo].[fnDateRange]
(
    @DateMin smalldatetime,
    @DateMax smalldatetime
)
RETURNS TABLE AS RETURN
(
    SELECT InvoiceNumber,
	   InvoiceDate,
	   InvoiceTotal - PaymentTotal - CreditTotal as Balance
	   FROM Invoices
	   WHERE InvoiceDate BETWEEN @DateMin AND @DateMax
)

--8
SELECT * FROM [dbo].[fnDateRange] ('2016-03-15', '2016-03-20')

Create Trigger Invoices_Update_Shipping
    on Invoices,
    After Insert, update
AS
    Insert ShippingLabels
    Select VendorName, etc
    FROM Vendors JOIN Inserted I
    On Vendors.VendorID = I.VendorID
    WHERE I.InvoiceTotal  - I.PaymentTotal - I.CreditTotal = 0;

--9
CREATE TABLE TestUniqueNulls
(RowID int IDENTITY NOT NULL, NoDupName varchar(20) NULL);
