drop table if exists salary;
create table salary
(
	emp_id		int,
	emp_name	varchar(30),
	base_salary	int
);
insert into salary values(1, 'Rohan', 5000);
insert into salary values(2, 'Alex', 6000);
insert into salary values(3, 'Maryam', 7000);


drop table if exists income;
create table income
(
	id			int,
	income		varchar(20),
	percentage	int
);
insert into income values(1,'Basic', 100);
insert into income values(2,'Allowance', 4);
insert into income values(3,'Others', 6);


drop table if exists deduction;
create table deduction
(
	id			int,
	deduction	varchar(20),
	percentage	int
);
insert into deduction values(1,'Insurance', 5);
insert into deduction values(2,'Health', 6);
insert into deduction values(3,'House', 4);


drop table if exists emp_transaction;
create table emp_transaction
(
	emp_id		int,
	emp_name	varchar(50),
	trns_type	varchar(20),
	amount		numeric
);
/* insert into emp_transaction
select s.emp_id, s.emp_name, x.trns_type
, case when x.trns_type = 'Basic' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Allowance' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Others' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Insurance' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'Health' then round(base_salary * (cast(x.percentage as decimal)/100),2)
	   when x.trns_type = 'House' then round(base_salary * (cast(x.percentage as decimal)/100),2) end as amount	   
from salary s
cross join (select income as trns_type, percentage from income
			union
			select deduction as trns_type, percentage from deduction) x;
*/

/*
select * from salary;
select * from income;
select * from deduction;
select * from emp_transaction;
*/

-- EMP_TRANSACTION Table
INSERT INTO emp_transaction
WITH transaction_table AS (
SELECT * FROM salary CROSS JOIN income
union
SELECT * FROM salary CROSS JOIN deduction
)
SELECT emp_id, emp_name, income AS trns_type, round((base_salary)*(percentage/100)) AS amount FROM transaction_table;

-- SALARY_REPORT
WITH report AS (
SELECT 
	emp_name,
    MAX(CASE WHEN trns_type = "Basic" THEN amount END) AS Basic,
    MAX(CASE WHEN trns_type = "Allowance" THEN amount END) AS Allowance,
    MAX(CASE WHEN trns_type = "Others" THEN amount END) AS Others,
    MAX(CASE WHEN trns_type = "Insurance" THEN amount END) AS Insurance,
    MAX(CASE WHEN trns_type = "Health" THEN amount END) AS Health,
    MAX(CASE WHEN trns_type = "House" THEN amount END) AS House
FROM emp_transaction
GROUP BY emp_name
)
SELECT emp_name, Basic, Allowance, Others, 
	   (Basic+Allowance+Others) AS Gross,
       Insurance, Health, House,
       (Insurance+Health+House) AS Total_Deductions,
       (Basic+Allowance+Others) - (Insurance+Health+House) AS Net_Pay
FROM report;

