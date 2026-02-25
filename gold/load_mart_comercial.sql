truncate mart.dim_users, mart.dim_products, mart.fact_sales;

-- dim_users
insert into mart.dim_users(
	user_id,
	first_name,
	last_name,
	email,
	age,
	gender,
	state,
	city,
	country,
	traffic_source,
	user_created_at
)
select
	user_id,
	first_name,
	last_name,
	email,
	age,
	gender,
	state,
	city,
	country,
	traffic_source,
	user_created_at::date
from
	intermediate.int_users;

-- dim_products
insert into mart.dim_products (
	product_id,
	category,
	product_name,
	brand,
	department,
	sku
)
select 
	product_id,
	category,
	product_name,
	brand,
	department,
	sku
from
	intermediate.int_products;

-- fact_sales
insert into  mart.fact_sales (
	order_item_id,
	order_id,
	user_id,
	product_id,
	status,
	created_at,
	shipped_at,
	delivered_at,
	returned_at,
	sale_price,
	cost_price
)
select
	order_item_id,
	order_id,
	user_id,
	product_id,
	status,
	created_at::date,
	shipped_at::date,
	delivered_at::date,
	returned_at::date,
	sale_price,
	cost
from
	intermediate.int_order_itmes;