/*
PROBLEM STATEMENT: 
Given vacation_plans tables shows the vacations applied by each employee during the year 2024. 
Leave_balance table has the available leaves for each employee.
Write an SQL query to determine if the vacations applied by each employee can be approved or not based on the available leave balance. 
If an employee has enough available leaves then mention the status as "Approved" else mention "Insufficient Leave Balance".
Assume there are no public holidays during 2024. weekends (sat & sun) should be excluded while calculating vacation days. 
*/

drop table if exists vacation_plans;
create table vacation_plans
(
	id 			int primary key,
	emp_id		int,
	from_dt		date,
	to_dt		date
);
insert into vacation_plans values(1,1, '2024-02-12', '2024-02-16');
insert into vacation_plans values(2,2, '2024-02-20', '2024-02-29');
insert into vacation_plans values(3,3, '2024-03-01', '2024-03-31');
insert into vacation_plans values(4,1, '2024-04-11', '2024-04-23');
insert into vacation_plans values(5,4, '2024-06-01', '2024-06-30');
insert into vacation_plans values(6,3, '2024-07-05', '2024-07-15');
insert into vacation_plans values(7,3, '2024-08-28', '2024-09-15');


drop table if exists leave_balance;
create table leave_balance
(
	emp_id			int,
	balance			int
);
insert into leave_balance values (1, 12);
insert into leave_balance values (2, 10);
insert into leave_balance values (3, 26);
insert into leave_balance values (4, 20);
insert into leave_balance values (5, 14);

select * from vacation_plans;
select * from leave_balance;

select *, DATEDIFF(to_dt, from_dt) + 1 AS diff from vacation_plans;
select date_add('2024-02-29', interval 1 - dayofweek('2024-02-29') day); -- '2024-02-25'
select date_add('2024-02-20', interval 7 - dayofweek('2024-02-20') day); -- '2024-02-24'
select (datediff('2024-02-29','2024-02-20')+1) - (datediff('2024-02-25','2024-02-24')); -- 1
select floor((DATEDIFF('2024-02-25','2024-02-24')+1)/7)*2;

WITH RECURSIVE cte AS (
	-- 1. Calculate dates between from_dt and to_dt
	WITH date_range_generator AS (
		SELECT *, DATE_ADD(from_dt, INTERVAL n DAY) AS date
		FROM vacation_plans
		JOIN (
			WITH RECURSIVE cte AS (
				SELECT 0 AS n
				UNION
				SELECT n+1 FROM cte WHERE n < (SELECT MAX(DATEDIFF(to_dt, from_dt)+1) FROM vacation_plans) 
			)
				SELECT * FROM cte
		) numbers ON DATE_ADD(from_dt, INTERVAL n DAY) <= to_dt
	), 
    -- 2. Exclude Saturdays and Sundays and count number of vacation days
    vacation_day AS (
		SELECT id,emp_id,from_dt,to_dt,COUNT(date) AS vacation_days FROM date_range_generator  
		WHERE WEEKDAY(date) NOT IN (5,6)
		GROUP BY id,emp_id,from_dt,to_dt
	), 
    -- 3.1 Add row number partition by employee_id 
		-- purpose: calculate remaining_balance 
        -- Reason: same employee apply leave for multiple times 
    -- 3.2 Join 'vacation_day' cte with leave_balance to fetch balance of each employee
    cte_data AS (
		SELECT vd.*,
			balance, 
			ROW_NUMBER() OVER(PARTITION BY vd.emp_id ORDER BY vd.emp_id, vd.id) AS rn 
		FROM vacation_day vd 
		JOIN leave_balance lb ON vd.emp_id=lb.emp_id
    )
    -- Actual Recursive cte code
    SELECT *, (balance-vacation_days) as remaining_balance FROM cte_data WHERE rn=1
    UNION ALL
    SELECT cd.*, (remaining_balance-cd.vacation_days) 
    FROM cte JOIN cte_data cd ON cd.rn=(cte.rn+1) AND cd.emp_id=cte.emp_id
)
SELECT id, emp_id, from_dt, to_dt,vacation_days, 
	CASE 
		WHEN remaining_balance >= 0 THEN "Approved"
        ELSE "Insufficient Leave Balance"
    END AS status
FROM cte;
