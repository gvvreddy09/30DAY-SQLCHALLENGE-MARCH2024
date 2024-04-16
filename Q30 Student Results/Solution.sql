/*
PROBLEM STATEMENT: Given tables represent the marks scored by engineering students.
Create a report to display the following results for each student.
  - Student_id, Student name
  - Total Percentage of all marks
  - Failed subjects (must be comma seperated values in case of multiple failed subjects)
  - Result (if percentage >= 70% then 'First Class', if >= 50% & <=70% then 'Second class', if <=50% then 'Third class' else 'Fail'.
  			The result should be Fail if a students fails in any subject irrespective of the percentage marks)
	
	*** The sequence of subjects in student_marks table match with the sequential id from subjects table.
	*** Students have the option to choose either 4 or 5 subjects only.
*/

drop table if exists student_marks;
drop table if exists students;
drop table if exists subjects;

create table students
(
	roll_no		varchar(20) primary key,
	name		varchar(30)		
);
insert into students values('2GR5CS011', 'Maryam');
insert into students values('2GR5CS012', 'Rose');
insert into students values('2GR5CS013', 'Alice');
insert into students values('2GR5CS014', 'Lilly');
insert into students values('2GR5CS015', 'Anna');
insert into students values('2GR5CS016', 'Zoya');


create table student_marks
(
	student_id		varchar(20) primary key references students(roll_no),
	subject1		int,
	subject2		int,
	subject3		int,
	subject4		int,
	subject5		int,
	subject6		int
);
insert into student_marks values('2GR5CS011', 75, NULL, 56, 69, 82, NULL);
insert into student_marks values('2GR5CS012', 57, 46, 32, 30, NULL, NULL);
insert into student_marks values('2GR5CS013', 40, 52, 56, NULL, 31, 40);
insert into student_marks values('2GR5CS014', 65, 73, NULL, 81, 33, 41);
insert into student_marks values('2GR5CS015', 98, NULL, 94, NULL, 90, 20);
insert into student_marks values('2GR5CS016', NULL, 98, 98, 81, 84, 89);


create table subjects
(
	id				varchar(20) primary key,
	name			varchar(30),
	pass_marks  	int check (pass_marks>=30)
);
insert into subjects values('S1', 'Mathematics', 40);
insert into subjects values('S2', 'Algorithms', 35);
insert into subjects values('S3', 'Computer Networks', 35);
insert into subjects values('S4', 'Data Structure', 40);
insert into subjects values('S5', 'Artificial Intelligence', 30);
insert into subjects values('S6', 'Object Oriented Programming', 35);


select * from students;
select * from student_marks;
select * from subjects;

-- 1. Unpivoting (columns -> rows) student marks table
WITH student_marks_unpivot AS (
	SELECT student_id, 'S1' AS subject, subject1 AS marks FROM student_marks
	UNION ALL
	SELECT student_id, 'S2' AS subject, subject2 AS marks FROM student_marks
	UNION ALL
	SELECT student_id, 'S3' AS subject, subject3 AS marks FROM student_marks
	UNION ALL
	SELECT student_id, 'S4' AS subject, subject4 AS marks FROM student_marks
	UNION ALL
	SELECT student_id, 'S5' AS subject, subject5 AS marks FROM student_marks
	UNION ALL
	SELECT student_id, 'S6' AS subject, subject6 AS marks FROM student_marks
), 
-- 2. Check if the student failed in any of the subjects. 
	-- If Yes, extract that subject
pass_fail AS (
	SELECT *,
		CASE
			WHEN sm.marks IS NOT NULL AND sm.marks>=s.pass_marks THEN NULL
			WHEN sm.marks IS NULL THEN NULL
			ELSE name
		END AS failed_subject
	FROM student_marks_unpivot sm
	JOIN subjects s ON s.id = sm.subject
), 
-- 3. Group By student_id and calculate percentage_marks, group failed_subjects
students_failed AS (
	SELECT 
		student_id, 
		ROUND(SUM(marks)/COUNT(marks), 2) AS percentage_marks, 
		TRIM(GROUP_CONCAT(" ", failed_subject)) AS failed_subject 
	FROM pass_fail
	GROUP BY student_id
),
-- 4. Calculate result based on the given conditions
result AS (
	SELECT
		student_id, percentage_marks,
        IF(failed_subject IS NULL, "-", failed_subject) AS failed_subject,
        CASE
			WHEN percentage_marks>=70 AND failed_subject IS NULL THEN "First Class"
            WHEN (percentage_marks>=50 AND percentage_marks<70) AND failed_subject IS NULL THEN "Second Class"
            WHEN percentage_marks<50 AND failed_subject IS NULL THEN "Third Class"
            ELSE "Fail"
		END AS result
	FROM students_failed
)
SELECT student_id, name, percentage_marks, failed_subject, result
FROM result r 
JOIN students s ON r.student_id = s.roll_no
