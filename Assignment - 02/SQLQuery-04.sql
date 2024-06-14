--4. Procedure to Delete Order Details
CREATE PROCEDURE DeleteOrderDetails
    @SalesOrderID INT,
    @ProductID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID AND ProductID = @ProductID)
    BEGIN
        PRINT 'Invalid parameters. OrderID or ProductID does not exist.';
        RETURN -1;
    END

    DELETE FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @SalesOrderID AND ProductID = @ProductID;
END;
