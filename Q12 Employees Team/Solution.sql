DROP TABLE IF EXISTS company;
CREATE TABLE company
(
	employee	varchar(10) primary key,
	manager		varchar(10)
);

INSERT INTO company values ('Elon', null);
INSERT INTO company values ('Ira', 'Elon');
INSERT INTO company values ('Bret', 'Elon');
INSERT INTO company values ('Earl', 'Elon');
INSERT INTO company values ('James', 'Ira');
INSERT INTO company values ('Drew', 'Ira');
INSERT INTO company values ('Mark', 'Bret');
INSERT INTO company values ('Phil', 'Mark');
INSERT INTO company values ('Jon', 'Mark');
INSERT INTO company values ('Omid', 'Earl');

-- STEPS
-- 1.Find out boss of the company (Hint: Boss manager is null)
-- 2.Identify no.of teams (Hint: People who are reporting to the boss forms teams) 

WITH RECURSIVE cte AS(
	WITH cte_teams AS 
    (
		SELECT e.employee, Concat('Team', ROW_NUMBER() OVER()) AS 'Teams'
		FROM company e JOIN 
		(SELECT * FROM company  WHERE manager IS NULL) root ON root.employee = e.manager
	)

	SELECT c.employee, c.manager, cte_teams.teams 
	FROM company c 
	CROSS JOIN cte_teams
	WHERE c.manager IS NULL
	UNION
	SELECT company.employee, company.manager, COALESCE(cte_teams.teams, cte.teams)
	FROM company 
	JOIN cte ON cte.employee = company.manager
	LEFT JOIN cte_teams ON company.employee = cte_teams.employee
)
SELECT teams, group_concat(employee) AS members FROM cte
GROUP BY teams;

