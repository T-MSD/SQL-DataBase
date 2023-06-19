DROP TABLE IF EXISTS contains;
DROP TABLE IF EXISTS delivery;
DROP TABLE IF EXISTS places;
DROP TABLE IF EXISTS works;
DROP TABLE IF EXISTS pay;
DROP TABLE IF EXISTS process;
DROP TABLE IF EXISTS warehouse;
DROP TABLE IF EXISTS office;
DROP TABLE IF EXISTS workplace;
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS sale;
DROP TABLE IF EXISTS supply_contract;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS ean_product;
DROP TABLE IF EXISTS "order";
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS customer;

-- Customers can only pay for the Sale of an Order they have placed themselves
CREATE TABLE customer (
  cust_no INT NOT NULL PRIMARY KEY,
  customer_name VARCHAR NOT NULL,
  email VARCHAR NOT NULL UNIQUE,
  phone INT NOT NULL,
  customer_address VARCHAR NOT NULL
);

CREATE TABLE product (
  sku INT NOT NULL PRIMARY KEY,
  product_name VARCHAR NOT NULL,
  price INT NOT NULL,
  product_description VARCHAR NOT NULL
);

CREATE TABLE "order"(
  order_no INT NOT NULL PRIMARY KEY,
  order_date DATE NOT NULL,
  cust_no INT NOT NULL,
  FOREIGN KEY (cust_no) REFERENCES customer(cust_no)
);

CREATE TABLE ean_product (
  ean INT NOT NULL,
  sku INT NOT NULL,
  FOREIGN KEY (sku) REFERENCES product(sku)
);

CREATE TABLE supplier (
  TIN INT NOT NULL PRIMARY KEY,
  supplier_name VARCHAR NOT NULL,
  supplier_address VARCHAR NOT NULL
);

CREATE TABLE supply_contract (
  sku INT NOT NULL,
  contract_date DATE NOT NULL,
  TIN INT NOT NULL,
  FOREIGN KEY (TIN) REFERENCES supplier(TIN),
  FOREIGN KEY (sku) REFERENCES product(sku)
);

CREATE TABLE sale (
  order_no INT NOT NULL,
  FOREIGN KEY (order_no) REFERENCES "order"(order_no)
);

CREATE TABLE employee (
  ssn INT NOT NULL PRIMARY KEY,
  TIN INT NOT NULL UNIQUE,
  bdate DATE NOT NULL,
  employee_name VARCHAR NOT NULL
);

CREATE TABLE department (
  department_name VARCHAR NOT NULL PRIMARY KEY
);

-- (lat, long) pairs are unique
CREATE TABLE workplace (
  workplace_address VARCHAR NOT NULL PRIMARY KEY,
  workplace_type VARCHAR NOT NULL,
  lat DECIMAL NOT NULL,
  long DECIMAL NOT NULL
);

CREATE TABLE office (
  office_address VARCHAR NOT NULL,
  FOREIGN KEY (office_address) REFERENCES workplace(workplace_address)
);

CREATE TABLE warehouse (
  warehouse_address VARCHAR NOT NULL,
  FOREIGN KEY (warehouse_address) REFERENCES workplace(workplace_address)
);

CREATE TABLE contains (
  order_no INT NOT NULL,
  quantity INT NOT NULL,
  sku INT NOT NULL,
  FOREIGN KEY (order_no) REFERENCES "order"(order_no),
  FOREIGN KEY (sku) REFERENCES product(sku)
);

CREATE TABLE process (
  ssn INT NOT NULL,
  order_no INT NOT NULL,
  FOREIGN KEY (ssn) REFERENCES employee(ssn),
  FOREIGN KEY (order_no) REFERENCES "order"(order_no)
);

CREATE TABLE pay (
  cust_no INT NOT NULL,
  order_no INT NOT NULL,
  FOREIGN KEY (cust_no) REFERENCES customer(cust_no),
  FOREIGN KEY (order_no) REFERENCES "order"(order_no)
);

CREATE TABLE works (
  department_name VARCHAR NOT NULL,
  ssn INT NOT NULL,
  workplace_address VARCHAR NOT NULL,
  FOREIGN KEY (department_name) REFERENCES department(department_name),
  FOREIGN KEY (ssn) REFERENCES employee(ssn),
  FOREIGN KEY (workplace_address) REFERENCES workplace(workplace_address)
);

CREATE TABLE places (
  cust_no INT NOT NULL,
  order_no INT NOT NULL,
  FOREIGN KEY (cust_no) REFERENCES customer(cust_no),
  FOREIGN KEY (order_no) REFERENCES "order"(order_no)
);

CREATE TABLE delivery (
  warehouse_address VARCHAR NOT NULL,
  sku INT NOT NULL,
  TIN INT NOT NULL,
  FOREIGN KEY (warehouse_address) REFERENCES warehouse(warehouse_address),
  FOREIGN KEY (sku) REFERENCES supply_contract(sku),
  FOREIGN KEY (TIN) REFERENCES supply_contract(TIN)
);
