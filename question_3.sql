-- Which German store type had the highest revenue for 2022?

SELECT store_type, SUM(p.sale_price * o."Product Quantity") AS revenue
FROM dim_stores AS s
INNER JOIN orders_powerbi AS o ON s."store code" = o."Store Code"
INNER JOIN dim_products AS p ON o.product_code = p.product_code
WHERE country_code = 'DE'
GROUP BY store_type
ORDER BY revenue DESC LIMIT 1