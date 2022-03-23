CREATE SCHEMA staging_layer;
CREATE SCHEMA user_access_layer;

-- Create delta tables
CREATE TABLE staging_layer.delta_all(
	order_id varchar(32) NOT NULL,
	customer_id varchar(32) NOT NULL,
	order_purchase_timestamp timestamp NULL DEFAULT NULL,
	order_estimated_delivery_date timestamp NULL DEFAULT NULL,
	order_status varchar(9) NOT NULL,
	payment_value decimal(10,0) NULL,
	customer_zip_code_prefix decimal(10,0) NOT NULL,
	customer_city varchar(27) NOT NULL,
	customer_state varchar(2) NOT NULL,
	product_id varchar(32) NOT NULL,
  	seller_id varchar(32) NOT NULL,
  	price decimal(10,0) NOT NULL,
  	freight_value decimal(10,0) NOT NULL,
  	product_category_name varchar(46) Null DEFAULT Null,
  	product_weight_g decimal(10,0) NULL DEFAULT NULL,
 	product_length_cm decimal(10,0) NULL DEFAULT NULL,
 	product_height_cm decimal(10,0) NULL DEFAULT NULL,
  	product_width_cm decimal(10,0) NULL DEFAULT null,
  	seller_zip_code_prefix decimal(10,0) NOT NULL,
  	seller_city varchar(40) NOT NULL,
  	seller_state varchar(2) NOT NULL
);

CREATE TABLE staging_layer.delta_customers (
	customer_id varchar(32) NOT NULL,
	customer_zip_code_prefix decimal(10,0) NOT NULL,
	customer_city varchar(27) NOT NULL,
	customer_state varchar(2) NOT NULL
);

CREATE TABLE staging_layer.delta_date (
	datetime varchar(12) NULL DEFAULT NULL,
	year_num varchar(4) NULL DEFAULT NULL,
	month_num varchar(2) NULL DEFAULT NULL,
	day_of_month varchar(2) NULL DEFAULT NULL,
	time_of_day varchar(8) NULL DEFAULT NULL
);

CREATE TABLE staging_layer.delta_orders (
	order_id varchar(32) NOT NULL,
	order_status varchar(9) NOT NULL
);

CREATE TABLE staging_layer.delta_products (
	product_id varchar(32) NOT NULL,
	product_category_name varchar(46) Null DEFAULT Null,
  	product_weight_g decimal(10,0) NULL DEFAULT NULL,
 	product_length_cm decimal(10,0) NULL DEFAULT NULL,
 	product_height_cm decimal(10,0) NULL DEFAULT NULL,
  	product_width_cm decimal(10,0) NULL DEFAULT null
);

CREATE TABLE staging_layer.delta_sellers (
	seller_id varchar(32) NOT NULL,
	seller_zip_code_prefix decimal(10,0) NOT NULL,
  	seller_city varchar(40) NOT NULL,
  	seller_state varchar(2) NOT NULL
);

-- Create dimension tables
CREATE TABLE user_access_layer.dim_customers (
	customers_skey int identity(0,1),
	customer_id varchar(32) NOT NULL,
	customer_zip_code_prefix decimal(10,0) NOT NULL,
	customer_city varchar(27) NOT NULL,
	customer_state varchar(2) NOT NULL
);

CREATE TABLE user_access_layer.dim_date (
	datetime_skey varchar(12) NULL DEFAULT NULL,
	year_num varchar(4) NULL DEFAULT NULL,
	month_num varchar(2) NULL DEFAULT NULL,
	day_of_month varchar(2) NULL DEFAULT NULL,
	time_of_day varchar(8) NULL DEFAULT NULL
);

CREATE TABLE user_access_layer.dim_orders (
	orders_skey int identity(0,1),
	order_id varchar(32) NOT NULL,
	order_status varchar(9) NOT NULL
);

CREATE TABLE user_access_layer.dim_products (
	products_skey int identity(0,1),
	product_id varchar(32) NOT NULL,
	product_category_name varchar(46) Null DEFAULT Null,
  	product_weight_g decimal(10,0) NULL DEFAULT NULL,
 	product_length_cm decimal(10,0) NULL DEFAULT NULL,
 	product_height_cm decimal(10,0) NULL DEFAULT NULL,
  	product_width_cm decimal(10,0) NULL DEFAULT null
);

CREATE TABLE user_access_layer.dim_sellers (
	sellers_skey int identity(0,1),
	seller_id varchar(32) NOT NULL,
	seller_zip_code_prefix decimal(10,0) NOT NULL,
  	seller_city varchar(40) NOT NULL,
  	seller_state varchar(2) NOT NULL
);

-- Create fact table
CREATE TABLE user_access_layer.fact_payments (
	orders_skey int NOT NULL,
	customers_skey int NOT NULL,
	order_purchase_datetime varchar(12) NOT NULL,
	estimated_delivery_datetime varchar(12) NOT NULL,
	payment_value decimal(10,0) NULL
);

CREATE TABLE user_access_layer.fact_orders (
	orders_skey int NOT NULL,
	products_skey int NOT NULL,
	sellers_skey int NOT NULL,
	price decimal(10,0) NOT NULL,
  	freight_value decimal(10,0) NOT NULL
);