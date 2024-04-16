
drop table if exists product_demo;
create table product_demo
(
	store_id	int,
	product_1	varchar(50),
	product_2	varchar(50)
);
insert into product_demo values (1, 'Apple - IPhone', '   Apple - MacBook Pro');
insert into product_demo values (1, 'Apple - AirPods', 'Samsung - Galaxy Phone');
insert into product_demo values (2, 'Apple_IPhone', 'Apple: Phone');
insert into product_demo values (2, 'Google Pixel', ' apple: Laptop');
insert into product_demo values (2, 'Sony: Camera', 'Apple Vision Pro');
insert into product_demo values (3, 'samsung - Galaxy Phone', 'mapple MacBook Pro');


WITH cte AS (
	SELECT 
		*,
		CASE WHEN TRIM(product_1) LIKE 'apple%' THEN 1 ELSE 0 END AS temp_1,
		CASE WHEN TRIM(product_2) LIKE 'apple%' THEN 1 ELSE 0 END AS temp_2
	FROM product_demo 
)
SELECT 
	store_id, 
    SUM(temp_1) AS product_1, 
    SUM(temp_2) AS product_2 
FROM cte
GROUP BY store_id;

