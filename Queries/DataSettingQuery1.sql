CREATE DATABASE Uae_Analysis;
USE Uae_Analysis;
DROP TABLE dbo.Stores;
SELECT COUNT(*) from dbo.Customers;
EXEC sp_help 'Sales';

SELECT TOP 10 *
FROM Sales;

SELECT *
FROM Sales
WHERE TRY_CONVERT(datetime2, sale_datetime) IS NULL
  AND sale_datetime IS NOT NULL;
  
SELECT @@VERSION;

SELECT 
    name,
    compatibility_level
FROM sys.databases
WHERE name = DB_NAME();

SELECT *
FROM Sales
WHERE ISDATE(sale_datetime) = 0
  AND sale_datetime IS NOT NULL
  AND LTRIM(RTRIM(sale_datetime)) <> '';
  
SELECT *
FROM Sales
WHERE ISNUMERIC(net_sales_aed) = 0
  AND net_sales_aed IS NOT NULL
  AND LTRIM(RTRIM(net_sales_aed)) <> '';
  
SELECT *
FROM Sales
WHERE ISNUMERIC(net_sales_aed) = 0
   OR ISNUMERIC(discount_aed) = 0
   OR ISNUMERIC(vat_aed) = 0
   OR ISNUMERIC(total_aed) = 0
   OR ISNUMERIC(gross_profit_aed) = 0;
   
IF OBJECT_ID('dbo.Stores','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Stores','U') IS NULL
    EXEC sp_rename 'dbo.Stores', 'stg_Stores';
IF OBJECT_ID('dbo.Categories','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Categories','U') IS NULL
    EXEC sp_rename 'dbo.Categories', 'stg_Categories';
IF OBJECT_ID('dbo.Suppliers','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Suppliers','U') IS NULL
    EXEC sp_rename 'dbo.Suppliers', 'stg_Suppliers';
IF OBJECT_ID('dbo.Products','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Products','U') IS NULL
    EXEC sp_rename 'dbo.Products', 'stg_Products';
IF OBJECT_ID('dbo.Customers','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Customers','U') IS NULL
    EXEC sp_rename 'dbo.Customers', 'stg_Customers';
IF OBJECT_ID('dbo.Employees','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Employees','U') IS NULL
    EXEC sp_rename 'dbo.Employees', 'stg_Employees';
IF OBJECT_ID('dbo.Promotions','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Promotions','U') IS NULL
    EXEC sp_rename 'dbo.Promotions', 'stg_Promotions';
IF OBJECT_ID('dbo.Sales','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Sales','U') IS NULL
    EXEC sp_rename 'dbo.Sales', 'stg_Sales';
IF OBJECT_ID('dbo.Sales_Items','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Sales_Items','U') IS NULL
    EXEC sp_rename 'dbo.Sales_Items', 'stg_Sales_Items';
IF OBJECT_ID('dbo.Purchases','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Purchases','U') IS NULL
    EXEC sp_rename 'dbo.Purchases', 'stg_Purchases';
IF OBJECT_ID('dbo.Inventory_Snapshots','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Inventory_Snapshots','U') IS NULL
    EXEC sp_rename 'dbo.Inventory_Snapshots', 'stg_Inventory_Snapshots';
IF OBJECT_ID('dbo.Inventory','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Inventory','U') IS NULL
    EXEC sp_rename 'dbo.Inventory', 'stg_Inventory';
IF OBJECT_ID('dbo.Returns','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Returns','U') IS NULL
    EXEC sp_rename 'dbo.Returns', 'stg_Returns';
IF OBJECT_ID('dbo.Wastage','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Wastage','U') IS NULL
    EXEC sp_rename 'dbo.Wastage', 'stg_Wastage';
IF OBJECT_ID('dbo.Targets','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Targets','U') IS NULL
    EXEC sp_rename 'dbo.Targets', 'stg_Targets';
IF OBJECT_ID('dbo.Calendar','U') IS NOT NULL AND OBJECT_ID('dbo.stg_Calendar','U') IS NULL
    EXEC sp_rename 'dbo.Calendar', 'stg_Calendar';
    
 IF OBJECT_ID('dbo.Stores','U') IS NULL
