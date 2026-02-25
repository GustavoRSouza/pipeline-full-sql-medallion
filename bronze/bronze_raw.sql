create schema if not exists raw;

-- orders
create table if not exists select * from raw.orders(
	id text,
	user_id text,
	status text,
	gender text,
	created_at text,
	returned_at text,
	shipped_at text,
	delivered_at text,
	num_of_item text
);

-- products
create table if not exists raw.products(
	id text,
	cost text,
	category text,
	name text,
	brand text,
	retail_price text,
	department text,
	sku text,
	distribution_center_id text		
);

-- users
create table if not exists raw.users(
	id text,
	first_name text,
	last_name text,
	email text,
	age text,
	gender text,
	state text,
	street_address text,
	postal_code text,
	city text,
	country text,
	latitude text,
	longitude text,
	traffic_source text,
	created_at text
);

-- inventory_items
create table if not exists raw.inventory_items(
	id text,
	product_id text,
	created_at text,
	sold_at text,
	cost text,
	product_category text,
	product_name text,
	product_brand text,
	product_retail_price text,
	product_department text,
	product_sku text,
	product_distribution_center_id text
);

-- order_items
create table if not exists raw.order_items(
	id text,
	order_id text,
	user_id text,
	product_id text,
	inventory_item_id text,
	status text,
	created_at text,
	shipped_at text,
	delivered_at text,
	returned_at text,
	sale_price text
);