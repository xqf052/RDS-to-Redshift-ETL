-- Load data into mysql database
LOAD DATA LOCAL INFILE 'local_path/orders.csv' 
INTO TABLE orders_raw FIELDS TERMINATED BY ','
ENCLOSED BY '"' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'local_path/order_items.csv' 
INTO TABLE order_items_raw FIELDS TERMINATED BY ','
ENCLOSED BY '"' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'local_path/products.csv' 
INTO TABLE products_raw FIELDS TERMINATED BY ','
ENCLOSED BY '"' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'local_path/customers.csv' 
INTO TABLE customers_raw FIELDS TERMINATED BY ','
ENCLOSED BY '"' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'local_path/order_payments.csv' 
INTO TABLE raw_order_payments FIELDS TERMINATED BY ','
ENCLOSED BY '"' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'local_path/sellers.csv' 
INTO TABLE raw_sellers FIELDS TERMINATED BY ','
ENCLOSED BY '"' IGNORE 1 LINES;