CREATE TABLE dbo.Stores (
    store_id VARCHAR(10) NOT NULL,
    store_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NULL,
    emirate VARCHAR(100) NULL,
    store_format VARCHAR(50) NULL,
    floor_area_sqft INT NULL,
    opening_date DATE NULL,
    sales_capacity_index DECIMAL(10,2) NULL
);
GO
IF OBJECT_ID('dbo.Categories','U') IS NULL
CREATE TABLE dbo.Categories (
    category_id VARCHAR(10) NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NULL,
    typical_margin_pct DECIMAL(10,4) NULL,
    shelf_life_days INT NULL,
    is_perishable BIT NULL
);
GO
IF OBJECT_ID('dbo.Suppliers','U') IS NULL
CREATE TABLE dbo.Suppliers (
    supplier_id VARCHAR(10) NOT NULL,
    supplier_name VARCHAR(200) NULL,
    supplier_type VARCHAR(100) NULL,
    city VARCHAR(100) NULL,
    payment_terms_days INT NULL,
    avg_lead_time_days INT NULL,
    reliability_score DECIMAL(10,4) NULL
);
GO
IF OBJECT_ID('dbo.Products','U') IS NULL
CREATE TABLE dbo.Products (
    product_id VARCHAR(20) NOT NULL,
    product_name VARCHAR(250) NULL,
    category_id VARCHAR(10) NULL,
    subcategory VARCHAR(150) NULL,
    brand VARCHAR(100) NULL,
    unit_size VARCHAR(50) NULL,
    supplier_id VARCHAR(10) NULL,
    base_cost_aed DECIMAL(18,2) NULL,
    regular_price_aed DECIMAL(18,2) NULL,
    is_perishable BIT NULL,
    shelf_life_days INT NULL,
    min_stock_level INT NULL,
    reorder_point INT NULL,
    lead_time_days INT NULL
);
GO
IF OBJECT_ID('dbo.Customers','U') IS NULL
CREATE TABLE dbo.Customers (
    customer_id VARCHAR(20) NOT NULL,
    home_city VARCHAR(100) NULL,
    loyalty_segment VARCHAR(50) NULL,
    age_band VARCHAR(20) NULL,
    preferred_channel VARCHAR(50) NULL,
    registration_date DATE NULL
);
GO
IF OBJECT_ID('dbo.Employees','U') IS NULL
CREATE TABLE dbo.Employees (
    employee_id VARCHAR(20) NOT NULL,
    store_id VARCHAR(10) NULL,
    department VARCHAR(100) NULL,
    role VARCHAR(100) NULL,
    hire_date DATE NULL,
    monthly_salary_aed DECIMAL(18,2) NULL
);
GO
IF OBJECT_ID('dbo.Promotions','U') IS NULL
CREATE TABLE dbo.Promotions (
    promotion_id VARCHAR(20) NOT NULL,
    promotion_name VARCHAR(200) NULL,
    promo_scope VARCHAR(50) NULL,
    start_date DATE NULL,
    end_date DATE NULL,
    discount_pct DECIMAL(10,2) NULL,
    category_id VARCHAR(10) NULL
);
GO
IF OBJECT_ID('dbo.Sales','U') IS NULL
CREATE TABLE dbo.Sales (
    sale_id VARCHAR(20) NOT NULL,
    store_id VARCHAR(10) NOT NULL,
    customer_id VARCHAR(20) NULL,
    sale_datetime DATETIME2 NULL,
    channel VARCHAR(20) NULL,
    payment_method VARCHAR(20) NULL,
    net_sales_aed DECIMAL(18,2) NULL,
    discount_aed DECIMAL(18,2) NULL,
    vat_aed DECIMAL(18,2) NULL,
    total_aed DECIMAL(18,2) NULL,
    gross_profit_aed DECIMAL(18,2) NULL,
    basket_units INT NULL,
    basket_lines INT NULL
);
GO
IF OBJECT_ID('dbo.Sales_Items','U') IS NULL
CREATE TABLE dbo.Sales_Items (
    sale_item_id VARCHAR(20) NOT NULL,
    sale_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    quantity INT NULL,
    unit_price_aed DECIMAL(18,2) NULL,
    discount_pct DECIMAL(10,2) NULL,
    line_discount_aed DECIMAL(18,2) NULL,
    net_sales_aed DECIMAL(18,2) NULL,
    unit_cost_aed DECIMAL(18,2) NULL,
    cogs_aed DECIMAL(18,2) NULL,
    gross_profit_aed DECIMAL(18,2) NULL,
    promotion_id VARCHAR(20) NULL
);
GO
IF OBJECT_ID('dbo.Purchases','U') IS NULL
CREATE TABLE dbo.Purchases (
    purchase_id VARCHAR(20) NOT NULL,
    store_id VARCHAR(10) NOT NULL,
    supplier_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    purchase_date DATE NULL,
    quantity INT NULL,
    unit_cost_aed DECIMAL(18,2) NULL,
    expected_date DATE NULL,
    received_date DATE NULL,
    status VARCHAR(50) NULL,
    purchase_value_aed DECIMAL(18,2) NULL
);
GO
IF OBJECT_ID('dbo.Inventory_Snapshots','U') IS NULL
CREATE TABLE dbo.Inventory_Snapshots (
    snapshot_date DATE NOT NULL,
    store_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    opening_qty INT NULL,
    received_qty INT NULL,
    sold_qty INT NULL,
    return_to_stock_qty INT NULL,
    wastage_qty INT NULL,
    closing_qty INT NULL,
    stock_value_aed DECIMAL(18,2) NULL,
    avg_daily_sales_qty DECIMAL(18,3) NULL,
    stock_cover_days DECIMAL(18,2) NULL,
    stock_status VARCHAR(50) NULL
);
GO
IF OBJECT_ID('dbo.Inventory','U') IS NULL
CREATE TABLE dbo.Inventory (
    as_of_date DATE NOT NULL,
    store_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    on_hand_qty INT NULL,
    stock_value_aed DECIMAL(18,2) NULL,
    avg_daily_sales_qty DECIMAL(18,3) NULL,
    stock_cover_days DECIMAL(18,2) NULL,
    stock_status VARCHAR(50) NULL
);
GO
IF OBJECT_ID('dbo.Returns','U') IS NULL
CREATE TABLE dbo.Returns (
    return_id VARCHAR(20) NOT NULL,
    sale_item_id VARCHAR(20) NOT NULL,
    sale_id VARCHAR(20) NOT NULL,
    store_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    return_date DATE NULL,
    quantity INT NULL,
    return_value_aed DECIMAL(18,2) NULL,
    return_reason VARCHAR(100) NULL
);
GO
IF OBJECT_ID('dbo.Wastage','U') IS NULL
CREATE TABLE dbo.Wastage (
    wastage_id VARCHAR(20) NOT NULL,
    store_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    wastage_date DATE NULL,
    quantity INT NULL,
    unit_cost_aed DECIMAL(18,2) NULL,
    reason VARCHAR(100) NULL,
    waste_value_aed DECIMAL(18,2) NULL
);
GO
IF OBJECT_ID('dbo.Targets','U') IS NULL
CREATE TABLE dbo.Targets (
    target_id VARCHAR(20) NOT NULL,
    store_id VARCHAR(10) NOT NULL,
    month_start DATE NULL,
    sales_target_aed DECIMAL(18,2) NULL,
    gross_profit_target_aed DECIMAL(18,2) NULL,
    transaction_target INT NULL
);
GO
IF OBJECT_ID('dbo.Calendar','U') IS NULL
CREATE TABLE dbo.Calendar (
    [date] DATE NOT NULL,
    [year] INT NULL,
    month_no INT NULL,
    month_name VARCHAR(20) NULL,
    quarter VARCHAR(10) NULL,
    week_no INT NULL,
    day_name VARCHAR(20) NULL,
    is_weekend BIT NULL,
    year_month VARCHAR(10) NULL
);
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Stores)
INSERT INTO dbo.Stores (
    store_id,
    store_name,
    city,
    emirate,
    store_format,
    floor_area_sqft,
    opening_date,
    sales_capacity_index
)
SELECT
    LTRIM(RTRIM(store_id)),
    LTRIM(RTRIM(store_name)),
    city,
    emirate,
    store_format,
    CAST(NULLIF(LTRIM(RTRIM(floor_area_sqft)), '') AS INT),
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(opening_date)), ''), 23),
    CAST(NULLIF(LTRIM(RTRIM(sales_capacity_index)), '') AS DECIMAL(10,2))
