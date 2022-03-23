-- create raw_orders to load the orders.csv
CREATE TABLE `raw_orders` (
  `order_id` varchar(32) NOT NULL,
  `customer_id` varchar(32) NOT NULL,
  `order_status` varchar(9) NOT NULL,
  `order_purchase_timestamp` timestamp(6) NULL DEFAULT NULL,
  `order_approved_at` timestamp(6) NULL DEFAULT NULL,
  `order_delivered_carrier_date` timestamp(6) NULL DEFAULT NULL,
  `order_delivered_customer_date` timestamp(6) NULL DEFAULT NULL,
  `order_estimated_delivery_date` timestamp(6) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- create raw_order_items to load the order_items.csv
CREATE TABLE `raw_order_items` (
  `order_id` varchar(32) NOT NULL,
  `order_item_id` decimal(10,0) NOT NULL,
  `product_id` varchar(32) NOT NULL,
  `seller_id` varchar(32) NOT NULL,
  `shipping_limit_date` timestamp(6) NULL DEFAULT NULL,
  `price` decimal(10,0) NOT NULL,
  `freight_value` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- create raw_products to load the products.csv
CREATE TABLE `raw_products` (
  `product_id` varchar(32) NOT NULL,
  `product_category_name` varchar(46) Null DEFAULT Null,
  `product_name_lenght` decimal(10,0) NULL DEFAULT NULL,
  `product_description_lenght` decimal(10,0) NULL DEFAULT NULL,
  `product_photos_qty` decimal(10,0) NULL DEFAULT NULL,
  `product_weight_g` decimal(10,0) NULL DEFAULT NULL,
  `product_length_cm` decimal(10,0) NULL DEFAULT NULL,
  `product_height_cm` decimal(10,0) NULL DEFAULT NULL,
  `product_width_cm` decimal(10,0) NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- create raw_customers to load the customers.csv
CREATE TABLE `raw_customers` (
  `customer_id` varchar(32) NOT NULL,
  `customer_unique_id` varchar(32) NOT NULL,
  `customer_zip_code_prefix` decimal(10,0) NOT NULL,
  `customer_city` varchar(27) NOT NULL,
  `customer_state` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- create raw_order_payments to load the order_payments.csv
CREATE TABLE `raw_order_payments` (
  `order_id` varchar(32) NOT NULL,
  `payment_sequential` decimal(10,0) NOT NULL,
  `payment_type` varchar(11) NOT NULL,
  `payment_installments` decimal(10,0) NOT NULL,
  `payment_value` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- create raw_sellers to load the sellers.csv
CREATE TABLE `raw_sellers` (
  `seller_id` varchar(32) NOT NULL,
  `seller_zip_code_prefix` decimal(10,0) NOT NULL,
  `seller_city` varchar(40) NOT NULL,
  `seller_state` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
