DROP SCHEMA if EXISTS quizschema CASCADE;
CREATE SCHEMA quizschema;
SET SEARCH_PATH to quizschema;


--CREATE TYPE question_type AS ENUM(
  --    'true-false', 'multiple choice', 'numeric');


-- a student 
CREATE TABLE student(
  id VARCHAR(10) PRIMARY KEY, --constraint it is a 10 digit number  
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  check(length(id) = 10)
);

--same room and same teacher-> what if its a split class?
--would give us error, since it has the same room and same teacher
--and that should be distinct
CREATE TABLE room(
    -- id of the room the class is located in
    id VARCHAR(50) PRIMARY KEY,
    -- the name of the teacher
    teacher_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE class(
    id INT PRIMARY KEY,
	sid VARCHAR(10) REFERENCES student(id),
    room_id VARCHAR(50) REFERENCES room(id),
    grade INT NOT NULL
    -- foreign key (room_id, teacher_id) references Class
);

-- can have more then one grade per class
-- cannot enforce cardinality

CREATE TABLE quiz(
    id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(50) NOT NULL, 
    due_date DATE NOT NULL,
    hint_flag BOOLEAN
    -- class_id INT REFERENCES class(id)
);

CREATE TABLE question(
    id INT PRIMARY KEY,
    description VARCHAR(1000)
);

CREATE TABLE true_false(
    question_id INT REFERENCES question(id),
    answer BOOLEAN    
);

CREATE TABLE multiple_choice_opt(
    id INT PRIMARY KEY,
    question_id INT REFERENCES question(id),
    option VARCHAR(1000)
    
);

CREATE TABLE multiple_choice(
    question_id INT REFERENCES question(id),
    answer_id INT REFERENCES multiple_choice_opt(id)
    
);

CREATE TABLE hint_mc(
    option_id int REFERENCES multiple_choice_opt(id),
    hint VARCHAR(1000)
);

CREATE TABLE numeric_choice(
    question_id INT REFERENCES question(id),
    answer INT
);

CREATE TABLE hint_num(
    question_id int REFERENCES question(id),
    hint VARCHAR(1000),
    lower_bound INT,
    upper_bound INT
);

--middle entity 
CREATE TABLE question_and_quiz(
    quiz_id VARCHAR REFERENCES quiz(id),
    question_id INT REFERENCES question(id), 
    question_weight int
);

--student assigned to a quiz
CREATE TABLE student_assigned_quiz(
    id VARCHAR(10) PRIMARY KEY,
    class_id INT REFERENCES class(id),
    quiz_id VARCHAR(50) REFERENCES quiz(id)
);

CREATE TABLE student_response_TF(
    quiz_id VARCHAR REFERENCES quiz(id),
    student_id VARCHAR(10) REFERENCES student(id),
    question_id INT REFERENCES question(id),
    response BOOLEAN
);

CREATE TABLE student_response_MC(
    quiz_id VARCHAR REFERENCES quiz(id),
    student_id VARCHAR(10) REFERENCES student(id),
    question_id INT REFERENCES question(id),
    response VARCHAR(1000)
);

CREATE TABLE student_response_NUM(
    quiz_id VARCHAR REFERENCES quiz(id),
    student_id VARCHAR(10) REFERENCES student(id),
    question_id INT REFERENCES question(id),
    response INT
);

-- --this would have some nulls
-- CREATE TABLE student_response(
--     --student_id INT REFERENCES student(id),
--     foreign key (student_id,quiz_id) REFERENCES student_assigned_quiz,
--     foreign key (question_id, quiz_id, weight) REFERENCES question,
--     -- note this implementation will give nulls
--     foreign key (question_id, answer) REFERENCES multiple_choice,
--     foreign key (question_id, answer) REFERENCES numeric_question,
--     foreign key (question_id, answer) REFERENCES true_false

-- );





