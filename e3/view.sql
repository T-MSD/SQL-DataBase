 DROP VIEW IF EXISTS product_sales;

 CREATE VIEW product_sales(sku, order_no, qty, total_price, "year", "month", day_of_month, day_of_week, city) AS 
 SELECT
       SKU,
       o.order_no,
       ct.qty,
       ct.qty * p.price AS total_price,
       EXTRACT(YEAR FROM o.date) AS "year",
       EXTRACT(MONTH FROM o.date) AS "month",
       EXTRACT(DAY FROM o.date) AS day_of_month,
       EXTRACT(DOW FROM o.date) AS day_of_week,
       SUBSTRING_INDEX(c.address, ',', -1) AS city
FROM contains ct
JOIN "order" o ON ct.order_no = o.order_no
JOIN customer c ON o.cust_no = c.cust_no
JOIN product p ON ct.SKU = p.SKU
JOIN pay py ON o.order_no = py.order_no;