FROM dbo.stg_Stores;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Categories)
INSERT INTO dbo.Categories (
    category_id,
    category_name,
    department,
    typical_margin_pct,
    shelf_life_days,
    is_perishable
)
SELECT
    LTRIM(RTRIM(category_id)),
    LTRIM(RTRIM(category_name)),
    department,
    CAST(NULLIF(LTRIM(RTRIM(typical_margin_pct)), '') AS DECIMAL(10,4)),
    CAST(NULLIF(LTRIM(RTRIM(shelf_life_days)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(is_perishable)), '') AS BIT)
FROM dbo.stg_Categories;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Suppliers)
INSERT INTO dbo.Suppliers (
    supplier_id,
    supplier_name,
    supplier_type,
    city,
    payment_terms_days,
    avg_lead_time_days,
    reliability_score
)
SELECT
    LTRIM(RTRIM(supplier_id)),
    supplier_name,
    supplier_type,
    city,
    CAST(NULLIF(LTRIM(RTRIM(payment_terms_days)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(avg_lead_time_days)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(reliability_score)), '') AS DECIMAL(10,4))
FROM dbo.stg_Suppliers;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Products)
INSERT INTO dbo.Products (
    product_id,
    product_name,
    category_id,
    subcategory,
    brand,
    unit_size,
    supplier_id,
    base_cost_aed,
    regular_price_aed,
    is_perishable,
    shelf_life_days,
    min_stock_level,
    reorder_point,
    lead_time_days
)
SELECT
    LTRIM(RTRIM(product_id)),
    product_name,
    category_id,
    subcategory,
    brand,
    unit_size,
    supplier_id,
    CAST(NULLIF(LTRIM(RTRIM(base_cost_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(regular_price_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(is_perishable)), '') AS BIT),
    CAST(NULLIF(LTRIM(RTRIM(shelf_life_days)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(min_stock_level)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(reorder_point)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(lead_time_days)), '') AS INT)
FROM dbo.stg_Products;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Customers)
INSERT INTO dbo.Customers (
    customer_id,
    home_city,
    loyalty_segment,
    age_band,
    preferred_channel,
    registration_date
)
SELECT
    LTRIM(RTRIM(customer_id)),
    home_city,
    loyalty_segment,
    age_band,
    preferred_channel,
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(registration_date)), ''), 23)
FROM dbo.stg_Customers;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Employees)
INSERT INTO dbo.Employees (
    employee_id,
    store_id,
    department,
    role,
    hire_date,
    monthly_salary_aed
)
SELECT
    LTRIM(RTRIM(employee_id)),
    store_id,
    department,
    role,
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(hire_date)), ''), 23),
    CAST(NULLIF(LTRIM(RTRIM(monthly_salary_aed)), '') AS DECIMAL(18,2))
