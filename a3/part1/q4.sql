SET SEARCH_PATH to quizschema;
DROP TABLE if exists q4 cascade;

CREATE TABLE q4(
student_id VARCHAR(10),
question_id INT,
question_text VARCHAR(1000)
);

-- You may find it convenient to do this for each of the views
DROP VIEW IF EXISTS classInfo CASCADE;
DROP VIEW IF EXISTS requestedQuiz CASCADE;
DROP VIEW IF EXISTS no_response_tf CASCADE;
DROP VIEW IF EXISTS no_response_mc CASCADE;
DROP VIEW IF EXISTS no_response_num CASCADE;

CREATE VIEW classInfo AS
SELECT inClass.id AS id, inClass.sid AS sid
FROM inClass JOIN class ON inClass.room_id = class.id
WHERE inClass.grade = 8 AND class.id = 'room 120' AND class.teacher_name = 'Mr Higgins';

CREATE VIEW requestedQuiz AS
SELECT sq.id AS id, c.sid AS sid
FROM student_assigned_quiz sq, classInfo c
WHERE sq.class_id = c.id AND sq.quiz_id = 'Pr1-220310';

CREATE VIEW no_response_tf AS
SELECT r.sid AS sid, s.question_id AS qid
FROM requestedQuiz r JOIN student_response_TF s ON r.id = s.quiz_student_id
WHERE s.response IS NULL;

CREATE VIEW no_response_mc AS
SELECT r.sid AS sid, s.question_id AS qid
FROM requestedQuiz r JOIN student_response_MC s ON r.id = s.quiz_student_id
WHERE s.response IS NULL;

CREATE VIEW no_response_num AS
SELECT r.sid AS sid, s.question_id AS qid
FROM requestedQuiz r JOIN student_response_NUM s ON r.id = s.quiz_student_id
WHERE s.response IS NULL;

INSERT INTO q4
SELECT n.sid AS student_id, n.qid AS question_id, q.description AS question_text
FROM no_response_tf n JOIN question q ON n.qid = q.id;

INSERT INTO q4
SELECT n.sid AS student_id, n.qid AS question_id, q.description AS question_text
FROM no_response_mc n JOIN question q ON n.qid = q.id;

INSERT INTO q4
SELECT n.sid AS student_id, n.qid AS question_id, q.description AS question_text
FROM no_response_num n JOIN question q ON n.qid = q.id;

SELECT *
FROM q4
ORDER BY student_id;

