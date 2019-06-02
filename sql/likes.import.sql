drop table if  exists likes; 

CREATE TABLE likes (
  id SERIAL NOT NULL PRIMARY KEY ,
  user_id int,
  board_id int
);


INSERT INTO likes (user_id, board_id)
VALUES (1, 1);
INSERT INTO likes (user_id, board_id)
VALUES (2, 1);
INSERT INTO likes (user_id, board_id)
VALUES (3, 1);
INSERT INTO likes (user_id, board_id)
VALUES (4, 1);
INSERT INTO likes (user_id, board_id)
VALUES (5, 1);