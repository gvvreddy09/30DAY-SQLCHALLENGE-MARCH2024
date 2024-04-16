DROP TABLE IF EXISTS brands;
CREATE TABLE brands 
(
    brand1      VARCHAR(20),
    brand2      VARCHAR(20),
    year        INT,
    custom1     INT,
    custom2     INT,
    custom3     INT,
    custom4     INT
);

INSERT INTO brands VALUES ('apple', 'samsung', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('samsung', 'apple', 2020, 1, 2, 1, 2);
INSERT INTO brands VALUES ('apple', 'samsung', 2021, 1, 2, 5, 3);
INSERT INTO brands VALUES ('samsung', 'apple', 2021, 5, 3, 1, 2);
INSERT INTO brands VALUES ('google', NULL, 2020, 5, 9, NULL, NULL);
INSERT INTO brands VALUES ('oneplus', 'nothing', 2020, 5, 9, 6, 3);

WITH cte as (
	SELECT 
		*,
		CASE
			WHEN brand1 < brand2 THEN CONCAT(brand1, brand2, year)
            WHEN brand2 IS NUll THEN CONCAT(brand1, year)
			ELSE CONCAT(brand2, brand1, year)
		END AS pair_id
	FROM
		brands
), 
cte_rn AS (
	SELECT 
		*,
		row_number() over(PARTITION BY pair_id ORDER BY pair_id) as rn	
    FROM cte 
)
SELECT brand1, brand2, year, custom1, custom2, custom3, custom4  FROM cte_rn
WHERE rn = 1 OR (custom1 <> custom3 AND custom2 <> custom4);