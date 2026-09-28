SELECT 'Stores' AS TableName, COUNT(*) AS TotalRows FROM Stores
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'Sales', COUNT(*) FROM Sales
UNION ALL
SELECT 'Sales_Items', COUNT(*) FROM Sales_Items
UNION ALL
SELECT 'Inventory_Snapshots', COUNT(*) FROM Inventory_Snapshots
UNION ALL
SELECT 'Purchases', COUNT(*) FROM Purchases
UNION ALL
SELECT 'Returns', COUNT(*) FROM Returns
UNION ALL
SELECT 'Wastage', COUNT(*) FROM Wastage;

SELECT
    sale_id,
    COUNT(*) AS DuplicateCount
FROM Sales
GROUP BY sale_id
HAVING COUNT(*) > 1;

SELECT
    product_id,
    COUNT(*) AS DuplicateCount
FROM Products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT
    sale_item_id,
    COUNT(*) AS DuplicateCount
FROM Sales_Items
GROUP BY sale_item_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS InvalidStoreIDs
FROM Sales s
LEFT JOIN Stores st
    ON s.store_id = st.store_id
WHERE st.store_id IS NULL;

SELECT COUNT(*) AS InvalidProductIDs
FROM Sales_Items si
LEFT JOIN Products p
    ON si.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS InvalidSaleIDs
FROM Sales_Items si
LEFT JOIN Sales s
    ON si.sale_id = s.sale_id
WHERE s.sale_id IS NULL;

SELECT
    SUM(CASE WHEN sale_id IS NULL THEN 1 ELSE 0 END) AS MissingSaleID,
    SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END) AS MissingStoreID,
    SUM(CASE WHEN sale_datetime IS NULL THEN 1 ELSE 0 END) AS MissingDate,
    SUM(CASE WHEN net_sales_aed IS NULL THEN 1 ELSE 0 END) AS MissingRevenue
FROM Sales;

SELECT *
FROM Sales
WHERE net_sales_aed < 0;

SELECT *
FROM Sales_Items
WHERE quantity <= 0;

SELECT *
FROM Sales_Items
WHERE unit_price_aed < 0;

SELECT *
FROM Inventory_Snapshots
WHERE closing_qty < 0;

SELECT
    MIN(sale_datetime) AS FirstSale,
    MAX(sale_datetime) AS LastSale
FROM Sales;

