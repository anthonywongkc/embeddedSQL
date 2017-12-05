SET SEARCH_PATH TO quizschema;
--drop table if exists q2 cascade;


--Compute the grade and total score on quiz Pr1-220310 for every student 
--in the grade 8 class in room 120 with
--Mr Higgins. Report the student number, last name, and total grade.

DROP TABLE IF EXISTS q3 CASCADE;
DROP VIEW IF EXISTS in_higgens_8 CASCADE;
DROP VIEW IF EXISTS quiz_questions CASCADE;
DROP VIEW IF EXISTS TF_quiz_response CASCADE;
DROP VIEW IF EXISTS NUM_quiz_response CASCADE;
DROP VIEW IF EXISTS MC_quiz_response CASCADE;

-- all the students in grade 8 and higgens rm 120 class
-- and took the quiz
CREATE VIEW in_higgens_8 as (
SELECT s.first_name, s.last_name, s.id as student_id, c.id as class_id, 
		c.teacher_name, i.grade, i.id as inclass_id, sq.quiz_id, sq.id as sq_id
FROM student s, class c, inclass i, student_assigned_quiz sq
WHERE c.id = 'room 120' AND c.teacher_name = 'Mr Higgins' AND i.sid = s.id 
	AND i.room_id = c.id AND i.grade = 8  AND sq.class_id = i.id AND sq.quiz_id = 'Pr1-220310'
);

--quiz pri-220310 and all of its questions
CREATE VIEW quiz_questions as (
SELECT q.quiz_id , q.question_weight, q2.description as question, q2.id
FROM question_and_quiz q, question q2
WHERE q.quiz_id = 'Pr1-220310' AND q.question_id = q2.id
);


CREATE VIEW TF_quiz_response as (
SELECT i.last_name, i.student_id, sr.response,tf.answer,q.question_weight
FROM quiz_questions q, in_higgens_8 i, student_response_TF sr, true_false tf
WHERE i.quiz_id = q.quiz_id AND sr.question_id = q.id 
	AND sr.quiz_student_id = i.sq_id AND tf.question_id = q.id
);

CREATE VIEW NUM_quiz_response as (
SELECT i.last_name, i.student_id, sr.response, nf.answer,q.question_weight
FROM quiz_questions q, in_higgens_8 i, student_response_NUM sr, numeric_choice nf
WHERE i.quiz_id = q.quiz_id AND sr.question_id = q.id 
	AND sr.quiz_student_id = i.sq_id AND nf.question_id = q.id
);
CREATE VIEW MC_quiz_response as (
SELECT i.last_name, i.student_id, sr.response,q.question_weight,mc.answer_id,mco.option as answer
FROM quiz_questions q, in_higgens_8 i, student_response_MC sr, 
	multiple_choice mc, multiple_choice_opt mco 
WHERE i.quiz_id = q.quiz_id AND sr.question_id = q.id AND 
	sr.quiz_student_id = i.sq_id AND mc.question_id = q.id AND mc.answer_id = mco.id
);

CREATE TABLE q3 (
	student_id VARCHAR(10),
	last_name VARCHAR(50) NOT NULL,
	question_mark INT default 0 
);

INSERT INTO q3
select t.student_id as student_id, t.last_name as last_name 
from in_higgens_8 t;

Insert into q3
select t.student_id, t.last_name, t.question_weight as question_mark 
from TF_quiz_response t WHERE response = answer;
INSERT INTO Q3
select t.student_id, t.last_name, t.question_weight as question_mark
from NUM_quiz_response t WHERE response = answer;
INSERT INTO Q3
select t.student_id,t.last_name, t.question_weight as question_mark 
from MC_quiz_response t where t.response = t.answer; 



select student_id, last_name, sum(question_mark) as total_marks
from q3
group by student_id,last_name;