FROM dbo.stg_Employees;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Promotions)
INSERT INTO dbo.Promotions (
    promotion_id,
    promotion_name,
    promo_scope,
    start_date,
    end_date,
    discount_pct,
    category_id
)
SELECT
    LTRIM(RTRIM(promotion_id)),
    promotion_name,
    promo_scope,
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(start_date)), ''), 23),
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(end_date)), ''), 23),
    CAST(NULLIF(LTRIM(RTRIM(discount_pct)), '') AS DECIMAL(10,2)),
    NULLIF(LTRIM(RTRIM(category_id)), '')
FROM dbo.stg_Promotions;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Sales)
INSERT INTO dbo.Sales (
    sale_id,
    store_id,
    customer_id,
    sale_datetime,
    channel,
    payment_method,
    net_sales_aed,
    discount_aed,
    vat_aed,
    total_aed,
    gross_profit_aed,
    basket_units,
    basket_lines
)
SELECT
    LTRIM(RTRIM(sale_id)),
    LTRIM(RTRIM(store_id)),
    NULLIF(LTRIM(RTRIM(customer_id)), ''),
    CONVERT(DATETIME2, NULLIF(LTRIM(RTRIM(sale_datetime)), ''), 120),
    channel,
    payment_method,
    CAST(NULLIF(LTRIM(RTRIM(net_sales_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(discount_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(vat_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(total_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(gross_profit_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(basket_units)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(basket_lines)), '') AS INT)
FROM dbo.stg_Sales;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Sales_Items)
INSERT INTO dbo.Sales_Items (
    sale_item_id,
    sale_id,
    product_id,
    quantity,
    unit_price_aed,
    discount_pct,
    line_discount_aed,
    net_sales_aed,
    unit_cost_aed,
    cogs_aed,
    gross_profit_aed,
    promotion_id
)
SELECT
    LTRIM(RTRIM(sale_item_id)),
    LTRIM(RTRIM(sale_id)),
    LTRIM(RTRIM(product_id)),
    CAST(NULLIF(LTRIM(RTRIM(quantity)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(unit_price_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(discount_pct)), '') AS DECIMAL(10,2)),
    CAST(NULLIF(LTRIM(RTRIM(line_discount_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(net_sales_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(unit_cost_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(cogs_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(gross_profit_aed)), '') AS DECIMAL(18,2)),
    NULLIF(LTRIM(RTRIM(promotion_id)), '')
FROM dbo.stg_Sales_Items;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Purchases)
INSERT INTO dbo.Purchases (
    purchase_id,
    store_id,
    supplier_id,
    product_id,
    purchase_date,
    quantity,
    unit_cost_aed,
    expected_date,
    received_date,
    status,
    purchase_value_aed
)
SELECT
    LTRIM(RTRIM(purchase_id)),
    LTRIM(RTRIM(store_id)),
    LTRIM(RTRIM(supplier_id)),
    LTRIM(RTRIM(product_id)),
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(purchase_date)), ''), 23),
    CAST(NULLIF(LTRIM(RTRIM(quantity)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(unit_cost_aed)), '') AS DECIMAL(18,2)),
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(expected_date)), ''), 23),
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(received_date)), ''), 23),
    status,
    CAST(NULLIF(LTRIM(RTRIM(purchase_value_aed)), '') AS DECIMAL(18,2))
