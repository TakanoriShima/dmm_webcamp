# Docker コンテナ作成し起動する

ダウンロードした dmm_webcamp フォルダを VSCode で起動し、ターミナルで以下を実行する

```
docker-compose up -d
```

コンテナ作成に 10 程度かかります。

VSCode から `/web_container` コンテナにアタッチし、新たに起動した VSCode 画面でターミナルを起動する

# サンプルアプリの起動

## PHP/Laravel コースの最終成果物 todolist (PHP 8.2/ Laravel 10/ MariaDB 5.5.68)

ターミナルで以下を実行する

```
cd ~/environment
git clone https://github.com/TakanoriShima/todolist.git
cd todolist/
composer update
cp .env.example .env
php artisan key:generate
```

todolist フォルダ直下の .env ファイルの 11 行目から 16 行目を以下に変更する

```
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=todolist
DB_USERNAME=root
DB_PASSWORD=root
```

以下を実行し、マイグレーションとシーダー実行する

```
php artisan migrate
php artisan db:seed --class=FrontAuthUser
php artisan db:seed --class=AdminAuthUser
```

以下で Laravel サーバを起動し、挙動を確認する

```
php artisan serve
```

### 一般ユーザー画面

```
http://127.0.0.1:8000/
```

以下の情報でログイン可能

- email：hoge@example.com
- パスワード：pass

### 管理者画面

```
http://127.0.0.1:8000/admin
```

以下の情報でログイン可能

- ログイン ID：hogemin
- パスワード：pass

### MariaDB へのログイン

ターミナルで以下を実行すると、MariaDB にログインできる

```
mysql -u root -p
```

パスワードは `root`

## Web アプリケーション（就活対策）コースの最終成果物 meshiterro (Ruby 3.1.2/ Rails 6.1.4/ SQLite 3.7.17)

ターミナルで以下を実行し、環境構築

```
cd ~/environment
git clone https://github.com/TakanoriShima/MyPortfolio2.git meshiterro
cd meshiterro/
bundle install
rails db:create
rails db:migrate
yarn add @babel/plugin-transform-private-property-in-object @babel/plugin-transform-private-property-in-object
rails webpacker:compile
```

ターミナルで以下を実行し、puma を起動

```
rails s
```

以下の URL でアプリが起動する

```
http://127.0.0.1:3000/
```

## PHP ビルドインサーバで起動する PHP アプリ（おまけ）

ターミナルで以下のコマンドを実行し、ディレクトリを移動する

```
cd ~/environment/docs/
```

以下のコマンドを実行し、MariaDB にログインする

```
mysql -u root -p
```

パスワードは `root`

MariaDB で以下の SQL を実行する

```
SOURCE setup.sql;
```

データが挿入されているか確認する

```
SELECT * FROM booklist.books;
```

MariaDB からログアウトする

```
exit;
```

以下のコマンドを実行し、PHP ビルドインサーバでアプリを起動

```
cd ~/environment/docs/PHP
php -S localhost:80 -c php.ini
```

以下の URL でアプリが起動する

```
http://127.0.0.1/
```
