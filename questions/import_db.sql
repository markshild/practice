CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
('Alice_f', 'Alice_l'),
('Bob_f', 'Bob_l');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('question1', 'why?', (SELECT id FROM users WHERE fname = 'Alice_f'));

INSERT INTO
  question_followers (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Bob_f'), ((SELECT id FROM questions WHERE title = 'question1')));

INSERT INTO
  replies (body, question_id, user_id, parent_reply_id)
VALUES
  ('reply1', (SELECT id FROM questions WHERE title = 'question1'), (SELECT id FROM users WHERE fname = 'Bob_f'), NULL),
  ('reply2', (SELECT id FROM questions WHERE title = 'question1'), (SELECT id FROM users WHERE fname = 'Alice_f'),
    (SELECT id FROM replies WHERE body = 'reply1'));

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'question1'), (SELECT id FROM users WHERE fname = 'Bob_f'));
