
/*
07_Inventory_Analysis.sql
UAE Retail & FMCG BI Portfolio Project
SQL Server / SSMS compatible with older SQL Server versions.

Run each section separately in SSMS and save the results.
*/

USE Uae_Analysis;
GO

/* =========================================================
   Q1. What is the current inventory position?
   ========================================================= */
SELECT
    MAX(as_of_date) AS AsOfDate,
    SUM(on_hand_qty) AS TotalOnHandQty,
    ROUND(SUM(stock_value_aed), 2) AS InventoryValueAED,
    SUM(CASE WHEN stock_status = 'Out of Stock' THEN 1 ELSE 0 END) AS OutOfStockPositions,
    SUM(CASE WHEN stock_status = 'Low Stock' THEN 1 ELSE 0 END) AS LowStockPositions,
    SUM(CASE WHEN stock_status = 'Excess Stock' THEN 1 ELSE 0 END) AS ExcessStockPositions,
    SUM(CASE WHEN stock_status = 'Healthy' THEN 1 ELSE 0 END) AS HealthyPositions
FROM dbo.Inventory;
GO


/* =========================================================
   Q2. What percentage and value of inventory is in each status?
   ========================================================= */
SELECT
    stock_status,
    COUNT(*) AS SKUStorePositions,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM dbo.Inventory), 2) AS PositionPct,
    SUM(on_hand_qty) AS OnHandQty,
    ROUND(SUM(stock_value_aed), 2) AS InventoryValueAED,
    ROUND(
        100.0 * SUM(stock_value_aed) /
        NULLIF((SELECT SUM(stock_value_aed) FROM dbo.Inventory), 0),
        2
    ) AS InventoryValuePct
FROM dbo.Inventory
GROUP BY stock_status
ORDER BY InventoryValueAED DESC;
GO


/* =========================================================
   Q3. Which stores hold the most inventory and where are
       low-stock / OOS risks concentrated?
   ========================================================= */
SELECT
    s.store_id,
    s.store_name,
    s.city,
    COUNT(*) AS SKUStorePositions,
    SUM(i.on_hand_qty) AS OnHandQty,
    ROUND(SUM(i.stock_value_aed), 2) AS InventoryValueAED,
    SUM(CASE WHEN i.stock_status = 'Out of Stock' THEN 1 ELSE 0 END) AS OOSCount,
    SUM(CASE WHEN i.stock_status = 'Low Stock' THEN 1 ELSE 0 END) AS LowStockCount,
    SUM(CASE WHEN i.stock_status = 'Excess Stock' THEN 1 ELSE 0 END) AS ExcessStockCount,
    ROUND(
        100.0 * SUM(CASE WHEN i.stock_status = 'Low Stock' THEN 1 ELSE 0 END) /
        NULLIF(COUNT(*),0), 2
    ) AS LowStockPct
FROM dbo.Inventory i
INNER JOIN dbo.Stores s
    ON i.store_id = s.store_id
GROUP BY
    s.store_id,
    s.store_name,
    s.city
ORDER BY InventoryValueAED DESC;
GO


/* =========================================================
   Q4. Which categories hold the most inventory value?
   ========================================================= */
SELECT
    c.category_name,
    COUNT(*) AS SKUStorePositions,
    SUM(i.on_hand_qty) AS OnHandQty,
    ROUND(SUM(i.stock_value_aed), 2) AS InventoryValueAED,
    SUM(CASE WHEN i.stock_status = 'Out of Stock' THEN 1 ELSE 0 END) AS OOSCount,
    SUM(CASE WHEN i.stock_status = 'Low Stock' THEN 1 ELSE 0 END) AS LowStockCount,
    SUM(CASE WHEN i.stock_status = 'Excess Stock' THEN 1 ELSE 0 END) AS ExcessStockCount,
    ROUND(
        100.0 * SUM(CASE WHEN i.stock_status = 'Low Stock' THEN 1 ELSE 0 END) /
        NULLIF(COUNT(*),0), 2
    ) AS LowStockPct
FROM dbo.Inventory i
INNER JOIN dbo.Products p
    ON i.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY InventoryValueAED DESC;
GO


/* =========================================================
   Q5. Which low-stock products should be prioritized?
   Sort high-demand low-stock positions first.
   ========================================================= */
SELECT TOP 25
    s.store_name,
    p.product_id,
    p.product_name,
    c.category_name,
    i.on_hand_qty,
    i.avg_daily_sales_qty,
    i.stock_cover_days,
    p.reorder_point,
    i.stock_value_aed
FROM dbo.Inventory i
INNER JOIN dbo.Products p
    ON i.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
INNER JOIN dbo.Stores s
    ON i.store_id = s.store_id
WHERE i.stock_status = 'Low Stock'
ORDER BY
    i.avg_daily_sales_qty DESC,
    i.stock_cover_days ASC;
GO


/* =========================================================
   Q6. Which products are currently out of stock?
   ========================================================= */
SELECT
    s.store_name,
    p.product_id,
    p.product_name,
    c.category_name,
    i.on_hand_qty,
    i.avg_daily_sales_qty,
    i.stock_cover_days,
    p.reorder_point
