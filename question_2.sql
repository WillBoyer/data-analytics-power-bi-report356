-- Which month in 2022 has had the highest revenue?

SELECT SUBSTRING(o."Order Date" FROM 0 FOR 8) AS order_month, SUM(p.sale_price * o."Product Quantity") AS revenue
FROM orders_powerbi AS o
INNER JOIN dim_products AS p ON o.product_code = p.product_code
WHERE o."Order Date" LIKE '2022-%'
GROUP BY order_month
ORDER BY revenue DESC LIMIT 1
