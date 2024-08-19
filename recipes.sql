-- データベースの作成
CREATE DATABASE IF NOT EXISTS sampledb CHARACTER SET utf8 COLLATE utf8_general_ci;

-- データベースの使用
USE sampledb;

-- テーブルの作成
CREATE TABLE IF NOT EXISTS recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    ingredients TEXT NOT NULL,
    instructions TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 初期データの挿入
INSERT INTO recipes (title, ingredients, instructions) VALUES 
('照り焼きチキン', '鶏もも肉 2枚, 醤油 大さじ2, みりん 大さじ2, 砂糖 大さじ1', '鶏もも肉を一口大に切る。醤油、みりん、砂糖を混ぜ合わせ、鶏肉を漬け込む。フライパンで焼き、火が通るまで調理する。'),
('カレーライス', '玉ねぎ 1個, にんじん 1本, じゃがいも 2個, 牛肉 200g, カレールー 1箱', '玉ねぎ、にんじん、じゃがいもを一口大に切る。鍋で牛肉を炒め、野菜を加えてさらに炒める。水を加えて煮込み、カレールーを入れて溶かす。'),
('味噌汁', '豆腐 1丁, わかめ 10g, ねぎ 1本, 味噌 大さじ2', '豆腐を一口大に切る。鍋に水を入れて沸騰させ、豆腐とわかめを加える。味噌を溶かし、最後に刻んだねぎを加える。');
