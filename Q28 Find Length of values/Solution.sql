-- Find length of comma seperated values in items field

drop table if exists item;
create table item
(
	id		int,
	items	varchar(50)
);
insert into item values(1, '22,122,1022');
insert into item values(2, ',6,0,9999');
insert into item values(3, '100,2000,2');
insert into item values(4, '4,44,444,4444');

select * from item;

/*
	1. No.of commas = Find the difference of string (comma seperated values)  with delimiter and without delimiter.
    2. No.of.values = No.of commas+1
    3. Generate a rows that is equal to No.of.values
    4. Using SUBSTRING_INDEX find the output
*/

WITH RECURSIVE cte AS (
	SELECT 1 AS n
    UNION
    SELECT n+1 from cte WHERE n<(SELECT MAX(CHAR_LENGTH(items) - CHAR_LENGTH(REPLACE(items, ',', '')))+1 FROM item)
), split_values AS (
	SELECT 
		id,
		SUBSTRING_INDEX(SUBSTRING_INDEX(items, ',', cte.n), ',', -1) AS split_value
	FROM item
	JOIN cte
	ON cte.n <= CHAR_LENGTH(items) - CHAR_LENGTH(REPLACE(items, ',', '')) + 1
)
SELECT id, REVERSE(GROUP_CONCAT(length)) AS LENGTHS
FROM (SELECT id, LENGTH(split_value) AS length FROM split_values) sv
GROUP BY id;
    
select items,n, 
	-- char_length(items) as 'len_with_delimiter',
    -- char_length(replace(items, ',', '')) as 'len_without_delimiter',
    CHAR_LENGTH(items) - CHAR_LENGTH(REPLACE(items, ',', '')) as 'diff' 
from item
join (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) numbers
on CHAR_LENGTH(items) - CHAR_LENGTH(REPLACE(items, ',', '')) >= numbers.n - 1;
