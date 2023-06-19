DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS "order" CASCADE;
DROP TABLE IF EXISTS pay CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS "process" CASCADE;
DROP TABLE IF EXISTS department CASCADE;
DROP TABLE IF EXISTS workplace CASCADE;
DROP TABLE IF EXISTS works CASCADE;
DROP TABLE IF EXISTS office CASCADE;
DROP TABLE IF EXISTS warehouse CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS contains CASCADE;
DROP TABLE IF EXISTS supplier CASCADE;
DROP TABLE IF EXISTS delivery CASCADE;

CREATE TABLE customer (
  cust_no INTEGER PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  email VARCHAR(254) UNIQUE NOT NULL,
  phone VARCHAR(15),
  address VARCHAR(255)
);

CREATE TABLE "order" (
  order_no INTEGER PRIMARY KEY,
  cust_no INTEGER NOT NULL REFERENCES customer,
  date DATE NOT NULL
);

CREATE TABLE pay (
  order_no INTEGER PRIMARY KEY REFERENCES "order",
  cust_no INTEGER NOT NULL REFERENCES customer
);

CREATE TABLE employee (
  ssn VARCHAR(20) PRIMARY KEY,
  TIN VARCHAR(20) UNIQUE NOT NULL,
  bdate DATE,
  name VARCHAR NOT NULL
);

CREATE TABLE "process" (
  ssn VARCHAR(20) REFERENCES employee,
  order_no INTEGER REFERENCES "order",
  PRIMARY KEY (ssn, order_no)
);

CREATE TABLE department (
  name VARCHAR PRIMARY KEY
);

CREATE TABLE workplace (
  address VARCHAR PRIMARY KEY,
  lat NUMERIC(8, 6) NOT NULL,
  "long" NUMERIC(9, 6) NOT NULL,
  UNIQUE(lat, "long")
);

CREATE TABLE office (
  address VARCHAR(255) PRIMARY KEY REFERENCES workplace(address)
);

CREATE TABLE warehouse (
  address VARCHAR(255) PRIMARY KEY REFERENCES workplace(address)
);

CREATE TABLE works (
  ssn VARCHAR(20) REFERENCES employee(ssn),
  name VARCHAR(200) REFERENCES department(name),
  address VARCHAR(255) REFERENCES workplace(address),
  PRIMARY KEY (ssn, name, address)
);

CREATE TABLE product (
  SKU VARCHAR(25) PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  description VARCHAR,
  price NUMERIC(10, 2) NOT NULL,
  ean NUMERIC(13) UNIQUE
);

CREATE TABLE contains (
  order_no INTEGER REFERENCES "order",
  SKU VARCHAR(25) REFERENCES product(SKU),
  qty INTEGER,
  PRIMARY KEY (order_no, SKU)
);

CREATE TABLE supplier (
  TIN VARCHAR(20) PRIMARY KEY,
  name VARCHAR(200),
  address VARCHAR(255),
  SKU VARCHAR(25) REFERENCES product(SKU),
  date DATE
);

CREATE TABLE delivery (
  address VARCHAR(255) REFERENCES warehouse(address),
  TIN VARCHAR(20) REFERENCES supplier(TIN),
  PRIMARY KEY (address, TIN)
);


INSERT INTO customer (cust_no, name, email, phone, address)
VALUES (1, 'João', 'joao@gmail.pt', 969876547, 'Avenida da Republica nº27 1000-127 Lisboa');

INSERT INTO customer (cust_no, name, email, phone, address)
VALUES (2, 'Miguel', 'miguel@gmail.pt', 963454567, 'Avenida da Republica nº26 1000-125 Lisboa');

INSERT INTO customer (cust_no, name, email, phone, address)
VALUES (3, 'Pedro', 'pedro@gmail.pt', 963456789, 'Avenida da Republica nº25 1000-124 Lisboa');

INSERT INTO customer (cust_no, name, email, phone, address)
VALUES (4, 'João', 'joao123@gmail.pt', 969876546, 'Avenida da Republica nº28 1000-123 Lisboa');

