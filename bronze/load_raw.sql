-- raw
truncate raw.orders, raw.products, raw.users, raw.inventory_items, raw.order_items;

-- OBS.: AS INSTRUÇÕES ABAIXO DEVEM SER EXECUTADAS NO PSQL
\copy raw.orders from 'C:\Users\gusta\projetos\pipeline-full-sql-medallion\_dataset\orders.csv' with (format csv, header true, null '', encoding 'UTF8');
\copy raw.products from 'C:\Users\gusta\projetos\pipeline-full-sql-medallion\_dataset\products.csv' with (format csv, header true, null '', encoding 'UTF8');
\copy raw.users from 'C:\Users\gusta\projetos\pipeline-full-sql-medallion\datas_datasetet\users.csv' with (format csv, header true, null '', encoding 'UTF8');
\copy raw.inventory_items from 'C:\Users\gusta\projetos\pipeline-full-sql-medallion\_dataset\inventory_items.csv' with (format csv, header true, null '', encoding 'UTF8');
\copy raw.order_items from 'C:\Users\gusta\projetos\pipeline-full-sql-medallion\_dataset\order_items.csv' with (format csv, header true, null '', encoding 'UTF8');
