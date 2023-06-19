-- 1. Liste o nome de todos os clientes que fizeram encomendas contendo produtos de preço superior a €50 no ano de 2023.
SELECT customer_name
FROM customer
JOIN "order" ON customer.cust_no = "order".cust_no
JOIN contains ON "order".order_no = contains.order_no
JOIN product ON contains.sku = product.sku
WHERE product.price > 50
  AND "order".order_date >= '2023-01-01'
  AND "order".order_date <= '2023-12-31';


-- 2. Liste o nome de todos os empregados que trabalham em armazéns e não em escritórios e processaram encomendas em Janeiro de 2023.
SELECT employee_name
FROM employee
JOIN works ON employee.ssn = works.ssn
JOIN workplace ON works.workplace_address = workplace.workplace_address
JOIN process ON employee.ssn = process.ssn
JOIN "order" ON process.order_no = "order".order_no
WHERE workplace.workplace_type = 'warehouse'
  AND workplace.workplace_address NOT IN (
    SELECT office_address
    FROM office)
  AND "order".order_date >= '2023-01-01'
  AND "order".order_date <= '2023-01-31';


-- 3. Indique o nome do produto mais vendido.
SELECT product_name 
FROM product 
JOIN contains ON product.sku = contains.sku 
GROUP BY product_name
ORDER BY SUM(contains.quantity) DESC
LIMIT 1;


-- 4. Indique o valor total de cada venda realizada
SELECT "order".order_no, SUM(product.price * contains.quantity) AS total_value
FROM "order"
JOIN contains ON "order".order_no = contains.order_no
JOIN product ON contains.sku = product.sku
GROUP BY "order".order_no;

