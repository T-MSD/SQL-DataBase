
--6.1--

SELECT sku, city, "month", day_of_month, day_of_week, SUM(qty) AS total_qty, SUM(total_price) AS total_sales
FROM product_sales
WHERE "year" = 2022
GROUP BY ROLLUP(sku, city, "month", day_of_month, day_of_week);

--6.2--

SELECT "month", day_of_week, AVG(total_price) AS average_sales
FROM product_sales
WHERE "year" = 2022
GROUP BY "month", day_of_week;

