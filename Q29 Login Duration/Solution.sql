/*
PROBLEM STATEMENT: Given table provides login and logoff details of one user.
Generate a report to reqpresent the different periods (in mins) when user was logged in.
*/
drop table if exists login_details;
create table login_details
(
	times	time,
	status	varchar(3)
);
insert into login_details values('10:00:00', 'on');
insert into login_details values('10:01:00', 'on');
insert into login_details values('10:02:00', 'on');
insert into login_details values('10:03:00', 'off');
insert into login_details values('10:04:00', 'on');
insert into login_details values('10:05:00', 'on');
insert into login_details values('10:06:00', 'off');
insert into login_details values('10:07:00', 'off');
insert into login_details values('10:08:00', 'off');
insert into login_details values('10:09:00', 'on');
insert into login_details values('10:10:00', 'on');
insert into login_details values('10:11:00', 'on');
insert into login_details values('10:12:00', 'on');
insert into login_details values('10:13:00', 'off');
insert into login_details values('10:14:00', 'off');
insert into login_details values('10:15:00', 'on');
insert into login_details values('10:16:00', 'off');
insert into login_details values('10:17:00', 'off');

select * from login_details;

WITH cte AS (
	SELECT *, 
		ROW_NUMBER() OVER(ORDER BY times) AS rn,
		id - ROW_NUMBER() OVER(ORDER BY times) AS grp
	FROM 
	(SELECT *, ROW_NUMBER() OVER(ORDER BY times) AS id FROM login_details) sq
	WHERE status="on"
)
SELECT 
	MIN(times) AS LOG_ON,
	DATE_ADD(MAX(times), INTERVAL 1 MINUTE) AS LOG_OFF,
	COUNT(grp)AS DURATION
FROM cte 
GROUP BY grp;