SELECT
    st.store_id,
    st.store_name,
    st.city,

    ROUND(SUM(s.net_sales_aed), 2) AS Revenue,

    ROUND(SUM(s.gross_profit_aed), 2) AS GrossProfit,

    ROUND(
        SUM(s.gross_profit_aed) /
        NULLIF(SUM(s.net_sales_aed), 0) * 100,
        2
    ) AS GP_Pct,

    COUNT(DISTINCT s.sale_id) AS Transactions,

    ROUND(
        SUM(s.net_sales_aed) /
        COUNT(DISTINCT s.sale_id),
        2
    ) AS AverageBasketValue

FROM Sales s

INNER JOIN Stores st
    ON s.store_id = st.store_id

GROUP BY
    st.store_id,
    st.store_name,
    st.city

ORDER BY
    Revenue DESC;
    
SELECT
    st.store_name,
    t.month_start,

    t.sales_target_aed,

    ROUND(SUM(s.net_sales_aed),2) AS ActualSales,

    ROUND(
        SUM(s.net_sales_aed) - t.sales_target_aed,
        2
    ) AS Variance,

    ROUND(
        SUM(s.net_sales_aed) /
        NULLIF(t.sales_target_aed,0) * 100,
        2
    ) AS TargetAchievementPct

FROM Targets t

INNER JOIN Stores st
    ON t.store_id = st.store_id

INNER JOIN Sales s
    ON t.store_id = s.store_id
    AND YEAR(s.sale_datetime) = YEAR(t.month_start)
    AND MONTH(s.sale_datetime) = MONTH(t.month_start)

GROUP BY
    st.store_name,
    t.month_start,
    t.sales_target_aed

ORDER BY
    t.month_start,
    st.store_name;