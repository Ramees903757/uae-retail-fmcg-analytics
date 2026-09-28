
/*
08_Wastage_Analysis.sql
UAE Retail & FMCG BI Portfolio Project
SQL Server / SSMS

Purpose:
Analyze total wastage, waste %, expiry losses, store/category losses,
monthly trends and high-wastage SKUs.

Run each section separately in SSMS and save the outputs.
*/

USE UAE_Retail_Analytics;
GO

/* =========================================================
   Q1. What is the total wastage value and quantity?
   ========================================================= */
SELECT
    SUM(quantity) AS TotalWastageQty,
    ROUND(SUM(waste_value_aed), 2) AS TotalWastageValueAED
FROM dbo.Wastage;
GO


/* =========================================================
   Q2. What percentage of annual sales and gross profit
       is represented by wastage cost?
   ========================================================= */
SELECT
    ROUND((SELECT SUM(waste_value_aed) FROM dbo.Wastage), 2) AS WastageValueAED,
    ROUND((SELECT SUM(net_sales_aed) FROM dbo.Sales), 2) AS AnnualRevenueAED,
    ROUND(
        100.0 * (SELECT SUM(waste_value_aed) FROM dbo.Wastage) /
        NULLIF((SELECT SUM(net_sales_aed) FROM dbo.Sales), 0),
        2
    ) AS WastageAsPctOfSales,
    ROUND(
        100.0 * (SELECT SUM(waste_value_aed) FROM dbo.Wastage) /
        NULLIF((SELECT SUM(gross_profit_aed) FROM dbo.Sales), 0),
        2
    ) AS WastageAsPctOfGrossProfit;
GO


/* =========================================================
   Q3. What are the main wastage reasons?
   ========================================================= */
SELECT
    reason,
    SUM(quantity) AS WastageQty,
    ROUND(SUM(waste_value_aed), 2) AS WastageValueAED,
    ROUND(
        100.0 * SUM(waste_value_aed) /
        NULLIF((SELECT SUM(waste_value_aed) FROM dbo.Wastage), 0),
        2
    ) AS ShareOfWastagePct
FROM dbo.Wastage
GROUP BY reason
ORDER BY WastageValueAED DESC;
GO


/* =========================================================
   Q4. Which stores generate the highest absolute wastage?
   ========================================================= */
SELECT
    s.store_id,
    s.store_name,
    s.city,
    SUM(w.quantity) AS WastageQty,
    ROUND(SUM(w.waste_value_aed), 2) AS WastageValueAED,
    ROUND(
        100.0 * SUM(w.waste_value_aed) /
        NULLIF((SELECT SUM(waste_value_aed) FROM dbo.Wastage), 0),
        2
    ) AS ShareOfTotalWastagePct
FROM dbo.Wastage w
INNER JOIN dbo.Stores s
    ON w.store_id = s.store_id
GROUP BY
    s.store_id,
    s.store_name,
    s.city
ORDER BY WastageValueAED DESC;
GO


/* =========================================================
   Q5. Which stores have the highest wastage relative to sales?
   This is more comparable than absolute wastage alone.
   ========================================================= */
WITH StoreSales AS
(
    SELECT
        store_id,
        SUM(net_sales_aed) AS RevenueAED
    FROM dbo.Sales
    GROUP BY store_id
),
StoreWaste AS
(
    SELECT
        store_id,
        SUM(waste_value_aed) AS WasteAED
    FROM dbo.Wastage
    GROUP BY store_id
)
SELECT
    st.store_name,
    ROUND(ss.RevenueAED, 2) AS RevenueAED,
    ROUND(sw.WasteAED, 2) AS WastageValueAED,
    ROUND(
        100.0 * sw.WasteAED / NULLIF(ss.RevenueAED, 0),
        3
    ) AS WastagePctOfSales
FROM StoreWaste sw
INNER JOIN StoreSales ss
    ON sw.store_id = ss.store_id
INNER JOIN dbo.Stores st
    ON sw.store_id = st.store_id
ORDER BY WastagePctOfSales DESC;
GO


/* =========================================================
   Q6. Which categories create the most wastage value?
   ========================================================= */
SELECT
    c.category_name,
    SUM(w.quantity) AS WastageQty,
    ROUND(SUM(w.waste_value_aed), 2) AS WastageValueAED,
    ROUND(
        100.0 * SUM(w.waste_value_aed) /
        NULLIF((SELECT SUM(waste_value_aed) FROM dbo.Wastage), 0),
        2
    ) AS ShareOfTotalWastagePct
FROM dbo.Wastage w
INNER JOIN dbo.Products p
    ON w.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY WastageValueAED DESC;
GO


/* =========================================================
   Q7. Which categories have the highest wastage relative
       to category sales?
   ========================================================= */
WITH CategorySales AS
(
    SELECT
        p.category_id,
        SUM(si.net_sales_aed) AS RevenueAED
    FROM dbo.Sales_Items si
    INNER JOIN dbo.Products p
        ON si.product_id = p.product_id
    GROUP BY p.category_id
),
CategoryWaste AS
(
    SELECT
        p.category_id,
        SUM(w.waste_value_aed) AS WasteAED
    FROM dbo.Wastage w
    INNER JOIN dbo.Products p
        ON w.product_id = p.product_id
    GROUP BY p.category_id
)
SELECT
    c.category_name,
    ROUND(cs.RevenueAED, 2) AS RevenueAED,
    ROUND(cw.WasteAED, 2) AS WastageValueAED,
    ROUND(
        100.0 * cw.WasteAED / NULLIF(cs.RevenueAED, 0),
        3
    ) AS WastagePctOfCategorySales
