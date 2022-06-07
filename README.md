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


## 須注意的部分

- 這個demo不使用資料庫, 資料儲存在 Data 變數下面
- 由於不使用ActiveRecord, 一些功能的實作方式與實際正式環境的 RoR 專案可能會有所不同
- 一些命名不採用駝峯式(appleBanana)而是根據Ruby的最佳實踐採用蛇式(apple_banana)
- 可以透過 /make_me_wool 取得管理者的token
