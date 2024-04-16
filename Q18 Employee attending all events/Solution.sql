-- Find out the employees who attended all company events

drop table if exists employees;
create table employees
(
	id			int,
	name		varchar(50)
);
insert into employees values(1, 'Lewis');
insert into employees values(2, 'Max');
insert into employees values(3, 'Charles');
insert into employees values(4, 'Sainz');


drop table if exists events;
create table events
(
	event_name		varchar(50),
	emp_id			int,
	dates			date
);
insert into events values('Product launch', 1, str_to_date('01-03-2024','%d-%m-%Y'));
insert into events values('Product launch', 3, str_to_date('01-03-2024','%d-%m-%Y'));
insert into events values('Product launch', 4, str_to_date('01-03-2024','%d-%m-%Y'));
insert into events values('Conference', 2, str_to_date('02-03-2024','%d-%m-%Y'));
insert into events values('Conference', 2, str_to_date('03-03-2024','%d-%m-%Y'));
insert into events values('Conference', 3, str_to_date('02-03-2024','%d-%m-%Y'));
insert into events values('Conference', 4, str_to_date('02-03-2024','%d-%m-%Y'));
insert into events values('Training', 3, str_to_date('04-03-2024','%d-%m-%Y'));
insert into events values('Training', 2, str_to_date('04-03-2024','%d-%m-%Y'));
insert into events values('Training', 4, str_to_date('04-03-2024','%d-%m-%Y'));
insert into events values('Training', 4, str_to_date('05-03-2024','%d-%m-%Y'));



select * from employees;
select * from events;

SELECT 
    name, COUNT(DISTINCT event_name) AS no_of_events
FROM
    events ev
JOIN employees em ON em.id = ev.emp_id
GROUP BY name
HAVING no_of_events = (SELECT COUNT(DISTINCT event_name) FROM events);

