# Momozo Inn - シンプルな静的ウェブサイト

このリポジトリは、Google Cloud Platform 上でホストされる Momozo Inn（momozo-inn.com）の静的ウェブサイトを管理するためのプロジェクトです。

## 🌟 プロジェクト概要

- **プロジェクト ID**: `momozo-core`
- **ドメイン**: `momozo-inn.com`
- **ホスティング**: Firebase Hosting（`public/` ディレクトリを公開ディレクトリとして使用）
- **カスタムドメイン**: `www.momozo-inn.com` は Firebase に接続済み（HTTPS 配信、アドレスバーは `www.momozo-inn.com` のまま表示されます）
- **インフラ管理**: Terraform
- **リージョン**: `asia`

## 📁 ディレクトリ構成

```
gcp-momozo-core/
├── public/                 # ウェブサイトコンテンツ
│   ├── index.html          # メインページ
│   ├── 404.html            # エラーページ
│   └── README.md           # ウェブサイト詳細ドキュメント
├── infra/                  # インフラストラクチャ設定
│   ├── terraform/          # Terraform設定ファイル
│   │   ├── provider.tf     # Google Cloud Provider設定
│   │   ├── variables.tf    # 変数定義
│   │   ├── locals.tf       # ローカル値
│   │   ├── website.tf      # ウェブサイトリソース
│   │   ├── outputs.tf      # 出力値
│   │   ├── state.tf        # Terraform状態管理
│   │   └── .envrc.example  # 環境変数テンプレート
│   └── scripts/            # セットアップスクリプト
└── deploy.sh               # デプロイメントスクリプト
```

## 🚀 クイックスタート

### 1. 前提条件

- Google Cloud Platform アカウント
- `gcloud` CLI がインストール・認証済み
- Terraform v1.0 以降

### 2. 環境設定

```bash
# Google Cloud認証
gcloud auth login
gcloud auth application-default login

# プロジェクトの設定
gcloud config set project momozo-core
```

### 3. Terraform 状態管理バケットの作成（初回のみ）

```bash
cd infra/scripts
# 環境変数を設定（詳細は infra/scripts/README.md を参照）
./create_terraform_state_bucket.sh
./update_terraform_backend_config.sh
```

### 4. ウェブサイトのデプロイ

```bash
# リポジトリルートから実行
./deploy.sh
```

## 🎨 ウェブサイトコンテンツの更新

1. `website/` ディレクトリ内の HTML ファイルを編集
2. 変更をコミット
3. デプロイスクリプトを実行

```bash
# コンテンツを編集後
./deploy.sh
```

## 🌐 アクセス URL

デプロイ後、以下の URL でウェブサイトにアクセスできます：

### 直接アクセス

```text
https://www.momozo-inn.com/index.html
```
