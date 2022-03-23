-- populate dimension tables in dwh
INSERT INTO user_access_layer.dim_customers (customer_id, customer_zip_code_prefix, customer_city, customer_state)
SELECT f.*
FROM staging_layer.delta_customers f
LEFT JOIN user_access_layer.dim_customers t
ON f.customer_id = t.customer_id
WHERE t.customer_id IS NULL;

INSERT INTO user_access_layer.dim_date 
SELECT f.*
FROM staging_layer.delta_date f
LEFT JOIN user_access_layer.dim_date t
ON f.datetime = t.datetime_skey
WHERE t.datetime_skey IS NULL;

INSERT INTO user_access_layer.dim_orders (order_id, order_status)
SELECT f.*
FROM staging_layer.delta_orders f
LEFT JOIN user_access_layer.dim_orders t
ON f.order_id = t.order_id
WHERE t.order_id IS NULL;

INSERT INTO user_access_layer.dim_products (product_id, product_category_name, product_weight_g,
product_length_cm, product_height_cm, product_width_cm)
SELECT f.*
FROM staging_layer.delta_products f
LEFT JOIN user_access_layer.dim_products t
ON f.product_id = t.product_id
WHERE t.product_id IS NULL;

INSERT INTO user_access_layer.dim_sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state)
SELECT f.*
FROM staging_layer.delta_sellers f
LEFT JOIN user_access_layer.dim_sellers t
ON f.seller_id = t.seller_id
WHERE t.seller_id IS NULL;


--populate fact tables in dwh
INSERT INTO user_access_layer.fact_payments
SELECT dio.orders_skey, dic.customers_skey, dd.datetime_skey, dd2.datetime_skey, da.payment_value
FROM staging_layer.delta_all da
LEFT JOIN user_access_layer.dim_date dd ON TO_CHAR(da.order_purchase_timestamp,'YYYYMMDDHH24MI') = dd.datetime_skey
LEFT JOIN user_access_layer.dim_date dd2 ON TO_CHAR(da.order_estimated_delivery_date,'YYYYMMDDHH24MI') = dd2.datetime_skey
LEFT JOIN user_access_layer.dim_orders dio ON da.order_id = dio.order_id
LEFT JOIN user_access_layer.dim_customers dic ON da.customer_id = dic.customer_id;

INSERT INTO user_access_layer.fact_orders
SELECT dio.orders_skey, dip.products_skey, dis.sellers_skey, da.price, da.freight_value 
FROM staging_layer.delta_all da
LEFT JOIN user_access_layer.dim_orders dio ON da.order_id = dio.order_id
LEFT JOIN user_access_layer.dim_products dip ON da.product_id = dip.product_id
LEFT JOIN user_access_layer.dim_sellers dis ON da.seller_id = dis.seller_id;



