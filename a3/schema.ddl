DROP SCHEMA if EXISTS quizschema CASCADE;
CREATE SCHEMA quizschema;
SET SEARCH_PATH to quizschema;


--CREATE TYPE question_type AS ENUM(
  --    'true-false', 'multiple choice', 'numeric');


-- a student 
CREATE TABLE student(
  id INT primary key check (id <= 9999999999), --constraint it is a 10 digit number  
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,

);

CREATE TABLE inclass(
	sid INT REFERENCES student(id),
    foreign key (room_id, teacher_id) references Class
	
);
--same room and same teacher-> what if its a split class?
--would give us error, since it has the same room and same teacher
--and that should be distinct


CREATE TABLE class(
	-- id of the room the class is located in
	--room_id INT REFERENCES room(id),

	room_id VARCHAR(50) NOT NULL,
	-- the name of the teacher
	teacher_name VARCHAR(50) NOT NULL,
	primary key (room_id, teacher_name)
);

-- can have more then one grade per class
-- cannot enforce cardinality

CREATE TABLE question(
	id INT primary key,
	description VARCHAR(1000),
    answer int, 
    upper_bound int DEFAULT 0, 
    lower_bound int DEFAULT 0, 
    hint VARCHAR(1000) DEFAULT "none", 

	--quiz_id INT REFERENCES quiz(id)
);

CREATE TABLE multiple_choice(
    question_id int REFERENCES question(id),
    hint_description VARCHAR(1000), 
    answer VARCHAR(1000)
    
);

CREATE TABLE true_false(
    question_id int REFERENCES question(id),
    answer boolean    
);

CREATE TABLE numeric_question(
    question_id int REFERENCES question(id),
    answer INT    
);


CREATE TABLE quiz(
	id INT primary key,
	title VARCHAR(50) NOT NULL, 
	due_date DATE NOT NULL,
	hint_flag boolean,
	class_id INT REFERENCES class(id)
);

--middle entity 
CREATE TABLE question_and_quiz(
    question_id INT REFERENCES question(id), 
    quiz_id INT REFERENCES quiz(id),
    question_weight int
);

--student assigned to a quiz
CREATE TABLE student_assigned_quiz(
    student_id INT REFERENCES student(id),
    quiz_id INT REFERENCES quiz(id)
);

--this would have some nulls
CREATE TABLE student_response(
    --student_id INT REFERENCES student(id),
    foreign key (student_id,quiz_id) REFERENCES student_assigned_quiz,
    foreign key (question_id, quiz_id, question_weight) REFERENCES question_and_quiz,
    -- note this implementation will give nulls
    foreign key (question_id, answer) REFERENCES multiple_choice,
    foreign key (question_id, answer) REFERENCES numeric_question,
    foreign key (question_id, answer) REFERENCES true_false

);





