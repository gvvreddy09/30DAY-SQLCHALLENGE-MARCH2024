drop table if exists hotel_ratings;
create table hotel_ratings
(
	hotel 		varchar(30),
	year		int,
	rating 		float
);
insert into hotel_ratings values('Radisson Blu', 2020, 4.8);
insert into hotel_ratings values('Radisson Blu', 2021, 3.5);
insert into hotel_ratings values('Radisson Blu', 2022, 3.2);
insert into hotel_ratings values('Radisson Blu', 2023, 3.8);
insert into hotel_ratings values('InterContinental', 2020, 4.2);
insert into hotel_ratings values('InterContinental', 2021, 4.5);
insert into hotel_ratings values('InterContinental', 2022, 1.5);
insert into hotel_ratings values('InterContinental', 2023, 3.8);

with cte as(
select *,
	-- round(avg(rating) over(partition by hotel),2) as avg_rating,
	abs(round((rating - avg(rating) over(partition by hotel))/stddev(rating) over(partition by hotel),2)) as z_score
from hotel_ratings
), cte_rn as (
select *,
	row_number() over(partition by hotel order by deviation desc) as rn
from cte
) 
select hotel, year, rating 
from cte_rn
where rn>1
order by hotel desc, year;

-- My Solution
WITH cte AS (
	SELECT *,
		ABS(
			ROUND(
					(rating - AVG(rating) OVER(PARTITION BY hotel))/STDDEV(rating) OVER(PARTITION BY hotel), 2
				 )
		   ) AS z_score
	FROM hotel_ratings
)
SELECT hotel, year, rating
FROM cte
WHERE z_score < 1.5
ORDER BY hotel DESC, year;