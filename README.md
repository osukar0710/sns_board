# 機能
簡易掲示板 

## ツール概要（Overview）
Sinatraで制作した簡易掲示板サイト

## 説明（Description）
- ログイン/ログアウト機能　
- 画像投稿機能　
- 掲示板投稿機能
- 削除機能　
- (Twitterなどの)いいね機能
- ユーザー編集機能
- SQLインジェクション対策　：エスケープ処理、バリデーションチェック　

##DEMO MOVE

![circleanimationmuvie](https://github.com/osukar0710/sns_board/blob/master/sns_board.mov.gif)


## 使い方(Usage)

開発環境

    ruby 2.6.2
    psql (PostgreSQL) 11.2

> `bundler`のインストール
```
gem install bundler
```
> 必要なGemインストール (ここでsinatraもインストール)
Gemfileがあるディレクトリ内で
```
bundler install
```
> データベース作成
```
createdb codebase_task
```
事前にpostgeSQLは起動しておく
- 起動：`brew services start postgresql`
- 停止：`brew services stop postgresql`
`app.rb`内のファイルのデータベース」接続名は`codebase_task`で作成したいるため。
名称は任意です。

> テーブルインストール

ターミナル　`cd`コマンドで
sqlフォルダに移動
psql `codebase_task`でデータベースにログイン
３つのファイルのインストール実行
```
\i boards.import.sql
\i likes.import.sql
\i users.import.sql
```

> sinatra起動
app.rbがあるディレクトリ内で
```
ruby app.rb -o 0.0.0.0
```
　# 使用したスキル
 HTML


## Licence
MIT　Licence
