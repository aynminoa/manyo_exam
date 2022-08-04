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
