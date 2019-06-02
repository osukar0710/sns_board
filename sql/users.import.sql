drop table if  exists users; 

CREATE TABLE users (
  id SERIAL NOT NULL PRIMARY KEY ,
  name VARCHAR( 25 ) NOT NULL ,
  email VARCHAR( 35 ) NOT NULL ,
  password VARCHAR( 60 ) NOT NULL ,
  img_path VARCHAR( 255 ),
  UNIQUE (email)
);

-- サンプル　
INSERT INTO users (name, email, password, img_path)
VALUES ('higa', 'higa@email.com','higa', 'img/myicon.png');
INSERT INTO users (name, email, password, img_path)
VALUES ('sato', 'sato@email.com','sato', 'img/sato_icon.png');
INSERT INTO users (name, email, password, img_path)
VALUES ('yamashiro', 'yamashiro@email.com','yamashiro', 'img/yamashiro.png');
INSERT INTO users (name, email, password, img_path)
VALUES ('yakabi', 'yakabi@email.com','yakabi', 'img/default.png');
INSERT INTO users (name, email, password, img_path)
VALUES ('tamaki', 'tamaki@email.com','tamaki', 'img/default.png');
INSERT INTO users (name, email, password, img_path)
VALUES ('uehara', 'uehara@email.com','uehara', 'img/default.png');