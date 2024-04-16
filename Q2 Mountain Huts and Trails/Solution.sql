drop table if exists mountain_huts;
create table mountain_huts 
(
	id 			integer not null unique,
	name 		varchar(40) not null unique,
	altitude 	integer not null
);
insert into mountain_huts values (1, 'Dakonat', 1900);
insert into mountain_huts values (2, 'Natisa', 2100);
insert into mountain_huts values (3, 'Gajantut', 1600);
insert into mountain_huts values (4, 'Rifat', 782);
insert into mountain_huts values (5, 'Tupur', 1370);

drop table if exists trails;
create table trails 
(
	hut1 		integer not null,
	hut2 		integer not null
);
insert into trails values (1, 3);
insert into trails values (3, 2);
insert into trails values (3, 5);
insert into trails values (4, 5);
insert into trails values (1, 5);

select * from mountain_huts;
select * from trails;

-- Fetch hut1's name and altitude by joining mountain_huts and trails on mountain_huts.id = trails.hut1
WITH trail_hut1_name AS (
	SELECT 
		t1.hut1 AS start_hut, h1.name AS start_hut_name, 
        h1.altitude AS start_hut_altitude, t1.hut2 AS end_hut 
	FROM mountain_huts h1
	JOIN trails t1 ON h1.id = t1.hut1
-- Fetch hut2's name and altitude by joining mountain_huts and trail_hut1_name on mountain_huts.id = trail_hut1_name.end_hut
), trail_hut2_name AS (
	SELECT th1.*,
		h2.name AS end_hut_name,
        h2.altitude AS end_hut_altitude
	FROM trail_hut1_name th1
	JOIN mountain_huts h2 ON h2.id = th1.end_hut
), swap AS (
	SELECT 
		CASE WHEN start_hut_altitude > end_hut_altitude THEN start_hut ELSE end_hut END AS start_hut,
        CASE WHEN start_hut_altitude > end_hut_altitude THEN start_hut_name ELSE end_hut_name END AS start_hut_name,
        CASE WHEN start_hut_altitude > end_hut_altitude THEN end_hut ELSE start_hut END AS end_hut,
        CASE WHEN start_hut_altitude > end_hut_altitude THEN end_hut_name ELSE start_hut_name END AS end_hut_name
    FROM trail_hut2_name
)
SELECT 
	s1.start_hut_name AS startpt,
    s1.end_hut_name AS middlept,
    s2.end_hut_name AS endpt
FROM swap s1
JOIN swap s2 ON s1.end_hut = s2.start_hut