FROM dbo.Inventory i
INNER JOIN dbo.Products p
    ON i.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
INNER JOIN dbo.Stores s
    ON i.store_id = s.store_id
WHERE i.stock_status = 'Out of Stock'
ORDER BY
    i.avg_daily_sales_qty DESC,
    s.store_name,
    p.product_name;
GO


/* =========================================================
   Q7. Which products are classified as excess stock?
   ========================================================= */
SELECT
    s.store_name,
    p.product_id,
    p.product_name,
    c.category_name,
    i.on_hand_qty,
    i.avg_daily_sales_qty,
    i.stock_cover_days,
    ROUND(i.stock_value_aed,2) AS StockValueAED
FROM dbo.Inventory i
INNER JOIN dbo.Products p
    ON i.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
INNER JOIN dbo.Stores s
    ON i.store_id = s.store_id
WHERE i.stock_status = 'Excess Stock'
ORDER BY
    i.stock_value_aed DESC;
GO


/* =========================================================
   Q8. How has total inventory value changed month by month?
   ========================================================= */
SELECT
    snapshot_date,
    SUM(closing_qty) AS ClosingQty,
    ROUND(SUM(stock_value_aed),2) AS InventoryValueAED
FROM dbo.Inventory_Snapshots
GROUP BY snapshot_date
ORDER BY snapshot_date;
GO


/* =========================================================
   Q9. What is overall inventory turnover and estimated
       days inventory outstanding?
   Inventory Turnover = Annual COGS / Average Monthly Inventory
   Days Inventory = Average Monthly Inventory / Annual COGS * 365
   ========================================================= */
WITH MonthlyInventory AS
(
    SELECT
        snapshot_date,
        SUM(stock_value_aed) AS InventoryValue
    FROM dbo.Inventory_Snapshots
    GROUP BY snapshot_date
),
AverageInventory AS
(
    SELECT AVG(InventoryValue) AS AvgInventoryValue
    FROM MonthlyInventory
),
AnnualCOGS AS
(
    SELECT SUM(cogs_aed) AS TotalCOGS
    FROM dbo.Sales_Items
)
SELECT
    ROUND(c.TotalCOGS,2) AS AnnualCOGS,
    ROUND(a.AvgInventoryValue,2) AS AverageInventoryValue,
    ROUND(c.TotalCOGS / NULLIF(a.AvgInventoryValue,0),2) AS InventoryTurnover,
    ROUND((a.AvgInventoryValue / NULLIF(c.TotalCOGS,0)) * 365.0,2) AS DaysInventory
FROM AnnualCOGS c
CROSS JOIN AverageInventory a;
GO


/* =========================================================
   Q10. Which stores have the strongest / weakest inventory turnover?
   ========================================================= */
WITH MonthlyStoreInventory AS
(
    SELECT
        store_id,
        snapshot_date,
        SUM(stock_value_aed) AS InventoryValue
    FROM dbo.Inventory_Snapshots
    GROUP BY store_id, snapshot_date
),
AverageStoreInventory AS
(
    SELECT
        store_id,
        AVG(InventoryValue) AS AvgInventoryValue
    FROM MonthlyStoreInventory
    GROUP BY store_id
),
StoreCOGS AS
(
    SELECT
        s.store_id,
        SUM(si.cogs_aed) AS TotalCOGS
    FROM dbo.Sales_Items si
    INNER JOIN dbo.Sales s
        ON si.sale_id = s.sale_id
    GROUP BY s.store_id
)
SELECT
    st.store_name,
    ROUND(c.TotalCOGS,2) AS AnnualCOGS,
    ROUND(a.AvgInventoryValue,2) AS AverageInventoryValue,
    ROUND(c.TotalCOGS / NULLIF(a.AvgInventoryValue,0),3) AS InventoryTurnover,
    ROUND((a.AvgInventoryValue / NULLIF(c.TotalCOGS,0)) * 365.0,1) AS DaysInventory
FROM StoreCOGS c
INNER JOIN AverageStoreInventory a
    ON c.store_id = a.store_id
INNER JOIN dbo.Stores st
    ON c.store_id = st.store_id
ORDER BY InventoryTurnover DESC;
GO


/* =========================================================
   Q11. Slow-moving stock definition for this project:
        - on-hand quantity > 0
        - current stock cover > 90 days
        - stock cover is below 999 (999 represents zero/very-low movement)
   ========================================================= */
SELECT
    COUNT(*) AS SlowMovingPositions,
    SUM(on_hand_qty) AS SlowMovingQty,
    ROUND(SUM(stock_value_aed),2) AS SlowMovingStockValueAED
FROM dbo.Inventory
WHERE on_hand_qty > 0
  AND stock_cover_days > 90
  AND stock_cover_days < 999;
GO

SELECT TOP 25
    s.store_name,
    p.product_name,
    c.category_name,
    i.on_hand_qty,
    i.avg_daily_sales_qty,
    i.stock_cover_days,
    ROUND(i.stock_value_aed,2) AS StockValueAED
