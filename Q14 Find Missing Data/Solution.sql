
drop table if exists invoice;
create table invoice
(
	serial_no		int,
	invoice_date	date
);
insert into invoice values (330115, STR_TO_DATE('01-Mar-2024','%d-%b-%Y'));
insert into invoice values (330120, STR_TO_DATE('01-Mar-2024','%d-%b-%Y'));
insert into invoice values (330121, STR_TO_DATE('01-Mar-2024','%d-%b-%Y'));
insert into invoice values (330122, STR_TO_DATE('02-Mar-2024','%d-%b-%Y'));
insert into invoice values (330125, STR_TO_DATE('02-Mar-2024','%d-%b-%Y'));

select * from invoice;

WITH RECURSIVE cte AS (
	SELECT MIN(serial_no) AS serial_no FROM invoice
	UNION
	SELECT serial_no+1 FROM cte WHERE serial_no < (SELECT MAX(serial_no) FROM invoice)
)
SELECT serial_no FROM cte LEFT JOIN invoice USING(serial_no) WHERE invoice_date IS NULL

