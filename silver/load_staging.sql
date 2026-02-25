truncate staging.stg_orders, staging.stg_products, staging.stg_users, 
		staging.stg_inventory_items, staging.stg_order_items;

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
		id::bigint as order_id,
		nullif(user_id,'')::bigint as user_id,
		nullif(status,'') as status,
		nullif(gender,'') as gender,
		to_timestamp(nullif(created_at,''),'MM-DD-YYYY HH24:MI:SS') as created_at,
		to_timestamp(nullif(returned_at,''),'MM-DD-YYYY HH24:MI:SS') as returned_at,
		to_timestamp(nullif(shipped_at,''),'MM-DD-YYYY HH24:MI:SS') as shipped_at,
		to_timestamp(nullif(delivered_at,''),'MM-DD-YYYY HH24:MI:SS') as delivered_at,
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
	id::bigint as product_id,
	nullif(cost,'')::numeric(10,2) as cost,
	nullif(category,'') as category,
	nullif(name,'') as product_name,
	nullif(brand,'') as brand,
	nullif(retail_price,'')::numeric(10,2) as retail_price,
	nullif(department,'') as department,
	nullif(sku,'') as sku,
	nullif(distribution_center_id,'')::bigint as distribution_center_id
from
	raw.products;

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
	id::bigint as user_id,
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
	to_timestamp(nullif(created_at,''), 'YYYY-MM-DD HH24:MI:SS') as created_at
from
	raw.users;

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
		id::bigint as inventory_item_id,
		product_id::bigint as product_id,
		to_timestamp(nullif(created_at,''),'YYYY-MM-DD HH24:MI:SS')::date as created_at,
		to_timestamp(nullif(sold_at,''),'YYYY-MM-DD HH24:MI:SS')::date as sold_at,
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
		id::bigint as order_item_id,
		nullif(order_id,'')::bigint as order_id,
		nullif(user_id,'')::bigint as user_id,
		nullif(product_id,'')::bigint as product_id,
		nullif(inventory_item_id,'')::bigint as inventory_item_id,
		nullif(status,'') as status,
		to_timestamp(nullif(created_at,''),'YYYY-MM-DD HH24:MI:SS') as created_at,
		to_timestamp(nullif(shipped_at,''),'YYYY-MM-DD HH24:MI:SS') as shipped_at,
		to_timestamp(nullif(delivered_at,''),'YYYY-MM-DD HH24:MI:SS') as delivered_at,
		to_timestamp(nullif(returned_at,''),'YYYY-MM-DD HH24:MI:SS') as returned_at,
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