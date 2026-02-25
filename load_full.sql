\echo '====================================='
\echo 'INICIANDO REFRESH DA CAMADA RAW'
\echo '====================================='
\echo ' '
\timing on

truncate raw.orders, raw.products, raw.users, raw.inventory_items, raw.order_items;

\echo ' '
\echo 'Carregando orders...'
\copy raw.orders from 'C:\Users\gusta\projetos\pipeline-full-sql-medallion\_dataset\orders.csv' with (format csv, header true, null '', encoding 'UTF8');
\echo ' '
\echo 'Carregando products...'
\copy raw.products from 'C:\Users\gusta\projetos\pipeline-full-sql-medallion\_dataset\products.csv' with (format csv, header true, null '', encoding 'UTF8');
\echo ' '
\echo 'Carregando users...'
\copy raw.users from 'C:\Users\gusta\projetos\pipeline-full-sql-medallion\_dataset\users.csv' with (format csv, header true, null '', encoding 'UTF8');
\echo ' '
\echo 'Carregando inventory_items...'
\copy raw.inventory_items from 'C:\Users\gusta\projetos\pipeline-full-sql-medallion\_dataset\inventory_items.csv' with (format csv, header true, null '', encoding 'UTF8');
\echo ' '
\echo 'Carregando order_items...'
\copy raw.order_items from 'C:\Users\gusta\projetos\pipeline-full-sql-medallion\_dataset\order_items.csv' with (format csv, header true, null '', encoding 'UTF8');
\echo ' '

\echo '====================================='
\echo 'INICIANDO REFRESH DA CAMADA STAGING'
\echo '====================================='
\echo ' '
\timing on

truncate staging.stg_orders, staging.stg_products, staging.stg_users, staging.stg_inventory_items, staging.stg_order_items;

\echo 'Carregando stg_orders...'
-- stg_orders
insert into staging.stg_orders(
	order_id,
	user_id,
	status,
	gender,
	created_at,
	returned_at,
	shipped_at,
	delivered_at,
	num_of_item	
)
with tipagem_stg_orders as (
	select
		id::int as order_id,
		nullif(user_id,'')::int as user_id,
		nullif(status,'') as status,
		nullif(gender,'') as gender,
		to_timestamp(nullif(created_at,''),'MM-DD-YYYY')::date as created_at,
		to_timestamp(nullif(returned_at,''),'MM-DD-YYYY')::date as returned_at,
		to_timestamp(nullif(shipped_at,''),'MM-DD-YYYY')::date as shipped_at,
		to_timestamp(nullif(delivered_at,''),'MM-DD-YYYY')::date as delivered_at,
		nullif(num_of_item, '')::int as num_of_item
	from
		raw.orders
)select
	order_id,
	user_id,
	status,
	gender,
	created_at,
	case when (returned_at < created_at) and (returned_at is not null) then null else returned_at end as returned_at,
	case when (shipped_at < created_at) and (shipped_at is not null) then null else shipped_at end as shipped_at,
	case when (delivered_at < created_at) and (delivered_at is not null) then null else delivered_at end as delivered_at,
	num_of_item
from
	tipagem_stg_orders;
\echo ' '

\echo 'Carregando stg_products...'
-- stg_products
insert into staging.stg_products (
	product_id,
	cost,
	category,
	product_name,
	brand,
	retail_price,
	department,
	sku,
	distribution_center_id
)select
	id::int as product_id,
	nullif(cost,'')::numeric(10,2) as cost,
	nullif(category,'') as category,
	nullif(name,'') as product_name,
	nullif(brand,'') as brand,
	nullif(retail_price,'')::numeric(10,2) as retail_price,
	nullif(department,'') as department,
	nullif(sku,'') as sku,
	nullif(distribution_center_id,'')::int as distribution_center_id
from
	raw.products;
\echo ' '

