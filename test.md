以下は、データベースを作成し、設定するための手順である。

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

### PHPでの接続情報の設定
次に、PHPファイルでデータベース接続設定を行う。以下は、設定情報を定義するPHPコードの例である。
```php
<?php
define("_DB_USER", "sample");
define("_DB_PASS", "password");
define("_DB_HOST", "localhost");
define("_DB_NAME", "sampledb");
define("_DB_TYPE", "mysql");
define("_DSN", _DB_TYPE . ":host=" . _DB_HOST . ";dbname=" . _DB_NAME. ";charset=utf8");

try {
    $pdo = new PDO(_DSN, _DB_USER, _DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "データベースに接続成功";
} catch (PDOException $e) {
    echo "データベース接続失敗: " . $e->getMessage();
}
?>
```

このコードをPHPファイルに保存し、ブラウザからアクセスしてデータベース接続が成功することを確認する。


以下に、レシピを管理するためのテーブルを作成するSQLスクリプトと、データベース操作のためのPHPクラスの例を示す。

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

### PHPクラスの例
以下に、指定された操作を行うためのPHPクラスの例を示す。

```php
<?php

class RecipeManager {
    private $pdo;

    public function __construct($dsn, $user, $pass) {
        try {
            $this->pdo = new PDO($dsn, $user, $pass);
            $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            echo "データベース接続失敗: " . $e->getMessage();
        }
    }

    public function getAllRecipes() {
        $stmt = $this->pdo->prepare("SELECT * FROM recipes");
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getRecipeById($id) {
        $stmt = $this->pdo->prepare("SELECT * FROM recipes WHERE id = :id");
        $stmt->bindParam(':id', $id, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

    public function addRecipe($data) {
        $stmt = $this->pdo->prepare("INSERT INTO recipes (title, ingredients, instructions) VALUES (:title, :ingredients, :instructions)");
        $stmt->bindParam(':title', $data['title']);
        $stmt->bindParam(':ingredients', $data['ingredients']);
        $stmt->bindParam(':instructions', $data['instructions']);
        return $stmt->execute();
    }

    public function searchRecipes($search) {
        $data = [];
        try {
            $sql = "SELECT * FROM recipes WHERE title LIKE :search";
            $stmh = $this->pdo->prepare($sql);
            $searchTerm = '%' . $search . '%';
            $stmh->bindValue(':search', $searchTerm, PDO::PARAM_STR);
            $stmh->execute();
            $data = $stmh->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $Exception) {
            print "エラー：" . $Exception->getMessage();
        }
        return $data;
    }
}

// 設定情報の定義
define("_DB_USER", "sample");
define("_DB_PASS", "password");
define("_DB_HOST", "localhost");
define("_DB_NAME", "sampledb");
define("_DB_TYPE", "mysql");
define("_DSN", _DB_TYPE . ":host=" . _DB_HOST . ";dbname=" . _DB_NAME . ";charset=utf8");

// インスタンス化とテスト
$recipeManager = new RecipeManager(_DSN, _DB_USER, _DB_PASS);

// 全てのレシピを取得
$recipes = $recipeManager->getAllRecipes();
print_r($recipes);

// IDでレシピを取得
$recipe = $recipeManager->getRecipeById(1);
print_r($recipe);

// レシピを追加
$newRecipe = [
    'title' => 'Sample Recipe',
    'ingredients' => 'Sample Ingredients',
    'instructions' => 'Sample Instructions'
];
$recipeManager->addRecipe($newRecipe);

// 検索
$searchResults = $recipeManager->searchRecipes('Sample');
print_r($searchResults);
?>
```

このクラスは、以下の機能を提供する：
1. 全てのレシピを取得する
2. IDで特定のレシピを取得する
3. 新しいレシピを追加する
4. タイトルに基づいてレシピを検索する

ターミナルでSQLスクリプトを実行した後、このPHPクラスを使用してデータベース操作を行う。