FROM CategoryWaste cw
INNER JOIN CategorySales cs
    ON cw.category_id = cs.category_id
INNER JOIN dbo.Categories c
    ON cw.category_id = c.category_id
ORDER BY WastagePctOfCategorySales DESC;
GO


/* =========================================================
   Q8. How does wastage change month by month?
   ========================================================= */
SELECT
    YEAR(wastage_date) AS WasteYear,
    MONTH(wastage_date) AS WasteMonth,
    SUM(quantity) AS WastageQty,
    ROUND(SUM(waste_value_aed), 2) AS WastageValueAED
FROM dbo.Wastage
GROUP BY
    YEAR(wastage_date),
    MONTH(wastage_date)
ORDER BY
    WasteYear,
    WasteMonth;
GO


/* =========================================================
   Q9. Which month had the highest wastage?
   ========================================================= */
SELECT TOP 1
    YEAR(wastage_date) AS WasteYear,
    MONTH(wastage_date) AS WasteMonth,
    SUM(quantity) AS WastageQty,
    ROUND(SUM(waste_value_aed), 2) AS WastageValueAED
FROM dbo.Wastage
GROUP BY
    YEAR(wastage_date),
    MONTH(wastage_date)
ORDER BY
    SUM(waste_value_aed) DESC;
GO


/* =========================================================
   Q10. What is the value of expiry-related losses?
   ========================================================= */
SELECT
    SUM(quantity) AS ExpiryQty,
    ROUND(SUM(waste_value_aed), 2) AS ExpiryLossAED,
    ROUND(
        100.0 * SUM(waste_value_aed) /
        NULLIF((SELECT SUM(waste_value_aed) FROM dbo.Wastage), 0),
        2
    ) AS ExpiryShareOfWastagePct
FROM dbo.Wastage
WHERE reason = 'Expiry';
GO


/* =========================================================
   Q11. Which categories create the most expiry loss?
   ========================================================= */
SELECT
    c.category_name,
    SUM(w.quantity) AS ExpiryQty,
    ROUND(SUM(w.waste_value_aed), 2) AS ExpiryLossAED
FROM dbo.Wastage w
INNER JOIN dbo.Products p
    ON w.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
WHERE w.reason = 'Expiry'
GROUP BY c.category_name
ORDER BY ExpiryLossAED DESC;
GO


/* =========================================================
   Q12. Which stores create the most expiry loss?
   ========================================================= */
SELECT
    s.store_name,
    SUM(w.quantity) AS ExpiryQty,
    ROUND(SUM(w.waste_value_aed), 2) AS ExpiryLossAED
FROM dbo.Wastage w
INNER JOIN dbo.Stores s
    ON w.store_id = s.store_id
WHERE w.reason = 'Expiry'
GROUP BY s.store_name
ORDER BY ExpiryLossAED DESC;
GO


/* =========================================================
   Q13. Which individual SKUs generate the most wastage?
   ========================================================= */
SELECT TOP 25
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(w.quantity) AS WastageQty,
    ROUND(SUM(w.waste_value_aed), 2) AS WastageValueAED
FROM dbo.Wastage w
INNER JOIN dbo.Products p
    ON w.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
GROUP BY
    p.product_id,
    p.product_name,
    c.category_name
ORDER BY WastageValueAED DESC;
GO


/* =========================================================
   Q14. Which store-SKU combinations generate the most wastage?
   Useful for operational action.
   ========================================================= */
SELECT TOP 25
    s.store_name,
    p.product_id,
    p.product_name,
    c.category_name,
    SUM(w.quantity) AS WastageQty,
    ROUND(SUM(w.waste_value_aed), 2) AS WastageValueAED
FROM dbo.Wastage w
INNER JOIN dbo.Stores s
    ON w.store_id = s.store_id
INNER JOIN dbo.Products p
    ON w.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
GROUP BY
    s.store_name,
    p.product_id,
    p.product_name,
    c.category_name
ORDER BY WastageValueAED DESC;
GO


/* =========================================================
   Q15. Store x Category wastage matrix
   ========================================================= */
SELECT
    s.store_name,
    c.category_name,
    SUM(w.quantity) AS WastageQty,
    ROUND(SUM(w.waste_value_aed), 2) AS WastageValueAED
FROM dbo.Wastage w
INNER JOIN dbo.Stores s
    ON w.store_id = s.store_id
INNER JOIN dbo.Products p
    ON w.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
GROUP BY
    s.store_name,
    c.category_name
ORDER BY
    s.store_name,
    WastageValueAED DESC;
GO


/* =========================================================
   Q16. How concentrated is wastage among top SKUs?
   Top 20 SKU share of total wastage.
   ========================================================= */
WITH ProductWaste AS
(
    SELECT
        product_id,
        SUM(waste_value_aed) AS WasteAED
    FROM dbo.Wastage
    GROUP BY product_id
),
RankedWaste AS
(
    SELECT
        product_id,
        WasteAED,
        ROW_NUMBER() OVER (ORDER BY WasteAED DESC) AS rn
    FROM ProductWaste
)
SELECT
    ROUND(SUM(CASE WHEN rn <= 20 THEN WasteAED ELSE 0 END), 2) AS Top20SKUWasteAED,
    ROUND(SUM(WasteAED), 2) AS TotalWasteAED,
    ROUND(
        100.0 * SUM(CASE WHEN rn <= 20 THEN WasteAED ELSE 0 END) /
        NULLIF(SUM(WasteAED), 0),
        2
    ) AS Top20SKUWasteSharePct
FROM RankedWaste;
GO
