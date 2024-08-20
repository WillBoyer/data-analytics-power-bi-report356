-- Create a view where the rows are the store types and the columns are the total sales, percentage of total sales and the count of orders

CREATE OR REPLACE VIEW store_sales AS
SELECT
    s.store_type,
    SUM(p.sale_price * o."Product Quantity") AS total_sales,
    SUM(p.sale_price * o."Product Quantity") * 100.00 / SUM(SUM(p.sale_price * o."Product Quantity")) OVER () AS pct_total_sales,
    COUNT(o) AS orders_ct
FROM
    dim_stores AS s
INNER JOIN
    orders_powerbi AS o ON s."store code" = o."Store Code"
INNER JOIN
    dim_products AS p ON o.product_code = p.product_code
GROUP BY
    store_type
ORDER BY total_sales DESC