FROM dbo.stg_Purchases;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Inventory_Snapshots)
INSERT INTO dbo.Inventory_Snapshots (
    snapshot_date,
    store_id,
    product_id,
    opening_qty,
    received_qty,
    sold_qty,
    return_to_stock_qty,
    wastage_qty,
    closing_qty,
    stock_value_aed,
    avg_daily_sales_qty,
    stock_cover_days,
    stock_status
)
SELECT
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(snapshot_date)), ''), 23),
    LTRIM(RTRIM(store_id)),
    LTRIM(RTRIM(product_id)),
    CAST(NULLIF(LTRIM(RTRIM(opening_qty)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(received_qty)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(sold_qty)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(return_to_stock_qty)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(wastage_qty)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(closing_qty)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(stock_value_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(avg_daily_sales_qty)), '') AS DECIMAL(18,3)),
    CAST(NULLIF(LTRIM(RTRIM(stock_cover_days)), '') AS DECIMAL(18,2)),
    stock_status
FROM dbo.stg_Inventory_Snapshots;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Inventory)
INSERT INTO dbo.Inventory (
    as_of_date,
    store_id,
    product_id,
    on_hand_qty,
    stock_value_aed,
    avg_daily_sales_qty,
    stock_cover_days,
    stock_status
)
SELECT
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(as_of_date)), ''), 23),
    LTRIM(RTRIM(store_id)),
    LTRIM(RTRIM(product_id)),
    CAST(NULLIF(LTRIM(RTRIM(on_hand_qty)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(stock_value_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(avg_daily_sales_qty)), '') AS DECIMAL(18,3)),
    CAST(NULLIF(LTRIM(RTRIM(stock_cover_days)), '') AS DECIMAL(18,2)),
    stock_status
FROM dbo.stg_Inventory;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Returns)
INSERT INTO dbo.Returns (
    return_id,
    sale_item_id,
    sale_id,
    store_id,
    product_id,
    return_date,
    quantity,
    return_value_aed,
    return_reason
)
SELECT
    LTRIM(RTRIM(return_id)),
    LTRIM(RTRIM(sale_item_id)),
    LTRIM(RTRIM(sale_id)),
    LTRIM(RTRIM(store_id)),
    LTRIM(RTRIM(product_id)),
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(return_date)), ''), 23),
    CAST(NULLIF(LTRIM(RTRIM(quantity)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(return_value_aed)), '') AS DECIMAL(18,2)),
    return_reason
FROM dbo.stg_Returns;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Wastage)
INSERT INTO dbo.Wastage (
    wastage_id,
    store_id,
    product_id,
    wastage_date,
    quantity,
    unit_cost_aed,
    reason,
    waste_value_aed
)
SELECT
    LTRIM(RTRIM(wastage_id)),
    LTRIM(RTRIM(store_id)),
    LTRIM(RTRIM(product_id)),
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(wastage_date)), ''), 23),
    CAST(NULLIF(LTRIM(RTRIM(quantity)), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(unit_cost_aed)), '') AS DECIMAL(18,2)),
    reason,
    CAST(NULLIF(LTRIM(RTRIM(waste_value_aed)), '') AS DECIMAL(18,2))
