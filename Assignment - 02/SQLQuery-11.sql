--2. Trigger to Ensure Sufficient Stock on Order Details
CREATE TRIGGER CheckStockBeforeInsertOrderDetails
ON Sales.SalesOrderDetail
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @ProductID INT;
    DECLARE @OrderQty INT;
    DECLARE @UnitsInStock INT;

    SELECT @ProductID = i.ProductID, @OrderQty = i.OrderQty
    FROM inserted i;

    SELECT @UnitsInStock = Quantity
    FROM Production.ProductInventory
    WHERE ProductID = @ProductID;

    IF @UnitsInStock >= @OrderQty
    BEGIN
        INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, UnitPrice, OrderQty, LineTotal, UnitPriceDiscount)
        SELECT SalesOrderID, ProductID, UnitPrice, OrderQty, OrderQty * UnitPrice * (1 - UnitPriceDiscount), UnitPriceDiscount
        FROM inserted;

        UPDATE Production.ProductInventory
        SET Quantity = Quantity - @OrderQty
        WHERE ProductID = @ProductID;
    END
    ELSE
    BEGIN
        PRINT 'Insufficient stock to fulfill the order.';
    END
END;
