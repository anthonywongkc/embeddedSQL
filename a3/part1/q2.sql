SET SEARCH_PATH to quizschema;
DROP TABLE if exists q2 cascade;

CREATE TABLE q2(
question_id INT,
question_text VARCHAR(1000),
numOfHints INT
);

-- You may find it convenient to do this for each of the views
DROP VIEW IF EXISTS question_tf CASCADE;
DROP VIEW IF EXISTS question_mc CASCADE;
DROP VIEW IF EXISTS question_num CASCADE;

CREATE VIEW question_tf AS
SELECT id AS question_id, description AS question_text
FROM question JOIN true_false ON id = question_id;

CREATE VIEW question_mc AS
SELECT q.id AS question_id, q.description AS question_text, COUNT(hint) as numOfHints
FROM question q, multiple_choice_opt o, hint_mc h
WHERE q.id = o.question_id AND o.id = h.option_id
GROUP BY q.id;

CREATE VIEW question_num AS
SELECT id AS question_id, description AS question_text, COUNT(hint) as numOfHints
FROM question JOIN hint_num ON id = question_id
GROUP BY id;

INSERT INTO q2
SELECT question_id, question_text, NULL
FROM question_tf;

INSERT INTO q2
SELECT *
FROM question_mc;

INSERT INTO q2
SELECT *
FROM question_num;

SELECT *
FROM q2
ORDER BY question_id;