FROM dbo.stg_Wastage;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Targets)
INSERT INTO dbo.Targets (
    target_id,
    store_id,
    month_start,
    sales_target_aed,
    gross_profit_target_aed,
    transaction_target
)
SELECT
    LTRIM(RTRIM(target_id)),
    LTRIM(RTRIM(store_id)),
    CONVERT(DATE, NULLIF(LTRIM(RTRIM(month_start)), ''), 23),
    CAST(NULLIF(LTRIM(RTRIM(sales_target_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(gross_profit_target_aed)), '') AS DECIMAL(18,2)),
    CAST(NULLIF(LTRIM(RTRIM(transaction_target)), '') AS INT)
FROM dbo.stg_Targets;
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Calendar)
INSERT INTO dbo.Calendar (
    [date],
    [year],
    month_no,
    month_name,
    quarter,
    week_no,
    day_name,
    is_weekend,
    year_month
)
SELECT
    CONVERT(DATE, NULLIF(LTRIM(RTRIM([date])), ''), 23),
    CAST(NULLIF(LTRIM(RTRIM([year])), '') AS INT),
    CAST(NULLIF(LTRIM(RTRIM(month_no)), '') AS INT),
    month_name,
    quarter,
    CAST(NULLIF(LTRIM(RTRIM(week_no)), '') AS INT),
    day_name,
    CAST(NULLIF(LTRIM(RTRIM(is_weekend)), '') AS BIT),
    year_month
FROM dbo.stg_Calendar;
GO

SELECT 'Stores' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Stores
UNION ALL
SELECT 'Categories' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Categories
UNION ALL
SELECT 'Suppliers' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Suppliers
UNION ALL
SELECT 'Products' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Products
UNION ALL
SELECT 'Customers' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Customers
UNION ALL
SELECT 'Employees' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Employees
UNION ALL
SELECT 'Promotions' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Promotions
UNION ALL
SELECT 'Sales' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Sales
UNION ALL
SELECT 'Sales_Items' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Sales_Items
UNION ALL
SELECT 'Purchases' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Purchases
UNION ALL
SELECT 'Inventory_Snapshots' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Inventory_Snapshots
UNION ALL
SELECT 'Inventory' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Inventory
UNION ALL
SELECT 'Returns' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Returns
UNION ALL
SELECT 'Wastage' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Wastage
UNION ALL
SELECT 'Targets' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Targets
UNION ALL
SELECT 'Calendar' AS table_name, COUNT_BIG(*) AS row_count FROM dbo.Calendar;
GO

/* Expected major counts from the supplied synthetic dataset:
Stores 8
Categories 18
Suppliers 250
Products 5000
Customers 25000
Promotions 20
Sales 100000
Sales_Items 448094
Purchases 51614
Inventory_Snapshots 480000
Inventory 40000
Returns 7989
Wastage 2048
Targets 96
Calendar 365
*/

