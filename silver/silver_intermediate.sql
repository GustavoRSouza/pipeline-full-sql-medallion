create schema if not exists intermediate;

-- validaçao de status distintos entre orders e order_items
create table if not exists intermediate.int_status_orders (
	status_stg text,
	status_int text
);

-- int_users
create table if not exists intermediate.int_users (
	user_id bigint,
	first_name text,
	last_name text,
	email text,
	age int,
	gender text,
	state text,
	city text,
	country text,
	traffic_source text,
	user_created_at timestamp
);

-- int_products
create table if not exists intermediate.int_products(
	product_id bigint,
	product_cost numeric(10,2),
	category text,
	product_name text,
	brand text,
	retail_price numeric(10,2),
	department text,
	sku text,
	distribution_center_id bigint	
);

-- int_orders
create table if not exists intermediate.int_orders(
	order_id bigint,
	user_id bigint,
	status text,
	gender text,
	created_at timestamp,
	returned_at timestamp,
	shipped_at timestamp,
	delivered_at timestamp,
	num_of_item int
);

-- int_order_items
create table if not exists intermediate.int_order_itmes(
	order_item_id bigint,
	order_id bigint,
	user_id bigint,
	product_id bigint,
	inventory_item_id bigint,
	status text,
	created_at timestamp,
	shipped_at timestamp,
	delivered_at timestamp,
	returned_at timestamp,
	sale_price numeric(10,2),
	cost numeric(10,2)
);