INSERT INTO customer (cust_no, name, email, phone, address)
VALUES (5, 'João', 'joao312@gmail.pt', 969876544, 'Avenida da Republica nº29 1000-121 Lisboa');

INSERT INTO "order" (order_no, cust_no, date)
VALUES (1, 1, '2019-01-01');

INSERT INTO "order" (order_no, cust_no, date)
VALUES (2, 2, '2019-01-02');

INSERT INTO "order" (order_no, cust_no, date)
VALUES (3, 3, '2019-01-03');

INSERT INTO "order" (order_no, cust_no, date)
VALUES (4, 4, '2019-01-04');

INSERT INTO "order" (order_no, cust_no, date)
VALUES (5, 5, '2019-01-05');

INSERT INTO pay (order_no, cust_no)
VALUES (1, 1);

INSERT INTO pay (order_no, cust_no)
VALUES (4, 4);

INSERT INTO workplace (address, lat, "long")
VALUES ('Avenida da Republica nº27 1000-127 Lisboa', 38.736946, -9.139337);

INSERT INTO workplace (address, lat, "long")
VALUES ('Avenida da Republica nº26 1000-125 Lisboa', 40.736765, -13.135437);

INSERT INTO workplace (address, lat, "long")
VALUES ('Avenida da Republica nº25 1000-124 Lisboa', 65.736946, -14.543337);

INSERT INTO workplace (address, lat, "long")
VALUES ('Avenida da Republica nº28 1000-123 Lisboa', 87.776946, -16.137337);

INSERT INTO workplace (address, lat, "long")
VALUES ('Avenida da Republica nº29 1000-121 Lisboa', 11.736846, -19.133337);

INSERT INTO warehouse (address)
VALUES ('Avenida da Republica nº27 1000-127 Lisboa');

INSERT INTO warehouse (address)
VALUES ('Avenida da Republica nº26 1000-125 Lisboa');

INSERT INTO warehouse (address)
VALUES ('Avenida da Republica nº25 1000-124 Lisboa');

INSERT INTO warehouse (address)
VALUES ('Avenida da Republica nº28 1000-123 Lisboa');

INSERT INTO warehouse (address)
VALUES ('Avenida da Republica nº29 1000-121 Lisboa');

INSERT INTO office (address)
VALUES ('Avenida da Republica nº27 1000-127 Lisboa');

INSERT INTO office (address)
VALUES ('Avenida da Republica nº26 1000-125 Lisboa');

INSERT INTO office (address)
VALUES ('Avenida da Republica nº25 1000-124 Lisboa');

INSERT INTO office (address)
VALUES ('Avenida da Republica nº28 1000-123 Lisboa');

INSERT INTO office (address)
VALUES ('Avenida da Republica nº29 1000-121 Lisboa');

INSERT INTO employee (ssn, TIN, bdate, name)
VALUES ('123456789', '123456789', '1990-01-01', 'João');

INSERT INTO employee (ssn, TIN, bdate, name)
VALUES ('123456788', '123456788', '1990-01-02', 'Miguel');

INSERT INTO employee (ssn, TIN, bdate, name)
VALUES ('123456787', '123456787', '1990-01-03', 'Pedro');

INSERT INTO employee (ssn, TIN, bdate, name)
VALUES ('123456786', '123456786', '1990-01-04', 'João');

INSERT INTO employee (ssn, TIN, bdate, name)
VALUES ('123456785', '123456785', '1990-01-05', 'João');

INSERT INTO department (name)
VALUES ('IT');

INSERT INTO department (name)
VALUES ('Marketing');

INSERT INTO department (name)
VALUES ('Sales');

INSERT INTO department (name)
VALUES ('HR');

INSERT INTO department (name)
VALUES ('Finance');

INSERT INTO works (ssn, name, address)
VALUES ('123456789', 'IT', 'Avenida da Republica nº27 1000-127 Lisboa');

