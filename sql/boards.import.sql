drop table if  exists boards; 
CREATE TABLE boards (
  id SERIAL NOT NULL PRIMARY KEY ,
  title varchar( 50 ),
  content text,
  user_id int,
  created timestamp default 'now'
  );
-- -- サンプル
INSERT INTO boards (title, content, user_id)
VALUES ('初心者rubyおすすめ参考書', 'ゼロからわかるRuby入門', 1);

INSERT INTO boards (title, content, user_id)
VALUES ('自宅警備員の内容', 'アニメ鑑賞、ゲーム解析、プログラミング', 2);

INSERT INTO boards (title, content, user_id)
VALUES ('セブンイレブン', '沖縄全域7月11日にOPEN', 3);

INSERT INTO boards (title, content, user_id)
VALUES ('おすすめの学習Cafe', '那覇新都心にある1 or 8', 1);

INSERT INTO boards (title, content, user_id)
VALUES ('test', 'testtesttest', 4);

INSERT INTO boards (title, content, user_id)
VALUES ('沖縄の方言', '最近の若者はあまり使わんな〜', 5);