-- Which product category generated the most profit for the "Wiltshire, UK" region in 2021?

SELECT category, SUM(p.sale_price * o."Product Quantity") AS revenue
FROM dim_products as p
INNER JOIN orders_powerbi AS o ON p.product_code = o.product_code
INNER JOIN dim_stores AS s ON o."Store Code" = s."store code"
WHERE country_code = 'UK' AND country_region = 'Wiltshire' AND "Order Date" LIKE '2021-%'
GROUP BY category
ORDER BY revenue DESC LIMIT 1