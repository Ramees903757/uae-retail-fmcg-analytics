SELECT
    COUNT(DISTINCT sale_id) AS Transactions,

    ROUND(SUM(net_sales_aed), 2) AS Revenue,

    ROUND(SUM(gross_profit_aed), 2) AS GrossProfit,

    ROUND(
        SUM(gross_profit_aed) /
        NULLIF(SUM(net_sales_aed), 0) * 100,
        2
    ) AS GP_Pct,

    ROUND(
        SUM(net_sales_aed) /
        NULLIF(COUNT(DISTINCT sale_id), 0),
        2
    ) AS AverageBasketValue,

    SUM(basket_units) AS UnitsSold

FROM Sales;

SELECT
    YEAR(sale_datetime) AS SalesYear,
    MONTH(sale_datetime) AS SalesMonth,

    ROUND(SUM(net_sales_aed), 2) AS Revenue,

    ROUND(SUM(gross_profit_aed), 2) AS GrossProfit,

    COUNT(DISTINCT sale_id) AS Transactions,

    ROUND(
        SUM(net_sales_aed) /
        COUNT(DISTINCT sale_id),
        2
    ) AS AverageBasketValue

FROM Sales

GROUP BY
    YEAR(sale_datetime),
    MONTH(sale_datetime)

ORDER BY
    SalesYear,
    SalesMonth;
