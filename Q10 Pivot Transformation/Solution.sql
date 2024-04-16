drop table if exists auto_repair;
create table auto_repair
(
	client			varchar(20),
	auto			varchar(20),
	repair_date		int,
	indicator		varchar(20),
	value			varchar(20)
);
insert into auto_repair values('c1','a1',2022,'level','good');
insert into auto_repair values('c1','a1',2022,'velocity','90');
insert into auto_repair values('c1','a1',2023,'level','regular');
insert into auto_repair values('c1','a1',2023,'velocity','80');
insert into auto_repair values('c1','a1',2024,'level','wrong');
insert into auto_repair values('c1','a1',2024,'velocity','70');
insert into auto_repair values('c2','a1',2022,'level','good');
insert into auto_repair values('c2','a1',2022,'velocity','90');
insert into auto_repair values('c2','a1',2023,'level','wrong');
insert into auto_repair values('c2','a1',2023,'velocity','50');
insert into auto_repair values('c2','a2',2024,'level','good');
insert into auto_repair values('c2','a2',2024,'velocity','80');

select * from auto_repair;

select client, auto, repair_date, group_concat(indicator), group_concat(value) from auto_repair
group by client, auto, repair_date;

WITH cte AS (
	SELECT 
		MAX(CASE WHEN indicator = "velocity" THEN value END) AS velocity, 
		SUM(CASE WHEN value = "good" THEN 1 ELSE 0 END) AS good,
		SUM(CASE WHEN value = "wrong" THEN 1 ELSE 0 END) AS wrong,
		SUM(CASE WHEN value = "regular" THEN 1 ELSE 0 END) AS regular
	FROM auto_repair
	GROUP BY client, auto, repair_date 
	ORDER BY velocity
)
SELECT 
	velocity, 
    SUM(good) AS good, 
    SUM(wrong) AS wrong, 
    SUM(regular) AS regular 
FROM cte 
GROUP BY velocity;
