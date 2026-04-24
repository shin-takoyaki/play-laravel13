# Laravel Docker 開発環境

## 起動手順

初回はPHPイメージをビルドして起動します。

```bash
docker compose up --build
```

2回目以降は通常の起動で利用できます。

```bash
docker compose up
```

起動後、ブラウザで以下にアクセスするとLaravelの初期画面が表示されます。

```text
http://localhost:8080
```

## 起動時に実行される処理

`app`コンテナの起動時に、以下の初期化が自動で実行されます。

- `.env`が無い場合は`.env.example`から作成
- `vendor`が無い場合は`composer install`
- `node_modules`が無い場合は`npm install`
- `APP_KEY`が未設定の場合は`php artisan key:generate`
- MySQLの起動を待って`php artisan migrate --force`

`vendor`または`node_modules`を削除した場合は、次回起動時に再インストールされます。

## 停止手順

コンテナを停止します。

```bash
docker compose down
```

DBのデータも削除して初期状態に戻す場合は、ボリュームも削除します。

```bash
docker compose down -v
```
