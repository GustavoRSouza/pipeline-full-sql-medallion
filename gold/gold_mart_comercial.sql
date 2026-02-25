create schema if not exists mart;

--dim_users
create table if not exists mart.dim_users (
	user_id bigint primary key,
	first_name text,
	last_name text,
	email text,
	age int,
	gender text,
	state text,
	city text,
	country text,
	traffic_source text,
	user_created_at date
);

-- dim_products
create table if not exists mart.dim_products(
	product_id bigint primary key,
	category text,
	product_name text,
	brand text,
	department text,
	sku text
);

-- fact_sales
create table if not exists mart.fact_sales (
	order_item_id bigint primary key,
	order_id bigint,
	user_id bigint,
	product_id bigint,
	status text,
	created_at date,
	shipped_at date,
	delivered_at date,
	returned_at date,
	sale_price numeric(10,2),
	cost_price numeric(10,2)
);