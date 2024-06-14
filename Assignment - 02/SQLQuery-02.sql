--2. Procedure to Update Order Details
CREATE PROCEDURE UpdateOrderDetails
    @SalesOrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(18, 2) = NULL,
    @OrderQty INT = NULL,
    @Discount DECIMAL(5, 2) = NULL
AS
BEGIN
    DECLARE @OriginalUnitPrice DECIMAL(18, 2)
    DECLARE @OriginalOrderQty INT
    DECLARE @OriginalDiscount DECIMAL(5, 2)
    DECLARE @UnitsInStock INT

    -- Get the original values and the current stock
    SELECT @OriginalUnitPrice = UnitPrice, @OriginalOrderQty = OrderQty, @OriginalDiscount = UnitPriceDiscount
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @SalesOrderID AND ProductID = @ProductID;

    SELECT @UnitsInStock = Quantity
    FROM Production.ProductInventory
    WHERE ProductID = @ProductID;

    -- Update order details
    UPDATE Sales.SalesOrderDetail
    SET 
        UnitPrice = ISNULL(@UnitPrice, @OriginalUnitPrice),
        OrderQty = ISNULL(@OrderQty, @OriginalOrderQty),
        UnitPriceDiscount = ISNULL(@Discount, @OriginalDiscount),
        LineTotal = ISNULL(@OrderQty, @OriginalOrderQty) * ISNULL(@UnitPrice, @OriginalUnitPrice) * (1 - ISNULL(@Discount, @OriginalDiscount))
    WHERE SalesOrderID = @SalesOrderID AND ProductID = @ProductID;

    -- Adjust the stock
    IF @OrderQty IS NOT NULL
    BEGIN
        UPDATE Production.ProductInventory
        SET Quantity = Quantity + @OriginalOrderQty - @OrderQty
        WHERE ProductID = @ProductID;
    END
END;