EXEC sp_help 'dbo.Sales';
EXEC sp_help 'dbo.Sales_Items';
EXEC sp_help 'dbo.Products';
EXEC sp_help 'dbo.Inventory_Snapshots';

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Stores')
    ALTER TABLE dbo.Stores ADD CONSTRAINT PK_Stores PRIMARY KEY (store_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Categories')
    ALTER TABLE dbo.Categories ADD CONSTRAINT PK_Categories PRIMARY KEY (category_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Suppliers')
    ALTER TABLE dbo.Suppliers ADD CONSTRAINT PK_Suppliers PRIMARY KEY (supplier_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Products')
    ALTER TABLE dbo.Products ADD CONSTRAINT PK_Products PRIMARY KEY (product_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Customers')
    ALTER TABLE dbo.Customers ADD CONSTRAINT PK_Customers PRIMARY KEY (customer_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Employees')
    ALTER TABLE dbo.Employees ADD CONSTRAINT PK_Employees PRIMARY KEY (employee_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Promotions')
    ALTER TABLE dbo.Promotions ADD CONSTRAINT PK_Promotions PRIMARY KEY (promotion_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Sales')
    ALTER TABLE dbo.Sales ADD CONSTRAINT PK_Sales PRIMARY KEY (sale_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Sales_Items')
    ALTER TABLE dbo.Sales_Items ADD CONSTRAINT PK_Sales_Items PRIMARY KEY (sale_item_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Purchases')
    ALTER TABLE dbo.Purchases ADD CONSTRAINT PK_Purchases PRIMARY KEY (purchase_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Inventory_Snapshots')
    ALTER TABLE dbo.Inventory_Snapshots ADD CONSTRAINT PK_Inventory_Snapshots PRIMARY KEY (snapshot_date, store_id, product_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Inventory')
    ALTER TABLE dbo.Inventory ADD CONSTRAINT PK_Inventory PRIMARY KEY (as_of_date, store_id, product_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Returns')
    ALTER TABLE dbo.Returns ADD CONSTRAINT PK_Returns PRIMARY KEY (return_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Wastage')
    ALTER TABLE dbo.Wastage ADD CONSTRAINT PK_Wastage PRIMARY KEY (wastage_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Targets')
    ALTER TABLE dbo.Targets ADD CONSTRAINT PK_Targets PRIMARY KEY (target_id);
IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='PK_Calendar')
    ALTER TABLE dbo.Calendar ADD CONSTRAINT PK_Calendar PRIMARY KEY ([date]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Products_Categories_category_id')
    ALTER TABLE dbo.Products ADD CONSTRAINT FK_Products_Categories_category_id FOREIGN KEY (category_id) REFERENCES dbo.Categories(category_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Products_Suppliers_supplier_id')
    ALTER TABLE dbo.Products ADD CONSTRAINT FK_Products_Suppliers_supplier_id FOREIGN KEY (supplier_id) REFERENCES dbo.Suppliers(supplier_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Employees_Stores_store_id')
    ALTER TABLE dbo.Employees ADD CONSTRAINT FK_Employees_Stores_store_id FOREIGN KEY (store_id) REFERENCES dbo.Stores(store_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Promotions_Categories_category_id')
    ALTER TABLE dbo.Promotions ADD CONSTRAINT FK_Promotions_Categories_category_id FOREIGN KEY (category_id) REFERENCES dbo.Categories(category_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Sales_Stores_store_id')
    ALTER TABLE dbo.Sales ADD CONSTRAINT FK_Sales_Stores_store_id FOREIGN KEY (store_id) REFERENCES dbo.Stores(store_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Sales_Customers_customer_id')
    ALTER TABLE dbo.Sales ADD CONSTRAINT FK_Sales_Customers_customer_id FOREIGN KEY (customer_id) REFERENCES dbo.Customers(customer_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Sales_Items_Sales_sale_id')
    ALTER TABLE dbo.Sales_Items ADD CONSTRAINT FK_Sales_Items_Sales_sale_id FOREIGN KEY (sale_id) REFERENCES dbo.Sales(sale_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Sales_Items_Products_product_id')
    ALTER TABLE dbo.Sales_Items ADD CONSTRAINT FK_Sales_Items_Products_product_id FOREIGN KEY (product_id) REFERENCES dbo.Products(product_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Sales_Items_Promotions_promotion_id')
    ALTER TABLE dbo.Sales_Items ADD CONSTRAINT FK_Sales_Items_Promotions_promotion_id FOREIGN KEY (promotion_id) REFERENCES dbo.Promotions(promotion_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Purchases_Stores_store_id')
    ALTER TABLE dbo.Purchases ADD CONSTRAINT FK_Purchases_Stores_store_id FOREIGN KEY (store_id) REFERENCES dbo.Stores(store_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Purchases_Suppliers_supplier_id')
    ALTER TABLE dbo.Purchases ADD CONSTRAINT FK_Purchases_Suppliers_supplier_id FOREIGN KEY (supplier_id) REFERENCES dbo.Suppliers(supplier_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Purchases_Products_product_id')
    ALTER TABLE dbo.Purchases ADD CONSTRAINT FK_Purchases_Products_product_id FOREIGN KEY (product_id) REFERENCES dbo.Products(product_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Inventory_Snapshots_Stores_store_id')
    ALTER TABLE dbo.Inventory_Snapshots ADD CONSTRAINT FK_Inventory_Snapshots_Stores_store_id FOREIGN KEY (store_id) REFERENCES dbo.Stores(store_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Inventory_Snapshots_Products_product_id')
    ALTER TABLE dbo.Inventory_Snapshots ADD CONSTRAINT FK_Inventory_Snapshots_Products_product_id FOREIGN KEY (product_id) REFERENCES dbo.Products(product_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Inventory_Stores_store_id')
    ALTER TABLE dbo.Inventory ADD CONSTRAINT FK_Inventory_Stores_store_id FOREIGN KEY (store_id) REFERENCES dbo.Stores(store_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Inventory_Products_product_id')
    ALTER TABLE dbo.Inventory ADD CONSTRAINT FK_Inventory_Products_product_id FOREIGN KEY (product_id) REFERENCES dbo.Products(product_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Returns_Sales_Items_sale_item_id')
    ALTER TABLE dbo.Returns ADD CONSTRAINT FK_Returns_Sales_Items_sale_item_id FOREIGN KEY (sale_item_id) REFERENCES dbo.Sales_Items(sale_item_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Returns_Sales_sale_id')
    ALTER TABLE dbo.Returns ADD CONSTRAINT FK_Returns_Sales_sale_id FOREIGN KEY (sale_id) REFERENCES dbo.Sales(sale_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Returns_Stores_store_id')
    ALTER TABLE dbo.Returns ADD CONSTRAINT FK_Returns_Stores_store_id FOREIGN KEY (store_id) REFERENCES dbo.Stores(store_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Returns_Products_product_id')
    ALTER TABLE dbo.Returns ADD CONSTRAINT FK_Returns_Products_product_id FOREIGN KEY (product_id) REFERENCES dbo.Products(product_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Wastage_Stores_store_id')
    ALTER TABLE dbo.Wastage ADD CONSTRAINT FK_Wastage_Stores_store_id FOREIGN KEY (store_id) REFERENCES dbo.Stores(store_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Wastage_Products_product_id')
    ALTER TABLE dbo.Wastage ADD CONSTRAINT FK_Wastage_Products_product_id FOREIGN KEY (product_id) REFERENCES dbo.Products(product_id);
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Targets_Stores_store_id')
    ALTER TABLE dbo.Targets ADD CONSTRAINT FK_Targets_Stores_store_id FOREIGN KEY (store_id) REFERENCES dbo.Stores(store_id);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Sales_SaleDate' AND object_id=OBJECT_ID('dbo.Sales'))
    CREATE INDEX IX_Sales_SaleDate ON dbo.Sales(sale_datetime);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Sales_Store' AND object_id=OBJECT_ID('dbo.Sales'))
    CREATE INDEX IX_Sales_Store ON dbo.Sales(store_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Sales_Customer' AND object_id=OBJECT_ID('dbo.Sales'))
    CREATE INDEX IX_Sales_Customer ON dbo.Sales(customer_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_SalesItems_Sale' AND object_id=OBJECT_ID('dbo.Sales_Items'))
    CREATE INDEX IX_SalesItems_Sale ON dbo.Sales_Items(sale_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_SalesItems_Product' AND object_id=OBJECT_ID('dbo.Sales_Items'))
    CREATE INDEX IX_SalesItems_Product ON dbo.Sales_Items(product_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_InventorySnapshots_Product' AND object_id=OBJECT_ID('dbo.Inventory_Snapshots'))
    CREATE INDEX IX_InventorySnapshots_Product ON dbo.Inventory_Snapshots(product_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_InventorySnapshots_Store' AND object_id=OBJECT_ID('dbo.Inventory_Snapshots'))
    CREATE INDEX IX_InventorySnapshots_Store ON dbo.Inventory_Snapshots(store_id);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Purchases_Date' AND object_id=OBJECT_ID('dbo.Purchases'))
    CREATE INDEX IX_Purchases_Date ON dbo.Purchases(purchase_date);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Wastage_Date' AND object_id=OBJECT_ID('dbo.Wastage'))
    CREATE INDEX IX_Wastage_Date ON dbo.Wastage(wastage_date);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Returns_Date' AND object_id=OBJECT_ID('dbo.Returns'))
    CREATE INDEX IX_Returns_Date ON dbo.Returns(return_date);
GO

EXEC sp_help 'dbo.Sales';
GO
SELECT TOP 10 * FROM dbo.Sales ORDER BY sale_datetime;
GO
SELECT
    COUNT_BIG(*) AS transactions,
    SUM(net_sales_aed) AS revenue_aed,
    SUM(gross_profit_aed) AS gross_profit_aed,
    SUM(basket_units) AS units_sold
FROM dbo.Sales;
GO

