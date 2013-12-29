# README

## TeamMate 简介

TeamMate 是一个项目管理系统，目前包含了用户管理、项目管理、任务管理、Wiki 等功能，设计思路基本来源于被广泛使用的项目管理系统 [Redmine](http://www.redmine.org)。目前实现的功能可以说仅仅是 Redmine 的一个很小的子集。

与 Redmine 的主要区别是：

+ 界面使用 Bootstrap 3 构建，更加简洁和清爽。
+ Wiki 采用 Markdown 编辑。
+ 计划要在未来增加的功能：Bug 和测试用例管理、代码 Review

## Screenshots

### 我的工作：

![我的工作](http://imglf0.ph.126.net/dv25wMrhCctKbZZUepom2Q==/2971812804211133223.png)

### 用户列表：

![用户列表](http://imglf1.ph.126.net/YKQdi3HdQwmtopWaaABJ4g==/1801439851048232140.png)

### 修改账户资料

![修改账户资料](http://imglf0.ph.126.net/fq3hedKvZ93UjX-B_HIskA==/1832965048440022071.png)

### 任务查看

![任务查看](http://imglf0.ph.126.net/L68E9V7i-L0zFwnvt4RlLQ==/6597276474844136268.png)

### Wiki

![Wiki](http://imglf1.ph.126.net/TFblJoW-S5SDCc6N4iGt3Q==/4871487422031398287.png)


## DEMO 网站

+ 地址：[http://demo.teammate.pm](http://demo.teammate.pm)
+ 登陆账号：team_mates@163.com
+ 登陆口令：12345678

## 安装


### 依赖

+ Ruby 版本：`>= 1.9.3`
+ 数据库: `MySQL`

### 检出代码

```
git clone https://github.com/lululau/TeamMate

```

### 安装 Gems

```
RAILS_ENV=production bundle install
```

### 修改配置

+ 邮箱配置(`TeamMate/config/environments/production.rb`)

```
config.action_mailer.default_url_options = { :host => "localhost:3000" }
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address => "smtp.163.com",
  :port => 25,
  :domain => "163.com",
  :authentication => :login,
  :user_name => "team_mates@163.com", #你的邮箱
  :password => "applescript921"
}

```

+ 列表分页中每页显示的行数(`TeamMate/config/initializers/kaminari_config.rb`)

```
Kaminari.configure do |config|
  config.default_per_page = 10   # 默认为 10 行
end

```

+ 数据库配置(`TeamMate/config/database.yml`)

```
production:
  adapter: mysql2
  database: teammate
  host: localhost
  username: root
  password: ""
  encoding: utf8
```

### 创建数据库

```
RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:schema:load
```

### 导入初始数据

+ 修改文件 `TeamMate/db/seeds.rb`

```
Person.create :name => 'admin',
            :email => 'team_mates@163.com',  # 将 Email 地址修改为管理员的邮箱地址
            :encrypted_password => '$2a$10$HfO/Pju/AlD/lYiM6XinJeI0Wp5auCm59kupuEs3ICHbPYfO8aYTC',   # 初始密码为 12345678
            :role => 'admin',
            :avatar => 0,
            :locked => false
```

+ 执行:


```
RAILS_ENV=production rake db:seed
```

### 预编译 Assets

```
RAILS_ENV=production rake assets:precompile
```

### 启动服务器

```
RAILS_ENV=production rails s -d
```


## Road Map

+ 完善目前已经实现的模块，例如：为 Wiki、以及项目、任务编辑界面增加附件上传功能、在任务列表界面增加“登记工时”功能等
+ Bug 缺陷管理
+ 需求和测试用例管理
+ 代码 Review