-- 1.
SELECT cust_no, customer.name
FROM customer 
NATURAL JOIN pay 
NATURAL JOIN contains 
JOIN product p on p.sku = contains.sku
WHERE cust_no = customer.cust_no
GROUP BY cust_no, customer.name
HAVING SUM(price * qty) >= ALL (
  SELECT SUM(price * qty)
  FROM pay NATURAL JOIN product NATURAL JOIN contains
  GROUP BY cust_no
);

-- 2. 
SELECT e.name
FROM employee e
INNER JOIN process p ON p.ssn = e.ssn
INNER JOIN "order" o ON o.order_no = p.order_no
WHERE o.date >= '2022-01-01' AND o.date <= '2022-12-31'
GROUP BY e.name
HAVING COUNT(DISTINCT o.date) = (
  SELECT COUNT(DISTINCT o2.date) 
  FROM "order" o2 
  WHERE o2.date >= '2022-01-01' AND o2.date <= '2022-12-31'
);

-- 3. 
SELECT EXTRACT(MONTH FROM o.date) AS month, COUNT(*)
FROM "order" o
LEFT JOIN pay p ON o.order_no = p.order_no
WHERE o.date >= '2022-01-01' AND o.date <= '2022-12-31' AND p.order_no IS NULL
GROUP BY month
ORDER BY month;