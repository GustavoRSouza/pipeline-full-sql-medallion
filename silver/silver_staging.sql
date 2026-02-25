create schema if not exists staging;

-- stg_orders
create table if not exists staging.stg_orders (
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

-- stg_products
create table if not exists staging.stg_products(
	product_id bigint,
	cost numeric(10,2),
	category text,
	product_name text,
	brand text,
	retail_price numeric(10,2),
	department text,
	sku text,
	distribution_center_id bigint	
);

-- stg_users
create table if not exists staging.stg_users(
	user_id bigint,
	first_name text,
	last_name text,
	email text,
	age int,
	gender text,
	state text,
	street_address text,
	postal_code text,
	city text,
	country text,
	latitude double precision,
	longitude double precision,
	traffic_source text,
	created_at timestamp
);

-- stg_inventory_items
create table if not exists staging.stg_inventory_items(
	inventory_item_id bigint,
	product_id bigint,
	created_at timestamp,
	sold_at timestamp,
	cost numeric(10,2),
	product_category text,
	product_name text,
	product_brand text,
	product_retail_price numeric(10,2),
	product_department text,
	product_sku text,
	product_distribution_center_id bigint
);

-- stg_order_items
create table if not exists staging.stg_order_items(
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
	sale_price numeric(10,2)
);