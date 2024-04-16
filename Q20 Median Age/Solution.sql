
-- Find the median ages of countries

drop table if exists people;
create table people
(
	id			int,
	country		varchar(20),
	age			int
);
insert into people values(1 ,'Poland',10 );
insert into people values(2 ,'Poland',5  );
insert into people values(3 ,'Poland',34   );
insert into people values(4 ,'Poland',56);
insert into people values(5 ,'Poland',45  );
insert into people values(6 ,'Poland',60  );
insert into people values(7 ,'India',18   );
insert into people values(8 ,'India',15   );
insert into people values(9 ,'India',33 );
insert into people values(10,'India',38 );
insert into people values(11,'India',40 );
insert into people values(12,'India',50  );
insert into people values(13,'USA',20 );
insert into people values(14,'USA',23 );
insert into people values(15,'USA',32 );
insert into people values(16,'USA',54 );
insert into people values(17,'USA',55  );
insert into people values(18,'Japan',65  );
insert into people values(19,'Japan',6  );
insert into people values(20,'Japan',58  );
insert into people values(21,'Germany',54  );
insert into people values(22,'Germany',6  );
insert into people values(23,'Malaysia',44  );

/*
1. The inner subquery assigns row numbers within each group using the `ROW_NUMBER()` window function partitioned by the country column and ordered by the age column for which you want to find the median.
2. It also calculates the total number of rows within each group using the `COUNT(*) OVER (PARTITION BY country)` window function.
3. The outer query filters the rows within each group to select the middle row (or rows, for even row counts) based on the total number of rows in the group.
*/

SELECT
	country,
    age
FROM ( SELECT 
			*,
			ROW_NUMBER() OVER(PARTITION BY country ORDER BY age) AS row_num,
			COUNT(*) OVER(PARTITION BY country) AS total_rows
		FROM people ) sq
WHERE row_num BETWEEN total_rows/2 AND (total_rows/2 + 1);