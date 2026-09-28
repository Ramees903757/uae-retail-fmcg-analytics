
/*
11_Customer_Basket_Analysis.sql
UAE Retail & FMCG BI Portfolio Project
SQL Server / SSMS

Purpose:
Analyze identified vs anonymous shoppers, loyalty segments,
repeat customers, customer value, basket size and product pairs.
*/

USE UAE_Retail_Analytics;
GO

/* =========================================================
   Q1. How many transactions are identified vs anonymous?
   ========================================================= */
SELECT
    CASE
        WHEN customer_id IS NULL THEN 'Anonymous / Walk-in'
        ELSE 'Identified Customer'
    END AS CustomerType,
    COUNT(*) AS Transactions,
    ROUND(SUM(net_sales_aed),2) AS RevenueAED,
    ROUND(
        100.0 * SUM(net_sales_aed) /
        NULLIF((SELECT SUM(net_sales_aed) FROM dbo.Sales),0),
        2
    ) AS RevenueSharePct,
    ROUND(AVG(net_sales_aed),2) AS AverageBasketValueAED
FROM dbo.Sales
GROUP BY
    CASE
        WHEN customer_id IS NULL THEN 'Anonymous / Walk-in'
        ELSE 'Identified Customer'
    END;
GO


/* =========================================================
   Q2. How many unique identified customers purchased?
   ========================================================= */
SELECT
    COUNT(DISTINCT customer_id) AS ActiveIdentifiedCustomers
FROM dbo.Sales
WHERE customer_id IS NOT NULL;
GO


/* =========================================================
   Q3. What is the repeat-customer rate?
   Repeat = 2 or more transactions during the year.
   ========================================================= */
