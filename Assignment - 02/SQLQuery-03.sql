--3. Procedure to Get Order Details
CREATE PROCEDURE GetOrderDetails
    @SalesOrderID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID)
    BEGIN
        PRINT 'The OrderID ' + CAST(@SalesOrderID AS VARCHAR) + ' does not exist.';
        RETURN 1;
    END

    SELECT *
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @SalesOrderID;
END;