INSERT INTO works (ssn, name, address)
VALUES ('123456788', 'Marketing', 'Avenida da Republica nº26 1000-125 Lisboa');

INSERT INTO works (ssn, name, address)
VALUES ('123456787', 'Sales', 'Avenida da Republica nº25 1000-124 Lisboa');

INSERT INTO works (ssn, name, address)
VALUES ('123456786', 'HR', 'Avenida da Republica nº28 1000-123 Lisboa');

INSERT INTO works (ssn, name, address)
VALUES ('123456785', 'Finance', 'Avenida da Republica nº29 1000-121 Lisboa');

INSERT INTO product (SKU, name, description, price, ean)
VALUES ('123456789', 'Cadeira', 'Cadeira de escritório', 50.00, 1234567890123);

INSERT INTO product (SKU, name, description, price, ean)
VALUES ('123456788', 'Mesa', 'Mesa de escritório', 100.00, 1234567890124);

INSERT INTO product (SKU, name, description, price, ean)
VALUES ('123456787', 'Computador', 'Computador de escritório', 500.00, 1234567890125);

INSERT INTO product (SKU, name, description, price, ean)
VALUES ('123456786', 'Teclado', 'Teclado de escritório', 10.00, 1234567890126);

INSERT INTO product (SKU, name, description, price, ean)
VALUES ('123456785', 'Rato', 'Rato de escritório', 5.00, 1234567890127);

INSERT INTO "process" (ssn, order_no)
VALUES (123456789, 1);

INSERT INTO "process" (ssn, order_no)
VALUES (123456788, 2);

INSERT INTO "process" (ssn, order_no)
VALUES (123456787, 3);

INSERT INTO "process" (ssn, order_no)
VALUES (123456786, 4);

INSERT INTO "process" (ssn, order_no)
VALUES (123456785, 5);

INSERT INTO supplier (TIN, name, address, SKU, DATE)
VALUES (1, 'Fornecedor 1', 'Avenida da Republica nº29 1000-121 Lisboa', 123456789, '2019-01-01');

INSERT INTO supplier (TIN, name, address, SKU, DATE)
VALUES (2, 'Fornecedor 2', 'Avenida da Republica nº29 1000-121 Lisboa', 123456788, '2019-01-02');

INSERT INTO supplier (TIN, name, address, SKU, DATE)
VALUES (3, 'Fornecedor 3', 'Avenida da Republica nº29 1000-121 Lisboa', 123456787, '2019-01-03');

INSERT INTO supplier (TIN, name, address, SKU, DATE)
VALUES (4, 'Fornecedor 4', 'Avenida da Republica nº29 1000-121 Lisboa', 123456786, '2019-01-04');

INSERT INTO supplier (TIN, name, address, SKU, DATE)
VALUES (5, 'Fornecedor 5', 'Avenida da Republica nº29 1000-121 Lisboa', 123456785, '2019-01-05');

INSERT INTO delivery (TIN, address)
VALUES (1, 'Avenida da Republica nº27 1000-127 Lisboa');

INSERT INTO delivery (TIN, address)
VALUES (2, 'Avenida da Republica nº26 1000-125 Lisboa');

INSERT INTO delivery (TIN, address)
VALUES (3, 'Avenida da Republica nº25 1000-124 Lisboa');

INSERT INTO delivery (TIN, address)
VALUES (4, 'Avenida da Republica nº28 1000-123 Lisboa');

INSERT INTO delivery (TIN, address)
VALUES (5, 'Avenida da Republica nº29 1000-121 Lisboa');

INSERT INTO contains (order_no, SKU, qty)
VALUES (1, '123456789', 1);

INSERT INTO contains (order_no, SKU, qty)
VALUES (2, '123456788', 2);

INSERT INTO contains (order_no, SKU, qty)
VALUES (3, '123456787', 3);

INSERT INTO contains (order_no, SKU, qty)
VALUES (4, '123456786', 4);

INSERT INTO contains (order_no, SKU, qty)
VALUES (5, '123456785', 5);




