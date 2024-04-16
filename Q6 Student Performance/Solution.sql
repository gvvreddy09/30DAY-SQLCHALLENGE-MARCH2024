drop table if exists  student_tests;
create table student_tests
(
	test_id		int,
	marks		int
);
insert into student_tests values(100, 55);
insert into student_tests values(101, 55);
insert into student_tests values(102, 60);
insert into student_tests values(103, 58);
insert into student_tests values(104, 40);
insert into student_tests values(105, 50);

select * from student_tests;

-- OUTPUT 2
SELECT 
    c_row.test_id, c_row.marks
FROM
    student_tests c_row
        LEFT JOIN
    student_tests p_row ON c_row.test_id = p_row.test_id + 1
WHERE
    c_row.marks > p_row.marks;

-- OUTPUT 1        
SELECT 
    c_row.test_id, c_row.marks
FROM
    student_tests c_row
        LEFT JOIN
    student_tests p_row ON c_row.test_id = p_row.test_id + 1
WHERE
    c_row.marks > p_row.marks
        OR p_row.marks IS NULL;

/*with cte as (
	select c_row.test_id, c_row.marks,
		case
			when c_row.marks > p_row.marks then 1
			when p_row.marks is null then 1
			else 0
		end as temp
	from student_tests c_row 
	left join student_tests p_row on c_row.test_id = p_row.test_id + 1
)
select test_id, marks from cte where temp = 1;
*/

SELECT 
    *
FROM
    student_tests c_row
        LEFT JOIN
    student_tests p_row ON c_row.test_id = p_row.test_id + 1;
