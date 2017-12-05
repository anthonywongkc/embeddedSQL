
SET SEARCH_PATH TO quizschema;

DROP TABLE IF EXISTS q5 CASCADE;
DROP VIEW IF EXISTS in_higgens_8 CASCADE;
DROP VIEW IF EXISTS quiz_questions CASCADE;
DROP VIEW IF EXISTS TF_quiz_response CASCADE;
DROP VIEW IF EXISTS NUM_quiz_response CASCADE;
DROP VIEW IF EXISTS MC_quiz_response CASCADE;


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
SELECT i.last_name, i.student_id, sr.response,tf.answer,q.question_weight, q.id
FROM quiz_questions q, in_higgens_8 i, student_response_TF sr, true_false tf
WHERE i.quiz_id = q.quiz_id AND sr.question_id = q.id 
	AND sr.quiz_student_id = i.sq_id AND tf.question_id = q.id
);


CREATE VIEW NUM_quiz_response as (
SELECT i.last_name, i.student_id, sr.response, nf.answer,q.question_weight, q.id
FROM quiz_questions q, in_higgens_8 i, student_response_NUM sr, numeric_choice nf
WHERE i.quiz_id = q.quiz_id AND sr.question_id = q.id 
	AND sr.quiz_student_id = i.sq_id AND nf.question_id = q.id
);
CREATE VIEW MC_quiz_response as (
SELECT i.last_name, i.student_id, sr.response,q.question_weight,mc.answer_id,mco.option as answer, q.id
FROM quiz_questions q, in_higgens_8 i, student_response_MC sr, 
	multiple_choice mc, multiple_choice_opt mco 
WHERE i.quiz_id = q.quiz_id AND sr.question_id = q.id AND 
	sr.quiz_student_id = i.sq_id AND mc.question_id = q.id AND mc.answer_id = mco.id
);

CREATE TABLE q5 (
	question_id INT,
	num_right INT default 0,
	num_wrong INT default 0, 
	num_na INT default 0 
);

INSERT INTO q5
SELECT q.id from quiz_questions q;

INSERT into q5
select t.id as question_id, count(*)as num_right
from TF_quiz_response t WHERE response = answer
group by t.id
;
INSERT into q5
select t.id as question_id, 0,0, count(*)as num_na
from TF_quiz_response t WHERE response is NULL
group by t.id
;
INSERT into q5
select t.id as question_id, 0,count(*)as num_wrong
from TF_quiz_response t WHERE response != answer and response is not NULL
group by t.id
;


--select* from q5
--order by question_id;

INSERT into q5
select t.id as question_id, count(*)as num_right
from NUM_quiz_response t WHERE response = answer
group by t.id
;
INSERT into q5
select t.id as question_id,0,0, count(*)as num_na
from NUM_quiz_response t WHERE response is NULL
group by t.id
;
INSERT into q5
select t.id as question_id, 0,count(*)as num_wrong
from NUM_quiz_response t WHERE response != answer and response is not NULL
group by t.id
;


INSERT into q5
select t.id as question_id, count(*)as num_right
from MC_quiz_response t WHERE response = answer
group by t.id
;
INSERT into q5
select t.id as question_id,0,0, count(*)as num_na
from MC_quiz_response t WHERE response is NULL
group by t.id
;
INSERT into q5
select t.id as question_id, 0,count(*)as num_wrong
from MC_quiz_response t WHERE response != answer and response is not NULL
group by t.id
;

select question_id, sum(num_right)as answered_correctly, sum(num_wrong) as answered_incorrectly, sum(num_na) as did_not_answer 
FROM q5 
GROUP BY question_id
ORDER BY question_id;
--SELECT * from q5;
--all questions
--CREATE VIEW 


--question id, num right, num wrong, num no reponse
