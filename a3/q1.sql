-- Report the full name and student number of all students in the database

SET SEARCH_PATH TO quizschema;
drop table if exists q1 cascade;

SELECT first_name || ' ' || last_name AS full_name, id AS student_number
FROM student;

