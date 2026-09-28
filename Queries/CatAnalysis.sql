SELECT
    c.category_name,

    ROUND(SUM(si.net_sales_aed),2) AS Revenue,

    ROUND(SUM(si.gross_profit_aed),2) AS GrossProfit,

    ROUND(
        SUM(si.gross_profit_aed) /
        NULLIF(SUM(si.net_sales_aed),0) * 100,
        2
    ) AS GP_Pct,

    SUM(si.quantity) AS UnitsSold

FROM Sales_Items si

INNER JOIN Products p
    ON si.product_id = p.product_id

INNER JOIN Categories c
    ON p.category_id = c.category_id

GROUP BY
    c.category_name

ORDER BY
    Revenue DESC;
    
SELECT TOP 20
    p.product_id,
    p.product_name,
    c.category_name,

    ROUND(SUM(si.net_sales_aed),2) AS Revenue,

    SUM(si.quantity) AS UnitsSold,

    ROUND(SUM(si.gross_profit_aed),2) AS GrossProfit

FROM Sales_Items si

INNER JOIN Products p
    ON si.product_id = p.product_id

INNER JOIN Categories c
    ON p.category_id = c.category_id

GROUP BY
    p.product_id,
    p.product_name,
    c.category_name

ORDER BY
    -- Revenue DESC;
    Revenue ASC;
    