FROM dbo.Inventory i
INNER JOIN dbo.Products p
    ON i.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
INNER JOIN dbo.Stores s
    ON i.store_id = s.store_id
WHERE i.on_hand_qty > 0
  AND i.stock_cover_days > 90
  AND i.stock_cover_days < 999
ORDER BY
    i.stock_value_aed DESC;
GO


/* =========================================================
   Q12. Dead stock definition for this project:
        stock on hand at year-end but ZERO units sold in the full year
        at that store-product combination.
   ========================================================= */
WITH AnnualProductSales AS
(
    SELECT
        s.store_id,
        si.product_id,
        SUM(si.quantity) AS UnitsSold
    FROM dbo.Sales_Items si
    INNER JOIN dbo.Sales s
        ON si.sale_id = s.sale_id
    GROUP BY
        s.store_id,
        si.product_id
)
SELECT
    COUNT(*) AS DeadStockPositions,
    SUM(i.on_hand_qty) AS DeadStockQty,
    ROUND(SUM(i.stock_value_aed),2) AS DeadStockValueAED
FROM dbo.Inventory i
LEFT JOIN AnnualProductSales aps
    ON i.store_id = aps.store_id
   AND i.product_id = aps.product_id
WHERE i.on_hand_qty > 0
  AND ISNULL(aps.UnitsSold,0) = 0;
GO


/* =========================================================
   Q13. Non-moving stock definition for this project:
        stock on hand with no sale in the last 90 days.
   ========================================================= */
WITH LastSale AS
(
    SELECT
        s.store_id,
        si.product_id,
        MAX(s.sale_datetime) AS LastSaleDate
    FROM dbo.Sales_Items si
    INNER JOIN dbo.Sales s
        ON si.sale_id = s.sale_id
    GROUP BY
        s.store_id,
        si.product_id
)
SELECT
    COUNT(*) AS NonMoving90DayPositions,
    SUM(i.on_hand_qty) AS NonMoving90DayQty,
    ROUND(SUM(i.stock_value_aed),2) AS NonMoving90DayValueAED
FROM dbo.Inventory i
LEFT JOIN LastSale ls
    ON i.store_id = ls.store_id
   AND i.product_id = ls.product_id
WHERE i.on_hand_qty > 0
  AND (
        ls.LastSaleDate IS NULL
        OR DATEDIFF(DAY, ls.LastSaleDate, i.as_of_date) > 90
      );
GO


/* =========================================================
   Q14. Which non-moving items tie up the most working capital?
   ========================================================= */
WITH LastSale AS
(
    SELECT
        s.store_id,
        si.product_id,
        MAX(s.sale_datetime) AS LastSaleDate
    FROM dbo.Sales_Items si
    INNER JOIN dbo.Sales s
        ON si.sale_id = s.sale_id
    GROUP BY
        s.store_id,
        si.product_id
)
SELECT TOP 25
    st.store_name,
    p.product_id,
    p.product_name,
    c.category_name,
    i.on_hand_qty,
    ROUND(i.stock_value_aed,2) AS StockValueAED,
    ls.LastSaleDate,
    CASE
        WHEN ls.LastSaleDate IS NULL THEN NULL
        ELSE DATEDIFF(DAY, ls.LastSaleDate, i.as_of_date)
    END AS DaysSinceLastSale
FROM dbo.Inventory i
LEFT JOIN LastSale ls
    ON i.store_id = ls.store_id
   AND i.product_id = ls.product_id
INNER JOIN dbo.Products p
    ON i.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
INNER JOIN dbo.Stores st
    ON i.store_id = st.store_id
WHERE i.on_hand_qty > 0
  AND (
        ls.LastSaleDate IS NULL
        OR DATEDIFF(DAY, ls.LastSaleDate, i.as_of_date) > 90
      )
ORDER BY i.stock_value_aed DESC;
GO


/* =========================================================
   Q15. Which categories have the most non-moving stock value?
   ========================================================= */
WITH LastSale AS
(
    SELECT
        s.store_id,
        si.product_id,
        MAX(s.sale_datetime) AS LastSaleDate
    FROM dbo.Sales_Items si
    INNER JOIN dbo.Sales s
        ON si.sale_id = s.sale_id
    GROUP BY
        s.store_id,
        si.product_id
)
SELECT
    c.category_name,
    COUNT(*) AS NonMovingPositions,
    SUM(i.on_hand_qty) AS NonMovingQty,
    ROUND(SUM(i.stock_value_aed),2) AS NonMovingValueAED
FROM dbo.Inventory i
LEFT JOIN LastSale ls
    ON i.store_id = ls.store_id
   AND i.product_id = ls.product_id
INNER JOIN dbo.Products p
    ON i.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
WHERE i.on_hand_qty > 0
  AND (
        ls.LastSaleDate IS NULL
        OR DATEDIFF(DAY, ls.LastSaleDate, i.as_of_date) > 90
      )
GROUP BY c.category_name
ORDER BY NonMovingValueAED DESC;
GO
