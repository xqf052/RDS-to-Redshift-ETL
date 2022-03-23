-- Copy historical data from mysql database into S3 bucket
select ro.order_id, ro.customer_id, ro.order_purchase_timestamp, ro.order_estimated_delivery_date, 
ro.order_status, op.payment_value, rc.customer_zip_code_prefix, rc.customer_city, rc.customer_state,
roi.product_id, roi.seller_id, roi.price, roi.freight_value,
rp.product_category_name, rp.product_weight_g, rp.product_length_cm, rp.product_height_cm, 
rp.product_width_cm, rs.seller_zip_code_prefix, rs.seller_city, rs.seller_state 
from 
raw_orders ro left join  
(select order_id, sum(payment_value) as payment_value
from raw_order_payments rop 
group by order_id) op 
on ro.order_id =op.order_id
left join raw_customers rc 
on ro.customer_id = rc.customer_id 
left join raw_order_items roi 
on ro.order_id = roi.order_id 
left join raw_products rp 
on roi.product_id = rp.product_id 
left join raw_sellers rs 
on roi.seller_id = rs.seller_id
where date(ro.order_purchase_timestamp)<=STR_TO_DATE('2018-07-31','%Y-%m-%d');

--Copy incremental data for the past 30 days into the S3 bucket
select ro.order_id, ro.customer_id, ro.order_purchase_timestamp, ro.order_estimated_delivery_date,
ro.order_status, op.payment_value, rc.customer_zip_code_prefix, rc.customer_city, rc.customer_state,
roi.product_id, roi.seller_id, roi.price, roi.freight_value,
rp.product_category_name, rp.product_weight_g, rp.product_length_cm, rp.product_height_cm, 
rp.product_width_cm, rs.seller_zip_code_prefix, rs.seller_city, rs.seller_state 
from 
raw_orders ro left join  
(select order_id, sum(payment_value) as payment_value
from raw_order_payments rop 
group by order_id) op 
on ro.order_id =op.order_id
left join raw_customers rc 
on ro.customer_id = rc.customer_id 
left join raw_order_items roi 
on ro.order_id = roi.order_id 
left join raw_products rp 
on roi.product_id = rp.product_id 
left join raw_sellers rs 
on roi.seller_id = rs.seller_id
where ro.order_purchase_timestamp BETWEEN '2018-8-30' - INTERVAL 30 DAY AND '2018-8-30';

--The reason I hard code the data for the incremental ETL is that the max data in the raw data is '2018-8-29'. 
-- In practice, it can be changed to
select ro.order_id, ro.customer_id, ro.order_purchase_timestamp, ro.order_estimated_delivery_date,
ro.order_status, op.payment_value, rc.customer_zip_code_prefix, rc.customer_city, rc.customer_state,
roi.product_id, roi.seller_id, roi.price, roi.freight_value,
rp.product_category_name, rp.product_weight_g, rp.product_length_cm, rp.product_height_cm, 
rp.product_width_cm, rs.seller_zip_code_prefix, rs.seller_city, rs.seller_state 
from 
raw_orders ro left join  
(select order_id, sum(payment_value) as payment_value
from raw_order_payments rop 
group by order_id) op 
on ro.order_id =op.order_id
left join raw_customers rc 
on ro.customer_id = rc.customer_id 
left join raw_order_items roi 
on ro.order_id = roi.order_id 
left join raw_products rp 
on roi.product_id = rp.product_id 
left join raw_sellers rs 
on roi.seller_id = rs.seller_id
where ro.order_purchase_timestamp BETWEEN now() - INTERVAL 30 DAY AND now();