\echo 'Carregando stg_users...'
-- stg_users
insert into staging.stg_users (
	user_id,
	first_name,
	last_name,
	email,
	age,
	gender,
	state,
	street_address,
	postal_code,
	city,
	country,
	latitude,
	longitude,
	traffic_source,
	created_at
)select
	id::int as user_id,
	nullif(first_name,'') as first_name,
	nullif(last_name,'') as last_name,
	nullif(email,'') as email,
	nullif(age,'')::int as age,
	nullif(gender,'') as gender,
	nullif(state,'') as state,
	nullif(street_address,'') as street_address,
	nullif(postal_code,'') as postal_code,
	case city when 'null' then null else nullif(city,'') end as city,
	nullif(country,'') as country,
	nullif(latitude,'')::double precision as latitude,
	nullif(longitude,'')::double precision as longitude,
	nullif(traffic_source,'') as traffic_source,
	to_timestamp(nullif(created_at,''), 'YYYY-MM-DD')::date as created_at
from
	raw.users;
\echo ' '

\echo 'Carregando stg_inventory_items...'
-- stg_inventory_items
insert into staging.stg_inventory_items(
	inventory_item_id,
	product_id,
	created_at,
	sold_at,
	cost,
	product_category,
	product_name,
	product_brand,
	product_retail_price,
	product_department,
	product_sku,
	product_distribution_center_id
)
with tipagem_stg_inventory_items as (
	select
		id::int as inventory_item_id,
		product_id::int as product_id,
		to_timestamp(nullif(created_at,''),'YYYY-MM-DD')::date as created_at,
		to_timestamp(nullif(sold_at,''),'YYYY-MM-DD')::date as sold_at,
		nullif(cost,'')::numeric(10,2) as cost,
		nullif(product_category,'') as product_category,
		nullif(product_name,'') as product_name,
		nullif(product_brand,'') as product_brand,
		nullif(product_retail_price,'')::numeric(10,2) as product_retail_price,
		nullif(product_department,'') as product_department,
		nullif(product_sku,'') as product_sku,
		nullif(product_distribution_center_id,'')::int as product_distribution_center_id
	from
		raw.inventory_items
)select
	inventory_item_id,
	product_id,
	created_at,
	case when (sold_at < created_at) and (sold_at is not null) then null else sold_at end as sold_at,
	cost,
	product_category,
	product_name,
	product_brand,
	product_retail_price,
	product_department,
	product_sku,
	product_distribution_center_id
from
	tipagem_stg_inventory_items;
\echo ' '

\echo 'Carregando stg_order_items...'
-- stg_order_items
insert into staging.stg_order_items (
	order_item_id,
	order_id,
	user_id,
	product_id,
	inventory_item_id,
	status,
	created_at,
	shipped_at,
	delivered_at,
	returned_at,
	sale_price
)
with tipagem_stg_order_items as (
	select
		id::int as order_item_id,
		nullif(order_id,'')::int as order_id,
		nullif(user_id,'')::int as user_id,
		nullif(product_id,'')::int as product_id,
		nullif(inventory_item_id,'')::int as inventory_item_id,
		nullif(status,'') as status,
		nullif(created_at,'')::date as created_at,
		nullif(shipped_at,'')::date as shipped_at,
		nullif(delivered_at,'')::date as delivered_at,
		nullif(returned_at,'')::date as returned_at,
		nullif(sale_price,'')::numeric(10,2) as sale_price
	from
		raw.order_items
)select
	order_item_id,
	order_id,
	user_id,
	product_id,
	inventory_item_id,
	status,
	created_at,
	case when (shipped_at < created_at) and (shipped_at is not null) then null else shipped_at end as shipped_at,
	case when (delivered_at < created_at) and (delivered_at is not null) then null else delivered_at end as delivered_at,
	case when (returned_at < created_at) and (returned_at is not null) then null else returned_at end as returned_at,
	sale_price
from
	tipagem_stg_order_items;
\echo ' '


