-- copy data from S3 into delta_all
COPY staging_layer.delta_all FROM FROM 'S3 file path/historical_data.csv'
iam_role 'redshift IAM Role ARN'
CSV QUOTE '\"' DELIMITER ','
acceptinvchars;

-- populate delta tables in dwh
INSERT INTO staging_layer.delta_customers
SELECT customer_id, customer_zip_code_prefix, customer_city, customer_state
FROM staging_layer.delta_all
GROUP BY customer_id, customer_zip_code_prefix, customer_city, customer_state
ORDER BY customer_id, customer_zip_code_prefix, customer_city, customer_state;

INSERT INTO staging_layer.delta_date
SELECT TO_CHAR(order_purchase_timestamp,'YYYYMMDDHH24MI'), TO_CHAR(order_purchase_timestamp, 'YYYY'), TO_CHAR(order_purchase_timestamp, 'MM'), 
TO_CHAR(order_purchase_timestamp, 'DD'), TO_CHAR(order_purchase_timestamp, 'HH24:MI:SS')
FROM staging_layer.delta_all
GROUP BY order_purchase_timestamp ORDER BY order_purchase_timestamp;

INSERT INTO staging_layer.delta_date
SELECT TO_CHAR(order_estimated_delivery_date,'YYYYMMDDHH24MI'), TO_CHAR(order_estimated_delivery_date, 'YYYY'), TO_CHAR(order_estimated_delivery_date, 'MM'), 
TO_CHAR(order_estimated_delivery_date, 'DD'), TO_CHAR(order_estimated_delivery_date, 'HH24:MI:SS')
FROM staging_layer.delta_all
GROUP BY order_estimated_delivery_date ORDER BY order_estimated_delivery_date;

INSERT INTO staging_layer.delta_orders
SELECT order_id, order_status
FROM staging_layer.delta_all
GROUP BY order_id, order_status
ORDER BY order_id, order_status;

INSERT INTO staging_layer.delta_products
SELECT product_id, product_category_name, product_weight_g,
product_length_cm, product_height_cm, product_width_cm
FROM staging_layer.delta_all
GROUP BY product_id, product_category_name, product_weight_g,
product_length_cm, product_height_cm, product_width_cm
ORDER BY product_id, product_category_name, product_weight_g,
product_length_cm, product_height_cm, product_width_cm;

INSERT INTO staging_layer.delta_sellers
SELECT seller_id, seller_zip_code_prefix, seller_city, seller_state
FROM staging_layer.delta_all
GROUP BY seller_id, seller_zip_code_prefix, seller_city, seller_state
ORDER BY seller_id, seller_zip_code_prefix, seller_city, seller_state;