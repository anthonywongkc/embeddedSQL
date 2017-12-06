DROP SCHEMA if EXISTS quizschema CASCADE;
CREATE SCHEMA quizschema;
SET SEARCH_PATH to quizschema;

-- 1.What Constraints from the domain could not be enforced?

-- Cardniality Constraints, such as always having at least two answers 
-- for a multiple choice question. These type of constraints are very
-- difficult to accomplish in sql without using complicated subqueries
-- It is not possible to do without subqueries or functions.
-- We could have has two foreign keys, but a multiple choice question could have MORE then 2 answers.

-- 2. What constraints that could have been enforced were not enforced? why not? 
-- Similar to above the constraint split classes was ambiguous. we could have defined it to be 
-- strictly one or two and had direct attributes for them in class, but this would have resulted in nulls
-- for any class with only one grade (which we assume would be most of them). Instead we put the grade with
-- the intermediate relation inclass meaning it is tied to a class/student combination. This meant that technically
-- a class could contain more then one grade.

-- Another constraint was that correct answers cannot have a hint associated with them.
-- With our implementation correct and incorrect answers are both in the same relation:
-- the multiple_choice_opt relation. While the Multiple_choice relation can distinguish the correct 
-- answer with its foreign key, since correct and incorrect have the same relation, correct answers can
-- also be associated with a hint. We chose not to enforce this since we already had many levels to our scheme
-- ie. Question -> Multiple_choice -> multiple_choice_opt -> hint_mc
-- adding relations for correct and incorrect answers would have added to the complexity 

-- The next constraint was the numerical hint, and the upper and lower bound. In our implementation
-- the hint for numerical questions is seperate from the answer which is contained with the question.
-- We could have enforced this, but would have required a foreign key inside hint_num to the numerical question
-- AND the base question. We chose to implement it only needing a foreign key to the base question relation.

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
CREATE TABLE class(
    -- id of the room the class is located in
    id VARCHAR(50) PRIMARY KEY,
    -- the name of the teacher
    teacher_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE inClass(
    id INT PRIMARY KEY,
	sid VARCHAR(10) REFERENCES student(id),
    room_id VARCHAR(50) REFERENCES class(id),
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
    id INT PRIMARY KEY,
    class_id INT REFERENCES inClass(id),
    quiz_id VARCHAR(50) REFERENCES quiz(id)
);

CREATE TABLE student_response_TF(
    quiz_student_id INT REFERENCES student_assigned_quiz(id),
    question_id INT REFERENCES question(id),
    response BOOLEAN
);

CREATE TABLE student_response_MC(
    quiz_student_id INT REFERENCES student_assigned_quiz(id),
    question_id INT REFERENCES question(id),
    response VARCHAR(1000)
);

CREATE TABLE student_response_NUM(
    quiz_student_id INT REFERENCES student_assigned_quiz(id),
    question_id INT REFERENCES question(id),
    response INT
);