WITH CustomerTransactions AS
(
    SELECT
        customer_id,
        COUNT(DISTINCT sale_id) AS Transactions
    FROM dbo.Sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    COUNT(*) AS ActiveIdentifiedCustomers,
    SUM(CASE WHEN Transactions >= 2 THEN 1 ELSE 0 END) AS RepeatCustomers,
    SUM(CASE WHEN Transactions = 1 THEN 1 ELSE 0 END) AS OneTimeCustomers,
    ROUND(
        100.0 * SUM(CASE WHEN Transactions >= 2 THEN 1 ELSE 0 END) /
        NULLIF(COUNT(*),0),
        2
    ) AS RepeatCustomerPct
FROM CustomerTransactions;
GO


/* =========================================================
   Q4. How do loyalty segments perform?
   ========================================================= */
WITH CustomerPerformance AS
(
    SELECT
        customer_id,
        COUNT(DISTINCT sale_id) AS Transactions,
        SUM(net_sales_aed) AS RevenueAED,
        SUM(gross_profit_aed) AS GrossProfitAED
    FROM dbo.Sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    c.loyalty_segment,
    COUNT(cp.customer_id) AS ActiveCustomers,
    SUM(cp.Transactions) AS Transactions,
    ROUND(SUM(cp.RevenueAED),2) AS RevenueAED,
    ROUND(
        100.0 * SUM(cp.RevenueAED) /
        NULLIF(
            (SELECT SUM(net_sales_aed)
             FROM dbo.Sales
             WHERE customer_id IS NOT NULL),
            0
        ),
        2
    ) AS IdentifiedRevenueSharePct,
    ROUND(
        SUM(cp.RevenueAED) / NULLIF(COUNT(cp.customer_id),0),
        2
    ) AS RevenuePerCustomerAED,
    ROUND(
        SUM(cp.RevenueAED) / NULLIF(SUM(cp.Transactions),0),
        2
    ) AS AverageBasketValueAED
FROM CustomerPerformance cp
INNER JOIN dbo.Customers c
    ON cp.customer_id = c.customer_id
GROUP BY c.loyalty_segment
ORDER BY RevenueAED DESC;
GO


/* =========================================================
   Q5. Which customer home cities contribute most revenue?
   ========================================================= */
SELECT
    c.home_city,
    COUNT(DISTINCT s.customer_id) AS ActiveCustomers,
    COUNT(DISTINCT s.sale_id) AS Transactions,
    ROUND(SUM(s.net_sales_aed),2) AS RevenueAED,
    ROUND(
        SUM(s.net_sales_aed) /
        NULLIF(COUNT(DISTINCT s.customer_id),0),
        2
    ) AS RevenuePerCustomerAED
FROM dbo.Sales s
INNER JOIN dbo.Customers c
    ON s.customer_id = c.customer_id
WHERE s.customer_id IS NOT NULL
GROUP BY c.home_city
ORDER BY RevenueAED DESC;
GO


/* =========================================================
   Q6. What are the highest-value identified customers?
   ========================================================= */
SELECT TOP 25
    s.customer_id,
    c.loyalty_segment,
    c.home_city,
    COUNT(DISTINCT s.sale_id) AS Transactions,
    ROUND(SUM(s.net_sales_aed),2) AS RevenueAED,
    ROUND(SUM(s.gross_profit_aed),2) AS GrossProfitAED,
    ROUND(
        SUM(s.net_sales_aed) /
        NULLIF(COUNT(DISTINCT s.sale_id),0),
        2
    ) AS AverageBasketValueAED
FROM dbo.Sales s
INNER JOIN dbo.Customers c
    ON s.customer_id = c.customer_id
WHERE s.customer_id IS NOT NULL
GROUP BY
    s.customer_id,
    c.loyalty_segment,
    c.home_city
ORDER BY RevenueAED DESC;
GO


/* =========================================================
   Q7. How are baskets distributed by line count?
   ========================================================= */
SELECT
    basket_lines,
    COUNT(*) AS Transactions,
    ROUND(
        100.0 * COUNT(*) /
        NULLIF((SELECT COUNT(*) FROM dbo.Sales),0),
        2
    ) AS TransactionSharePct,
    ROUND(AVG(net_sales_aed),2) AS AverageBasketValueAED
FROM dbo.Sales
GROUP BY basket_lines
ORDER BY basket_lines;
GO


/* =========================================================
   Q8. Overall basket metrics
   ========================================================= */
SELECT
    ROUND(AVG(1.0 * basket_lines),2) AS AvgBasketLines,
    ROUND(AVG(1.0 * basket_units),2) AS AvgBasketUnits,
    ROUND(AVG(net_sales_aed),2) AS AvgBasketValueAED
FROM dbo.Sales;
GO


/* =========================================================
   Q9. Which categories appear in the most baskets?
   ========================================================= */
SELECT
    c.category_name,
    COUNT(DISTINCT si.sale_id) AS BasketsContainingCategory,
    SUM(si.quantity) AS UnitsSold,
    ROUND(SUM(si.net_sales_aed),2) AS RevenueAED
FROM dbo.Sales_Items si
INNER JOIN dbo.Products p
    ON si.product_id = p.product_id
INNER JOIN dbo.Categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY BasketsContainingCategory DESC;
GO


/* =========================================================
   Q10. Which PRODUCT PAIRS are most frequently purchased
        together in the same transaction?

   Note:
   This uses distinct product per basket so multiple units do
   not artificially inflate pair frequency.
   ========================================================= */
WITH BasketProducts AS
(
    SELECT DISTINCT
        sale_id,
        product_id
    FROM dbo.Sales_Items
),
ProductPairs AS
(
    SELECT
        a.product_id AS ProductA,
        b.product_id AS ProductB,
        COUNT(*) AS BasketCount
    FROM BasketProducts a
    INNER JOIN BasketProducts b
        ON a.sale_id = b.sale_id
       AND a.product_id < b.product_id
    GROUP BY
        a.product_id,
        b.product_id
)
SELECT TOP 25
    pp.ProductA,
    pa.product_name AS ProductAName,
    pp.ProductB,
    pb.product_name AS ProductBName,
    pp.BasketCount
FROM ProductPairs pp
INNER JOIN dbo.Products pa
    ON pp.ProductA = pa.product_id
INNER JOIN dbo.Products pb
    ON pp.ProductB = pb.product_id
ORDER BY
    pp.BasketCount DESC,
    pp.ProductA,
    pp.ProductB;
GO


/* =========================================================
   Q11. Which CATEGORY PAIRS are most frequently bought
        together?
   This is often more stable and business-friendly than SKU pairs.
   ========================================================= */
WITH BasketCategories AS
(
    SELECT DISTINCT
        si.sale_id,
        p.category_id
    FROM dbo.Sales_Items si
    INNER JOIN dbo.Products p
        ON si.product_id = p.product_id
),
CategoryPairs AS
(
    SELECT
        a.category_id AS CategoryA,
        b.category_id AS CategoryB,
        COUNT(*) AS BasketCount
    FROM BasketCategories a
    INNER JOIN BasketCategories b
        ON a.sale_id = b.sale_id
       AND a.category_id < b.category_id
    GROUP BY
        a.category_id,
        b.category_id
)
SELECT TOP 20
    ca.category_name AS CategoryA,
    cb.category_name AS CategoryB,
    cp.BasketCount
FROM CategoryPairs cp
INNER JOIN dbo.Categories ca
    ON cp.CategoryA = ca.category_id
INNER JOIN dbo.Categories cb
    ON cp.CategoryB = cb.category_id
ORDER BY cp.BasketCount DESC;
GO


/* =========================================================
   Q12. Basic market-basket metrics for top product pairs:
        Support, Confidence(A->B), Confidence(B->A), Lift

   Lift > 1 indicates the pair occurs together more often
   than expected under independence. Still not causation.
   ========================================================= */
WITH BasketProducts AS
(
    SELECT DISTINCT
        sale_id,
        product_id
    FROM dbo.Sales_Items
),
TotalBaskets AS
(
    SELECT COUNT(DISTINCT sale_id) AS TotalBasketCount
    FROM dbo.Sales
),
ProductBasketCounts AS
(
    SELECT
        product_id,
        COUNT(*) AS ProductBasketCount
    FROM BasketProducts
    GROUP BY product_id
),
PairCounts AS
(
    SELECT
        a.product_id AS ProductA,
        b.product_id AS ProductB,
        COUNT(*) AS PairBasketCount
    FROM BasketProducts a
    INNER JOIN BasketProducts b
        ON a.sale_id = b.sale_id
       AND a.product_id < b.product_id
    GROUP BY
        a.product_id,
        b.product_id
),
TopPairs AS
(
    SELECT TOP 50
        ProductA,
        ProductB,
        PairBasketCount
    FROM PairCounts
    ORDER BY PairBasketCount DESC
)
SELECT
    tp.ProductA,
    pa.product_name AS ProductAName,
    tp.ProductB,
    pb.product_name AS ProductBName,
    tp.PairBasketCount,

    ROUND(
        100.0 * tp.PairBasketCount / tb.TotalBasketCount,
        4
    ) AS SupportPct,

    ROUND(
        100.0 * tp.PairBasketCount / pca.ProductBasketCount,
        2
    ) AS Confidence_A_to_B_Pct,

    ROUND(
        100.0 * tp.PairBasketCount / pcb.ProductBasketCount,
        2
    ) AS Confidence_B_to_A_Pct,

    ROUND(
        (1.0 * tp.PairBasketCount / tb.TotalBasketCount) /
        NULLIF(
            (1.0 * pca.ProductBasketCount / tb.TotalBasketCount) *
            (1.0 * pcb.ProductBasketCount / tb.TotalBasketCount),
            0
        ),
        3
    ) AS Lift

FROM TopPairs tp
INNER JOIN dbo.Products pa
    ON tp.ProductA = pa.product_id
INNER JOIN dbo.Products pb
    ON tp.ProductB = pb.product_id
INNER JOIN ProductBasketCounts pca
    ON tp.ProductA = pca.product_id
INNER JOIN ProductBasketCounts pcb
    ON tp.ProductB = pcb.product_id
CROSS JOIN TotalBaskets tb
ORDER BY tp.PairBasketCount DESC;
GO


/* =========================================================
   Q13. Simple customer value segmentation based on annual spend
        quartiles using NTILE.

   This is a descriptive portfolio segmentation, not the same
   as the existing loyalty_segment field.
   ========================================================= */
WITH CustomerSpend AS
(
    SELECT
        customer_id,
        COUNT(DISTINCT sale_id) AS Transactions,
        SUM(net_sales_aed) AS RevenueAED
    FROM dbo.Sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
),
RankedCustomers AS
(
    SELECT
        customer_id,
        Transactions,
        RevenueAED,
        NTILE(4) OVER (ORDER BY RevenueAED DESC) AS SpendQuartile
    FROM CustomerSpend
)
SELECT
    SpendQuartile,
    COUNT(*) AS Customers,
    ROUND(SUM(RevenueAED),2) AS RevenueAED,
    ROUND(AVG(RevenueAED),2) AS AvgRevenuePerCustomerAED,
    ROUND(AVG(1.0 * Transactions),2) AS AvgTransactionsPerCustomer
FROM RankedCustomers
GROUP BY SpendQuartile
ORDER BY SpendQuartile;
GO
