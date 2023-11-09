create database seller

-- Create olist_customers_dataset table

drop table order_items

create table customers 
(
	customer_id varchar,
	customer_unique_id varchar,
	customer_zip_code_prefix integer,
	customer_city varchar,
	customer_state varchar
)

copy customers (customer_id,customer_unique_id,customer_zip_code_prefix,customer_city,customer_state)
from 'C:\Program Files\PostgreSQL\15\bin\olist_customers_dataset.csv'
DELIMITER ','
CSV HEADER;

-- Create olist_geolocation_dataset table

create table geolocation 
(
	geolocation_zip_code_prefix integer,
	geolocation_lat varchar,
	geolocation_lng	varchar,
	geolocation_city varchar,
	geolocation_state varchar	
)

copy geolocation (geolocation_zip_code_prefix,geolocation_lat,geolocation_lng,geolocation_city,geolocation_state)
from 'C:\Program Files\PostgreSQL\15\bin\olist_geolocation_dataset.csv'
delimiter ','
csv header;

-- Create olist_order_items_dataset table

create table order_items 
(
	order_id varchar,
	order_item_id varchar,
	product_id varchar,
	seller_id varchar,
	shipping_limit_date timestamp,
	price real,
	freight_value real
)

copy order_items (order_id,order_item_id,product_id,seller_id,shipping_limit_date,price,freight_value)
from 'C:\Program Files\PostgreSQL\15\bin\olist_order_items_dataset.csv'
delimiter ','
csv header;

-- Create olist_order_payments_dataset table

create table order_payments 
(
	order_id varchar,
	payment_sequential smallint,
	payment_type varchar,
	payment_installments smallint,
	payment_value real
)

copy order_payments (order_id,payment_sequential,payment_type,payment_installments,payment_value)
from 'C:\Program Files\PostgreSQL\15\bin\olist_order_payments_dataset.csv'
delimiter ','
csv header;	

-- Create olist_order_reviews_dataset table

create table order_reviews 
(
	review_id varchar,
	order_id varchar,
	review_score smallint,
	review_comment_title varchar,
	review_comment_message varchar,
	review_creation_date date,
	review_answer_timestamp timestamp
)

copy order_reviews (review_id,order_id,review_score,review_comment_title,review_comment_message,review_creation_date,review_answer_timestamp)
from 'C:\Program Files\PostgreSQL\15\bin\olist_order_reviews_dataset.csv'
delimiter ','
csv header;	

-- Create olist_orders_dataset table

create table orders 
(
	order_id varchar,
	customer_id varchar,
	order_status varchar,
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date date
)

copy orders (order_id,customer_id,order_status,order_purchase_timestamp,order_approved_at,order_delivered_carrier_date,order_delivered_customer_date,order_estimated_delivery_date)
from 'C:\Program Files\PostgreSQL\15\bin\olist_orders_dataset.csv'
delimiter ','
csv header;	

-- Create olist_products_dataset table

create table products 
(
	product_id varchar,
	product_category_name varchar,
	product_name_lenght integer,
	product_description_lenght integer,
	product_photos_qty integer,
	product_weight_g integer,
	product_length_cm integer,
	product_height_cm integer,
	product_width_cm integer
)

copy products (product_id,product_category_name,product_name_lenght,product_description_lenght,product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm)
from 'C:\Program Files\PostgreSQL\15\bin\olist_products_dataset.csv'
delimiter ','
csv header;	


-- Create olist_sellers_dataset table

create table seller 
(
	seller_id varchar,
	seller_zip_code_prefix integer,
	seller_city varchar,
	seller_state varchar
)

copy seller (seller_id,seller_zip_code_prefix,seller_city,seller_state)
from 'C:\Program Files\PostgreSQL\15\bin\olist_sellers_dataset.csv'
delimiter ','
csv header;	

-- Create product_category_name_translation table

create table category_name
(
	product_category_name varchar,
	product_category_name_english varchar
)

copy category_name (product_category_name,product_category_name_english)
from 'C:\Program Files\PostgreSQL\15\bin\product_category_name_translation.csv'
delimiter ','
csv header;	