--3. View for Products and Suppliers
CREATE VIEW MyProducts
AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.QuantityPerUnit,
    p.UnitPrice,
    s.CompanyName,
    c.Name AS CategoryName
FROM 
    Production.Product p
JOIN 
    Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN 
    Purchasing.Vendor s ON pv.BusinessEntityID = s.BusinessEntityID
JOIN 
    Production.ProductCategory c ON p.ProductCategoryID = c.ProductCategoryID
WHERE 
    p.Discontinued = 0;