\echo '========================================'
\echo 'INICIANDO REFRESH DA CAMADA INTERMEDIATE'
\echo '========================================'
\echo ' '
\timing on

truncate intermediate.int_status_orders, intermediate.int_users, intermediate.int_products, intermediate.int_orders, intermediate.int_order_itmes;

\echo 'Carregando int_status_orders...'
-- int_status_orders
insert into intermediate.int_status_orders (
	status_stg,
	status_int
)
with map_status as (
	select
		distinct status as status_stg,
		case 
			when lower(status) in ('cancelled', 'canceled') then 'Cancelled'
			when lower(status) in ('complete', 'delivered', 'completed') then 'Complete'
			when lower(status) in ('processing', 'in_processing') then 'Processing'
			when lower(status) in ('returned') then 'Returned'
			when lower(status) in ('shipped', 'in_transit') then 'Shipped'
			when lower(status) is null then 'Unknown'
			else status
		end as status_int
	from
		(
		select status as status from staging.stg_orders
		union all
		select status as status from staging.stg_order_items
		)
	order by
		status
)
select
	status_stg,
	status_int
from
	map_status;
\echo ' '

\echo 'Carregando int_users...'
-- int_users
insert into intermediate.int_users (
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
	case
		when lower(gender) in ('f', 'female') then 'Female'
		when lower(gender) in ('m', 'male') then 'Male'
		when gender is null then 'Unknown'
		else 'Other'
	end as gender,
	state,
	city,
	country,
	traffic_source,
	created_at
from
	staging.stg_users;
\echo ' '

\echo 'Carregando int_products...'
-- int_products
insert into intermediate.int_products (
	product_id,
	product_cost,
	category,
	product_name,
	brand,
	retail_price,
	department,
	sku,
	distribution_center_id
)
select
	product_id,
	cost,
	category,
	product_name,
	brand,
	retail_price,
	department,
	sku,
	distribution_center_id
from
	staging.stg_products;
\echo ' '

\echo 'Carregando int_orders...'
-- int_orders
insert into intermediate.int_orders (
	order_id,
	user_id,
	status,
	gender,
	created_at,
	returned_at,
	shipped_at,
	delivered_at,
	num_of_item
)
select
	o.order_id,
	o.user_id,
	coalesce(so.status_int, 'Unknown') as status,
	o.gender,
	o.created_at,
	o.returned_at,
	o.shipped_at,
	o.delivered_at,
	o.num_of_item
from
	staging.stg_orders o
left join
	intermediate.int_status_orders so
	on o.status = so.status_stg;
\echo ' '

\echo 'Carregando int_order_itmes...'
-- int_order_itmes
insert into intermediate.int_order_itmes(
	order_item_id,
	order_id,
	user_id,
	product_id,
	inventory_item_id,
	status,
	created_at,
	shipped_at,
	delivered_at,
	returned_at,
	sale_price,
	cost
)
select
	oi.order_item_id,
	oi.order_id,
	oi.user_id,
	oi.product_id,
	oi.inventory_item_id,
	coalesce(so.status_int, 'Unknown') as status,
	oi.created_at,
	oi.shipped_at,
	oi.delivered_at,
	oi.returned_at,
	oi.sale_price,
	coalesce(ii.cost, p.product_cost) as cost
from
	staging.stg_order_items oi
left join
	intermediate.int_status_orders so
	on oi.status = so.status_stg
left join
	staging.stg_inventory_items ii
	on oi.inventory_item_id = ii.inventory_item_id
left join
	intermediate.int_products p
	on oi.product_id = p.product_id;
\echo ' '


\echo '================================='
\echo 'INICIANDO REFRESH DA CAMADA MART'
\echo '================================='
\echo ' '
\timing on

truncate mart.dim_users, mart.dim_products, mart.fact_sales;

\echo 'Carregando dim_users...'
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
\echo ' '

\echo 'Carregando dim_products...'
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
\echo ' '

\echo 'Carregando fact_sales...'
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
\echo ' '