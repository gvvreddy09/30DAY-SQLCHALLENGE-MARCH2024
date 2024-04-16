DROP TABLE IF EXISTS Friends;

CREATE TABLE Friends
(
	Friend1 	VARCHAR(10),
	Friend2 	VARCHAR(10)
);
INSERT INTO Friends VALUES ('Jason','Mary');
INSERT INTO Friends VALUES ('Mike','Mary');
INSERT INTO Friends VALUES ('Mike','Jason');
INSERT INTO Friends VALUES ('Susan','Jason');
INSERT INTO Friends VALUES ('John','Mary');
INSERT INTO Friends VALUES ('Susan','Mary');

select * from Friends;

/*
	Logic:
	1. creates a list of pairs of friends where each pair appears twice using cte
    2. join friends table with cte on (f.friend1 = cte.friend1) to find friends(cte.friend2) of friend1 
		(simply it means find friends of friend1's Friend table in cte friend2 field)
	3. using co-related subquery select list of friends in cte friend2 field WHERE cte.friend1 = f.friend2. 
		(simply it means find friends of friend2's Friend table in cte friend2 field)  
*/

/*
	A correlated subquery is a subquery that depends on values from the outer query.
*/
WITH cte AS (
	SELECT friend1, friend2 FROM friends 
	UNION 
    SELECT friend2, friend1 FROM friends
)
SELECT 
    DISTINCT f.friend1, f.friend2, COUNT(cte.friend2) OVER(PARTITION BY f.friend1, f.friend2) AS mutual_friends
FROM friends f
LEFT JOIN cte 
	ON f.friend1 = cte.friend1
	AND cte.friend2 IN (SELECT cte.friend2 FROM cte WHERE cte.friend1 = f.friend2);
    
/*
1. **CTE (Common Table Expression) Definition:**
   ```sql
   WITH cte AS (
       SELECT friend1, friend2 FROM friends 
       UNION 
       SELECT friend2, friend1 FROM friends
   )
   ```
   - This part defines a Common Table Expression (CTE) named `cte`.
   - It selects `friend1` and `friend2` from the `friends` table and combines them using `UNION` with another select that swaps the columns (`friend2` and `friend1`).
   - This effectively creates a list of pairs of friends where each pair appears twice due to the union (e.g., if A is friends with B, the pair (A, B) will appear as (A, B) and (B, A) in the CTE).

2. **Main Query Execution:**
   ```sql
   SELECT 
       f.friend1, f.friend2, cte.friend2
   FROM friends f
   LEFT JOIN cte 
       ON f.friend1 = cte.friend1
       AND cte.friend2 IN (SELECT cte.friend2 FROM cte WHERE cte.friend1 = f.friend2);
   ```
   - The main query selects columns `friend1`, `friend2` from the `friends` table, and `friend2` from the CTE `cte`.
   - It uses a `LEFT JOIN` to join the `friends` table (`f`) with the CTE `cte`.
   - The join condition is `f.friend1 = cte.friend1`, which means matching based on the first friend in the pairs.
   - Additionally, there's a subquery in the join condition: `cte.friend2 IN (SELECT cte.friend2 FROM cte WHERE cte.friend1 = f.friend2)`. This subquery checks if the second friend in the pair from `cte` is also present as the first friend in another pair in `cte`. This is essentially checking for mutual friendships.
   - The use of `LEFT JOIN` ensures that all rows from the `friends` table are included in the result, even if there's no match in the CTE based on the join condition.

3. **Execution Order Summary:**
   a. The CTE is evaluated first, creating a list of friend pairs with duplicates removed.
   b. Then, the main query executes, joining the `friends` table with the CTE based on the specified conditions.
   c. The `LEFT JOIN` ensures that all rows from `friends` are included in the result set, even if there's no matching pair in the CTE.

The query aims to find mutual friendships by joining the `friends` table with itself using the CTE, which contains all friend pairs from the `friends` table. The subquery within the join condition further refines the results to include only mutual friendships.
*/