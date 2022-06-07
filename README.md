# 課程API

##  開發工具
- Ruby 3.1.2
- Rails 7.0.3
- RSpec 3.11.0

由於有使用到Ruby2.7+的語法
至少須使用Ruby2.7才能正常運作

## 啓動方式
```
bundle install
bundle exec rails server
```

## API

|方法|路徑|參數|回應|解釋|
|---|---|---|---|---|
|POST|/users|name: String, email: String|msg: String|建立user|
|GET|/users/{:id}|no|id: Integer, name: String, email: String|查詢一筆user|
|GET|/users/search?email=&name=|email: String, name: String|id: Integer, name: String, email: String|根據email或name查詢一筆user|
|PUT|/users/{:id}|name: String, email: String|id: Integer, name: String, email: String|更新一筆user|
|DELETE|/users/{:id}|id: Integer|no|刪除一筆user|
|GET|/courses/{:id}/users|no|[{ id: Integer, name: String, email: String }...]|查詢與某一筆course相關的所有users|
|POST|/enrollments|user_id: Integer, course_id: Integer, role: String|id: Integer, user_id: Integer, course_id: Integer, role: String|建立一筆course與user的關聯(enrollment)|
|DELETE|/enrollments/{:id}|no|no|刪除一筆enrollment|
|GET|/enrollments/{:id}|no|id: Integer, user_id: Integer, course_id: Integer, role: String|根據id查詢一筆enrollment|
|GET|/enrollments/search?user_id=&course_id=&role=|user_id: Integer, course_id: Integer, role: String|[{ id: Integer, user_id: Integer, course_id: Integer, role: String }]|根據 user_id, course_id, 或 role 查詢多筆 enrollments|
|GET|/courses/{:id}|no|id: Integer, name: String|根據id查詢一筆course|
|GET|/users/{:id}/courses|no|[{ id: Integer, name: String }]|根據user_id查詢相關的多筆courses|
|GET|/make_me_wool|no|token: String|取得用於測試的admin JWT token|


## 須注意的部分

- 這個demo不使用資料庫, 資料儲存在 Data 變數下面
- 由於不使用ActiveRecord, 一些功能的實作方式與實際正式環境的 RoR 專案可能會有所不同
- 一些命名不採用駝峯式(appleBanana)而是根據Ruby的最佳實踐採用蛇式(apple_banana)
- 可以透過 /make_me_wool 取得管理者的token
