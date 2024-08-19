# レシピ共有アプリケーション - README

## 概要

このアプリケーションは、料理レシピを共有するためのウェブベースのプラットフォームです。ユーザーは登録、ログインしてレシピを管理することができる。また、レシピの検索、閲覧、新規追加機能も提供されている。アプリケーションはMVC（Model-View-Controller）アーキテクチャを採用しており、ビジネスロジックとプレゼンテーションロジックを分離することで、メンテナンス性と拡張性を高めている。

## 前提条件

アプリケーションを実行する前に、以下がシステムにインストールされていることを確認してください。

- PHP（バージョン7.0以上）
- MySQL（または互換性のあるデータベース）
- ウェブサーバー（Apache、Nginxなど）
- Composer（PHPの依存管理ツール）
- Smarty（テンプレートエンジン）
- HTML_QuickForm2（フォーム処理ライブラリ）

## インストール

以下の手順に従ってアプリケーションをセットアップします。

### 1. MariaDBへの接続
ターミナルを開き、以下のコマンドを実行してMariaDBに接続する。パスワードを求められたら入力する。
```bash
mysql -u root -p
```

### 2. データベースの作成
接続が成功したら、以下のコマンドを実行してデータベースを作成する。
```sql
CREATE DATABASE sampledb CHARACTER SET utf8 COLLATE utf8_general_ci;
```

### 3. ユーザーの作成と権限の付与
データベースにアクセスするためのユーザーを作成し、そのユーザーに適切な権限を付与する。
```sql
CREATE USER 'sample'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON sampledb.* TO 'sample'@'localhost';
FLUSH PRIVILEGES;
```

### 4. 設定ファイルの確認と変更
XAMPPの設定ファイル（`php.ini`や`my.cnf`）を必要に応じて確認し、MariaDBが正しく動作するように設定する。通常、デフォルトの設定で問題ないが、`my.cnf`ファイルで`character-set-server`が`utf8`に設定されていることを確認する。

### 5. **Smartyを設定する:**
    - 以下のディレクトリがウェブサーバーによって書き込み可能であることを確認する。
        - `php_libs/smarty/templates_c/`
        - `php_libs/smarty/cache/`
    - 必要に応じて、`init.php`ファイル内のSmartyディレクトリパスを更新する。

5. **ウェブサーバーをセットアップする:**
    - ウェブサーバーのドキュメントルートを`public`ディレクトリに設定する。
    - クリーンURLのためにURLリライティングが有効になっていることを確認する（Apacheを使用している場合は`mod_rewrite`モジュールを有効にする）。

## ディレクトリ構成
以下のような構成になるようにファイルを設置してください。

```


├── htdocs
│   ├── globals.css
│   ├── img
│   │   ├── arcticons-reciper.svg
│   │   ├── group.png
│   │   ├── mdi-account.svg
│   │   ├── rectangle-21.svg
│   │   └── vector.svg
│   ├── index.php
│   ├── index_member.php
│   ├── js
│   │   └── quickform.js
│   ├── premember.php
│   ├── static
│   ├── style.css
│   └── system.php
│ 
├── php_libs
     ├── class
     │   ├── Auth.php
     │   ├── BaseController.php
     │   ├── BaseModel.php
     │   ├── KenController.php
     │   ├── KenModel.php
     │   ├── MemberController.php
     │   ├── MemberModel.php
     │   ├── PrememberController.php
     │   ├── PrememberModel.php
     │   ├── RecipeController.php
     │   ├── RecipeModel.php
     │   ├── SystemController.php
     │   ├── SystemModel.php
     │   
     │      
     │   
     ├── init.php
     └── smarty
         ├── cache
         ├── configs
         │   └── test.conf
         ├── libs
         │   ├── Autoloader.php
         │   ├── Smarty.class.php
         │   ├── SmartyBC.class.php
         │   ├── bootstrap.php
         │   ├── debug.tpl
         ├── templates
         │   ├── default.tpl
         │   ├── delete_form.tpl
         │   ├── login.tpl
         │   ├── member_top.tpl
         │   ├── memberinfo_form.tpl
         │   ├── message.tpl
         │   ├── premember.tpl
         │   ├── recipe_add.tpl
         │   ├── recipe_list.tpl
         │   ├── recipe_view.tpl
         │   ├── system_list.tpl
         │   ├── system_login.tpl
         │   └── system_top.tpl
         └── templates_c

```

### テーブル作成のSQLスクリプト
ターミナルでMariaDBに接続した状態で、以下のコマンドを実行することで、`recipes`テーブルを作成する。
```sql
CREATE TABLE recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    ingredients TEXT NOT NULL,
    instructions TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```
また他のテーブルは会員管理システムと同様なので省略する

## 設定

すべての設定は`php_libs`ディレクトリ内の`init.php`ファイルで行う。このファイルには、データベース接続、セッション名、Smartyディレクトリなどの設定が含まれている。

## アプリケーションの実行

1. **ウェブサーバーを起動する:**
    ウェブサーバーが正しいドキュメントルートを指して起動していることを確認する。

2. **アプリケーションにアクセスする:**
    ウェブブラウザを開き、アプリケーションのURLに移動する（例：`http://localhost/index.php`）。

3. **登録とログイン:**
    - 登録ページを使用して新しいアカウントを作成する。
    - 作成した資格情報でログインする。
    - ログイン後、レシピの追加、閲覧、検索が可能になる。

## トラブルシューティング

- 必要なPHP拡張がインストールされ、有効になっていることを確認する。
- `init.php`ファイル内のデータベース接続設定を確認する。
- Smartyテンプレートディレクトリのファイルとディレクトリの権限を確認する。
- アプリケーションに関連するエラーがウェブサーバーログに記録されているか確認する。

