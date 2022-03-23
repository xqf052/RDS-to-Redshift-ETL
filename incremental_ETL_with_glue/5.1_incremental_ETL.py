# create an endpoint for secret manager before run the glue job. Just as lecturer did in for the s3 end point
import boto3,json
from pg import DB

secret_name = 'my secret manager name'
region_name = 'ap-southeast-2'

session = boto3.session.Session()

client = session.client(service_name='secretsmanager', region_name=region_name)

get_secret_value_response = client.get_secret_value(SecretId=secret_name)

creds = json.loads(get_secret_value_response['SecretString'])

username = creds['username']
password = creds['password']
host = creds['host']

db = DB(dbname='dev',host=host,port=5439,user=username,passwd=password)

merge_qry = """
            begin ;
            
            TRUNCATE staging_layer.delta_all;
            TRUNCATE staging_layer.delta_customers;
            TRUNCATE staging_layer.delta_date;
            TRUNCATE staging_layer.delta_orders;
            TRUNCATE staging_layer.delta_products;
            TRUNCATE staging_layer.delta_sellers;

            COPY staging_layer.delta_all FROM FROM 'S3 file path/incremental_ETL.csv'
            iam_role 'redshift IAM Role ARN'
            CSV QUOTE '\"' DELIMITER ','
            acceptinvchars;
            
            INSERT INTO staging_layer.delta_customers
            SELECT customer_id, customer_zip_code_prefix, customer_city, customer_state
            FROM staging_layer.delta_all
            GROUP BY customer_id, customer_zip_code_prefix, customer_city, customer_state
            ORDER BY customer_id, customer_zip_code_prefix, customer_city, customer_state;
            
            INSERT INTO user_access_layer.dim_customers (customer_id, customer_zip_code_prefix, customer_city, customer_state)
            SELECT f.*
            FROM staging_layer.delta_customers f
            LEFT JOIN user_access_layer.dim_customers t
            ON f.customer_id = t.customer_id
            WHERE t.customer_id IS NULL;
            
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
            
            INSERT INTO user_access_layer.dim_date 
            SELECT f.*
            FROM staging_layer.delta_date f
            LEFT JOIN user_access_layer.dim_date t
            ON f.datetime = t.datetime_skey
            WHERE t.datetime_skey IS NULL;
            
            INSERT INTO staging_layer.delta_orders
            SELECT order_id, order_status
            FROM staging_layer.delta_all
            GROUP BY order_id, order_status
            ORDER BY order_id, order_status;
            
            INSERT INTO user_access_layer.dim_orders (order_id, order_status)
            SELECT f.*
            FROM staging_layer.delta_orders f
            LEFT JOIN user_access_layer.dim_orders t
            ON f.order_id = t.order_id
            WHERE t.order_id IS NULL;
            
            INSERT INTO staging_layer.delta_products
            SELECT product_id, product_category_name, product_weight_g,
            product_length_cm, product_height_cm, product_width_cm
            FROM staging_layer.delta_all
            GROUP BY product_id, product_category_name, product_weight_g,
            product_length_cm, product_height_cm, product_width_cm
            ORDER BY product_id, product_category_name, product_weight_g,
            product_length_cm, product_height_cm, product_width_cm;
            
            INSERT INTO user_access_layer.dim_products (product_id, product_category_name, product_weight_g,
            product_length_cm, product_height_cm, product_width_cm)
            SELECT f.*
            FROM staging_layer.delta_products f
            LEFT JOIN user_access_layer.dim_products t
            ON f.product_id = t.product_id
            WHERE t.product_id IS NULL;
            
            INSERT INTO staging_layer.delta_sellers
            SELECT seller_id, seller_zip_code_prefix, seller_city, seller_state
            FROM staging_layer.delta_all
            GROUP BY seller_id, seller_zip_code_prefix, seller_city, seller_state
            ORDER BY seller_id, seller_zip_code_prefix, seller_city, seller_state;
            
            INSERT INTO user_access_layer.dim_sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state)
            SELECT f.*
            FROM staging_layer.delta_sellers f
            LEFT JOIN user_access_layer.dim_sellers t
            ON f.seller_id = t.seller_id
            WHERE t.seller_id IS NULL;
            
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

            end ;
            """

result = db.query(merge_qry)