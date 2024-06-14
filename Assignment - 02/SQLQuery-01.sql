--1. Procedure to Insert Order Details
CREATE PROCEDURE InsertOrderDetails
    @SalesOrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(18, 2) = NULL,
    @OrderQty INT,
    @Discount DECIMAL(5, 2) = 0
AS
BEGIN
    DECLARE @ActualUnitPrice DECIMAL(18, 2)
    DECLARE @UnitsInStock INT
    DECLARE @ReorderLevel INT

    -- Get the product's UnitPrice from the Product table if not provided
    SELECT @ActualUnitPrice = ISNULL(@UnitPrice, StandardCost), @UnitsInStock = Quantity, @ReorderLevel = SafetyStockLevel
    FROM Production.ProductInventory
    WHERE ProductID = @ProductID;

    -- Check if there is enough stock
    IF @UnitsInStock < @OrderQty
    BEGIN
        PRINT 'Insufficient stock to fulfill the order.';
        RETURN;
    END

    -- Insert order details
    INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, UnitPrice, OrderQty, LineTotal, UnitPriceDiscount)
    VALUES (@SalesOrderID, @ProductID, @ActualUnitPrice, @OrderQty, @OrderQty * @ActualUnitPrice * (1 - @Discount), @Discount);

    -- Check if the insertion was successful
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.';
        RETURN;
    END

    -- Adjust the stock
    UPDATE Production.ProductInventory
    SET Quantity = Quantity - @OrderQty
    WHERE ProductID = @ProductID;

    -- Check if the quantity in stock drops below the reorder level
    IF @UnitsInStock - @OrderQty < @ReorderLevel
    BEGIN
        PRINT 'The quantity in stock for the product has dropped below its reorder level.';
    END
END;
