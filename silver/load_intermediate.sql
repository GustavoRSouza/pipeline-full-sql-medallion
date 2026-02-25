-- intermediate

truncate intermediate.int_status_orders, intermediate.int_users, intermediate.int_products, intermediate.int_orders, intermediate.int_order_itmes;

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


