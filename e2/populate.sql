
INSERT INTO customer (cust_no, customer_name, email, phone, customer_address)
VALUES (1, 'João', 'joao@gmail.pt', 969876543, 'Avenida da Republica nº27');

INSERT INTO customer (cust_no, customer_name, email, phone, customer_address)
VALUES (2, 'Miguel', 'miguel@gmail.pt', 963454567, 'Avenida da Republica nº26');

INSERT INTO customer (cust_no, customer_name, email, phone, customer_address)
VALUES (3, 'Pedro', 'pedro@gmail.pt', 963456789, 'Avenida da Republica nº25');


INSERT INTO product (sku, product_name, price, product_description)
VALUES (1001, 'Cookies', 10, 'Chocolate');

INSERT INTO product (sku, product_name, price, product_description)
VALUES (1002, 'Ice cream', 75, 'Baunilha');

INSERT INTO product (sku, product_name, price, product_description)
VALUES (1003, 'Cake', 125, 'Morango');


INSERT INTO "order" (order_no, order_date, cust_no)
VALUES (1, '2023-01-01', 1);

INSERT INTO "order" (order_no, order_date, cust_no)
VALUES (2, '2022-08-17', 2);

INSERT INTO "order" (order_no, order_date, cust_no)
VALUES (3, '2023-10-15', 3);


INSERT INTO ean_product (ean, sku)
VALUES (1234567890123, 1001);

INSERT INTO ean_product (ean, sku)
VALUES (1234567890654, 1002);

INSERT INTO ean_product (ean, sku)
VALUES (1234567890876, 1003);


INSERT INTO supplier (TIN, supplier_name, supplier_address)
VALUES (123456789, 'Continente', 'Avenida da Liberdade nº12');


INSERT INTO supply_contract (sku, contract_date, TIN)
VALUES (1001, '2023-01-01', 123456789);

INSERT INTO supply_contract (sku, contract_date, TIN)
VALUES (1002, '2022-08-17', 123456987);

INSERT INTO supply_contract (sku, contract_date, TIN)
VALUES (1003, '2023-10-15', 123456321);


INSERT INTO sale (order_no)
VALUES (1);

INSERT INTO sale (order_no)
VALUES (2);

INSERT INTO sale (order_no)
VALUES (3);


INSERT INTO employee (ssn, TIN, bdate, employee_name)
VALUES (1, 123456789, '2003-01-01', 'André');

INSERT INTO employee (ssn, TIN, bdate, employee_name)
VALUES (2, 123456987, '2003-03-23', 'Paulo');


INSERT INTO department (department_name)
VALUES ('Marketing');


INSERT INTO workplace (workplace_address, workplace_type, lat, long)
VALUES ('Almirante Reis nª48', 'office', 12.345, -67.890);

INSERT INTO workplace (workplace_address, workplace_type, lat, long)
VALUES ('Rua Augusta nº51', "warehouse", 12.345, 67.890);


INSERT INTO works(workplace_address, ssn, department_name)
VALUES ('Almirante Reis nª48', 1, 'Marketing');

INSERT INTO works(workplace_address, ssn, department_name)
VALUES ('Rua Augusta nº51', 2, 'Marketing');


INSERT INTO office (office_address)
VALUES ('Almirante Reis nª48');


INSERT INTO warehouse (warehouse_address)
VALUES ('Rua Augusta nº51');


INSERT INTO contains (order_no, quantity, sku)
VALUES (1, 5, 1001);

INSERT INTO contains (order_no, quantity, sku)
VALUES (2, 3, 1002);

INSERT INTO contains (order_no, quantity, sku)
VALUES (3, 2, 1003);


INSERT INTO process(ssn, order_no)
VALUES (2, 1);