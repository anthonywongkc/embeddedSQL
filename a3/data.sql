-- The data of our schema -> ONLY EXAMPLE DATA
-- Insert our students
INSERT INTO student (id, first_name, last_name) VALUES 
    ('0998801234', 'Lena', 'Headey'),
    ('0010784522', 'Peter', 'Dinklage'),
    ('0997733991', 'Emilia', 'Clarke'),
    ('5555555555', 'Kit', 'Harrington'), 
    ('1111111111', 'Sophie',  'Turner'), 
    ('2222222222', 'Maisie', 'Williams');

INSERT INTO room (id, teacher_name) VALUES
    ('room 120','Mr Higgins'), 
    ('room 366', 'Miss Nyers');


-- --Insert our class
INSERT INTO class (id, sid, room_id, grade) VALUES
    (0, '0998801234', 'room 120', 8), 
    (1, '0010784522', 'room 120', 8),
    (2, '0997733991', 'room 120', 8),
    (3, '5555555555', 'room 120', 8),
    (4, '1111111111', 'room 120', 8), 
    (5, '2222222222', 'room 366', 5);
--Is this redudant?

--Insert our quiz
Insert INTO quiz (id, title, due_date, hint_flag) VALUES 
    ('Pr1-220310', 'Citizenship Test Practise Questions', '1997-12-17 07:37:16.00 PST', True);
    -- 1997-12-17 07:37:16.00 PST Wed Dec 17 07:37:16 1997 PST

INSERT INTO question (id, description)  VALUES 
    (782, 'What do you promise when you take the oath of citizenship?'), 
    (566, 'The Prime Minister, Justin Trudeau, is Canada''s Head of State.' ), 
    (601, 'During the ''Quiet Revolution,'' Quebec experienced rapid change. In what
           decade did this occur? (Enter the year that began the decade, e.g., 1840.'), 
    (625, 'What is the Underground Railroad?'), 
    (790, 'During the War of 1812 the Americans burned down the Parliament Buildings in
           York (now Toronto). What did the British and Canadians do in return?');

INSERT INTO true_false (question_id, answer) VALUES
    (566, 'False');

INSERT INTO multiple_choice_opt (id, question_id, option) VALUES
    (0, 782, 'To pledge your loyalty to the Sovereign, Queen Elizabeth II'), 
    (1, 782, 'To pledge your allegiance to the flag and fulfill the duties of a Canadian'),
    (2, 782, 'To pledge your allegiance to the flag and fulfill the duties of a Canadian'),  
    (3, 782, 'To pledge your loyalty to Canada from sea to sea'), 
    (4, 625, 'The first railway to cross Canada'), 
    (5, 625, 'The CPR''s secret railway line' ),
    (6, 625, 'The TTC subway system'), 
    (7, 625, 'A network used by slaves who escaped the United States into Canada'),
    (8, 790, 'They attacked American merchant ships'),
    (9, 790, 'They expanded their defence system, including Fort York'),
    (10, 790, 'They burned down the White House in Washington D.C.'),
    (11, 790, 'They captured Niagara Falls');

INSERT INTO multiple_choice (question_id, answer_id) VALUES
    (782, 0),
    (625, 7),
    (790, 10);

INSERT INTO hint_mc (option_id, hint) VALUES
    (2, 'Think regally.'), 
    (4, 'The Underground Railroad was generally south to north, not east-west.'), 
    (5, 'The Underground Railroad was secret, but it had nothing to do with trains.' ), 
    (6, 'The TTC is relatively recent; the Underground Railroad was in operation over 100 years ago.');
    -- multiple choice hints are associated with specific answers
    -- we could add a reference to the multiple_choice relation??

INSERT INTO numeric_choice (question_id, answer) VALUES
    (601, '1960');
    -- may need to abstract away hints since they will also require a text!
    -- also the repeat in answer is redundant?
    -- perhaps into a numeric_hint

INSERT INTO hint_num (question_id, hint, lower_bound, upper_bound) VALUES
    (601, 'The Quiet Revolution happened during the 20th Century.', 1800, 1900),
    (601, 'The Quiet Revolution happened some time ago.', 2000, 2010),
    (601, 'The Quiet Revolution has already happened!', 2020, 3000);

INSERT INTO question_and_quiz (quiz_id, question_id, question_weight) VALUES
    ('Pr1-220310', 601, 2), 
    ('Pr1-220310', 566, 1),
    ('Pr1-220310', 790, 3), 
    ('Pr1-220310', 625, 2);

INSERT INTO student_assigned_quiz (id, class_id, quiz_id) VALUES   
    (0, 0, 'Pr1-220310'), 
    (1, 1, 'Pr1-220310'), 
    (2, 2, 'Pr1-220310'), 
    (3, 3, 'Pr1-220310'),  
    (4, 4, 'Pr1-220310');

INSERT INTO student_response_TF (quiz_id, student_id, question_id, response) VALUES
    ('Pr1-220310', '0998801234', 566, False), 
    ('Pr1-220310', '0010784522', 566, False), 
    ('Pr1-220310', '0997733991', 566, True), 
    ('Pr1-220310', '5555555555', 566, False);
    --(1111111111,566,  ) did not answer


INSERT INTO student_response_MC (quiz_id, student_id, question_id, response) VALUES
    ('Pr1-220310', '0998801234', 782, 'They expanded their defence system, including Fort York'), 
    ('Pr1-220310', '0010784522', 782, 'They burned down the White House in Washington D.C.' ), 
    ('Pr1-220310', '0997733991', 782, 'They burned down the White House in Washington D.C.' ), 
    ('Pr1-220310', '5555555555', 782, 'They captured Niagara Falls' ),  
    ('Pr1-220310', '0998801234', 625, 'A network used by slaves who escaped the United States into Canada'), 
    ('Pr1-220310', '0010784522', 625, 'A network used by slaves who escaped the United States into Canada' ), 
    ('Pr1-220310', '0997733991', 625, 'The CPR''s secret railway line' );
    -- (5555555555, 625,  ),  NO reponse given
    -- (1111111111, did not respond

INSERT INTO student_response_NUM (quiz_id, student_id, question_id, response) VALUES
    ('Pr1-220310', '0998801234', 601, 1950), 
    ('Pr1-220310', '0010784522', 601,1960 ), 
    ('Pr1-220310', '0997733991', 601, 1960);
    -- (5555555555, 601,  ); no responce given
    --(1111111111, did not respond













