# テーブルスキーマ
|user| |
|:----|:----|
|Column|Type|
|id|integer|
|name|string|


|task| |
|:----|:----|
|Column|Type|
|id|integer|
|title|string|
|content|text|
|deadline|date|
|priority|integer|
|status|integer|


|label| |
|:----|:----|
|Column|Type|
|id|integer|
|labe_name|string|


|my_task|
|:----|
|id|
|user_id (FK)|
|task_id (FK)|


|labeling|
|:----|
|id|
|task_id(FK)|
|label_id(FK)|

<br>

# Herokuへのデプロイ手順
1. アプリケーションを作成  
    heroku create
1. コミット  
    git add .  
    git commit -m "init"
1. Heroku buildpackを追加  
    heroku buildpacks:set heroku/ruby  
    heroku buildpacks:add --index 1 heroku/nodejs  
1. デプロイ  
    git push heroku master  
1. データベースの移行  
    heroku run rails db:migrate  