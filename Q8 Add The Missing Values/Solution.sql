drop table if exists job_skills;
create table job_skills
(
	row_id		int,
	job_role	varchar(20),
	skills		varchar(20)
);
insert into job_skills values (1, 'Data Engineer', 'SQL');
insert into job_skills values (2, null, 'Python');
insert into job_skills values (3, null, 'AWS');
insert into job_skills values (4, null, 'Snowflake');
insert into job_skills values (5, null, 'Apache Spark');
insert into job_skills values (6, 'Web Developer', 'Java');
insert into job_skills values (7, null, 'HTML');
insert into job_skills values (8, null, 'CSS');
insert into job_skills values (9, 'Data Scientist', 'Python');
insert into job_skills values (10, null, 'Machine Learning');
insert into job_skills values (11, null, 'Deep Learning');
insert into job_skills values (12, null, 'Tableau');

-- Solution1
WITH RECURSIVE cte AS 
(
	SELECT * FROM job_skills WHERE row_id = 1
    UNION
    SELECT j.row_id, COALESCE(j.job_role, cte.job_role), j.skills 
    FROM cte 
    JOIN job_skills j ON j.row_id = cte.row_id + 1
)
SELECT * FROM cte;

-- Solution2
WITH cte AS (
	SELECT *,
		SUM(CASE WHEN job_role IS NULL THEN 0 ELSE 1 END) OVER(ORDER BY row_id) AS flag
	FROM job_skills
)
SELECT 
	row_id, FIRST_VALUE(job_role) OVER(PARTITION BY flag ORDER BY row_id) AS job_role, skills
FROM cte