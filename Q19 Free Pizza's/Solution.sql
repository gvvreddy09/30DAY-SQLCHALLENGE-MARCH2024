-- Given table showcases details of pizza delivery order for the year of 2023.
-- If an order is delayed then the whole order is given for free. Any order that takes 30 minutes more than the expected time is considered as delayed order. 
-- Identify the percentage of delayed order for each month and also display the total no of free pizzas given each month.


DROP TABLE IF EXISTS pizza_delivery;
CREATE TABLE pizza_delivery 
(
	order_id 			INT,
	order_time 			TIMESTAMP,
	expected_delivery 	TIMESTAMP,
	actual_delivery 	TIMESTAMP,
	no_of_pizzas 		INT,
	price 				DECIMAL
);


-- SUM(no_of_pizzas) OVER(PARTITION BY MONTH(order_time)) AS 
-- Data to this table can be found in CSV File

/*
SELECT 
	MONTHNAME(order_time) AS month,
	SUM(no_of_pizzas) AS no_of_pizzas,
    COUNT(order_id) AS delayed_orders_flag
FROM pizza_delivery
WHERE TIMESTAMPDIFF(MINUTE, order_time, actual_delivery) > 30
GROUP BY MONTHNAME(order_time);

SELECT CONCAT(MONTHNAME(DATE(2023, 1, 1)),'-','2023');
SELECT MONTHNAME(DATE('2023-01-01'));
SELECT DATE(CONCAT(2023,'-',03,'-',01));
SELECT VERSION();
*/

/*
	1. Find out delayed orders (Any order that takes 30 minutes more than the expected time)
    2. CTE: monthwise_total_orders selects Month, total_orders (including delayed orders), and delayed_orders using (delayed_orders_flag)
    3. CTE: free_pizza selects Month, and no_of_free_pizzas
*/
WITH cte AS (
	SELECT 
		*,
		CASE
			WHEN TIMESTAMPDIFF(MINUTE, order_time, actual_delivery)>30 THEN 1
			ELSE 0
		END AS delayed_orders_flag
	FROM pizza_delivery
), monthwise_total_orders AS (
	SELECT 
		MONTH(order_time) AS month,
		COUNT(order_id) AS total_orders,
		SUM(delayed_orders_flag) AS delayed_orders
	FROM cte
	GROUP BY MONTH(order_time)
), free_pizza AS (
	SELECT 
		MONTH(order_time) AS month,
		SUM(no_of_pizzas) AS free_pizzas
	FROM cte
    WHERE delayed_orders_flag = 1
	GROUP BY MONTH(order_time)
)
SELECT 
	 CONCAT(LEFT(MONTHNAME(DATE(CONCAT(2023,'-',month,'-',01))), 3),'-',23) AS period, 
     ROUND((delayed_orders/total_orders)*100, 1) AS delayed_delivery_pct, 
     free_pizzas
FROM monthwise_total_orders m JOIN free_pizza f USING(month)
ORDER BY month;