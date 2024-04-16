-- Given is user login table for , identify dates where a user has logged in for 5 or more consecutive days.
-- Return the user id, start date, end date and no of consecutive days, sorting based on user id.
-- If a user logged in consecutively 5 or more times but not spanning 5 days then they should be excluded.

/*
-- Output:
USER_ID		START_DATE		END_DATE		CONSECUTIVE_DAYS
1			10/03/2024		14/03/2024		5
1 			25/03/2024		30/03/2024		6
3 			01/03/2024		05/03/2024		5
*/


drop table if exists user_login;
create table user_login
(
	user_id		int,
	login_date	date
);
insert into user_login values(1, str_to_date('01/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('02/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('03/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('04/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('06/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('10/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('11/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('12/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('13/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('14/03/2024','%d/%m/%Y'));

insert into user_login values(1, str_to_date('20/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('25/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('26/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('27/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('28/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('29/03/2024','%d/%m/%Y'));
insert into user_login values(1, str_to_date('30/03/2024','%d/%m/%Y'));

insert into user_login values(2, str_to_date('01/03/2024','%d/%m/%Y'));
insert into user_login values(2, str_to_date('02/03/2024','%d/%m/%Y'));
insert into user_login values(2, str_to_date('03/03/2024','%d/%m/%Y'));
insert into user_login values(2, str_to_date('04/03/2024','%d/%m/%Y'));

insert into user_login values(3, str_to_date('01/03/2024','%d/%m/%Y'));
insert into user_login values(3, str_to_date('02/03/2024','%d/%m/%Y'));
insert into user_login values(3, str_to_date('03/03/2024','%d/%m/%Y'));
insert into user_login values(3, str_to_date('04/03/2024','%d/%m/%Y'));
insert into user_login values(3, str_to_date('04/03/2024','%d/%m/%Y'));
insert into user_login values(3, str_to_date('04/03/2024','%d/%m/%Y'));
insert into user_login values(3, str_to_date('05/03/2024','%d/%m/%Y'));

insert into user_login values(4, str_to_date('01/03/2024','%d/%m/%Y'));
insert into user_login values(4, str_to_date('02/03/2024','%d/%m/%Y'));
insert into user_login values(4, str_to_date('03/03/2024','%d/%m/%Y'));
insert into user_login values(4, str_to_date('04/03/2024','%d/%m/%Y'));
insert into user_login values(4, str_to_date('04/03/2024','%d/%m/%Y'));

/*
	1. subtract row numbers(using dense_rank) from dates, you'll get same date(date_group) for consecutive dates
    2. group by date_group and find out consecutive_days(MAX(login_date) - MIN(login_date) + 1)
    3. Filter consecutive days
*/

WITH cte AS (
	SELECT *,
		DENSE_RANK() OVER(PARTITION BY user_id ORDER BY login_date) AS rn,
		DATE_SUB(login_date, INTERVAL DENSE_RANK() OVER(PARTITION BY user_id ORDER BY login_date) DAY) AS date_group
	FROM user_login
)
SELECT user_id, 
	MIN(login_date) AS start_date, 
    MAX(login_date) AS end_date,
    MAX(login_date) - MIN(login_date) + 1 AS consecutive_days
FROM cte 
GROUP BY user_id, date_group
HAVING consecutive_days >= 5;