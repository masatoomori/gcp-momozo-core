# Momozo Inn - シンプルな静的ウェブサイト

このリポジトリは、Google Cloud Platform 上でホストされる Momozo Inn（momozo-inn.com）の静的ウェブサイトを管理するためのプロジェクトです。

## 🌟 プロジェクト概要

- **プロジェクト ID**: `momozo-core`
- **ドメイン**: `momozo-inn.com`
- **ホスティング**: Firebase Hosting
- **インフラ管理**: Terraform
- **リージョン**: `asia`

## 📁 ディレクトリ構成

```
gcp-momozo-core/
├── website/                 # ウェブサイトコンテンツ
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

または手動で：

```bash
cd infra/terraform
terraform init
terraform plan
terraform apply
```

## 🎨 ウェブサイトコンテンツの更新

1. `website/` ディレクトリ内の HTML ファイルを編集
2. 変更をコミット
3. デプロイスクリプトを実行

```bash
# コンテンツを編集後
./deploy.sh
```

Terraform が自動的に変更を検知し、更新されたファイルのみを Google Cloud Storage にアップロードします。

## 🌐 アクセス URL

デプロイ後、以下の URL でウェブサイトにアクセスできます：

### 直接アクセス

```text
https://storage.googleapis.com/momozo-inn.com/index.html
```

### バケット URL

```
https://momozo-inn.com.storage.googleapis.com
```

### カスタムドメイン（www） — HTTPS 配信

このリポジトリでは `www.momozo-inn.com` を Google Cloud の HTTPS ロードバランサ（Managed SSL）経由で配信する設定を Terraform により追加しています。

出力される URL:

```
https://www.momozo-inn.com/
```

今回は Google Domains のブラウザ画面から DNS を設定しました。手順:

1. <https://domains.google.com/> にログイン
2. ドメイン `momozo-inn.com` を選択
3. 左メニューで「DNS」を選択
4. 「カスタム リソース レコード」のセクションで新規追加:

   - 名前: `www`
   - 種別: `A`
   - TTL: `300`
   - データ(IPv4 address): `34.110.186.83` ← ロードバランサのグローバル IP

   - 保存して反映を待つ

注意点:

- Cloudflare 等のプロキシを使う場合はプロキシ機能を無効（オフ）にしてください。プロキシが有効だと Google の Managed SSL の検証や直接の TLS 接続に影響します。

- apex（裸ドメイン）を扱う場合は別途設定が必要です（今回の設定では `momozo-inn.com` は apex に A レコードを向けています）。

## ✅ デプロイ後の確認コマンド

````bash
# ロードバランサの IP を確認
cd infra/terraform
# Momozo Inn — 静的サイト（Firebase Hosting）

このリポジトリは Momozo Inn（momozo-inn.com）の静的ウェブサイトを管理します。
現状は Firebase Hosting を使って公開しています（`public/` ディレクトリ）。

## 概要

- プロジェクト: `momozo-core`
- ドメイン: `momozo-inn.com`, `www.momozo-inn.com`
- ホスティング: Firebase Hosting（`public/`）
- デプロイ方法: `firebase deploy`（CI で自動化可）
- 以前の GCP ロードバランサ経由の配信は Terraform で破棄済み

## ディレクトリ構成

```
gcp-momozo-core/
├── public/                 # ウェブサイト公開ファイル (index.html, 404.html)
├── infra/                  # インフラ構成 (Terraform, scripts)
│   └── terraform/
├── .github/                # GitHub Actions や CI 設定
├── firebase.json           # Firebase Hosting 設定
├── .firebaserc             # Firebase プロジェクトと hosting targets
├── deploy.sh               # デプロイ補助スクリプト (ローカル用)
└── README.md               # このファイル
```

## クイックスタート

前提: `gcloud`, `firebase` CLI がインストール・認証済みであること。

1. リポジトリをクローンして作業ディレクトリへ移動

```bash
cd /path/to/gcp-momozo-core
```

2. Firebase にログイン（初回）

```bash
firebase login
```

3. プロジェクトを指定してデプロイ

```bash
firebase deploy --only hosting --project=momozo-core
```

またはリポジトリに用意した `deploy.sh` を使ってデプロイできます。

## カスタムドメインと DNS の手順（要約）

1. Firebase Console → Hosting → Add custom domain に `www.momozo-inn.com` を追加します。
2. Firebase が提示する検証用 TXT を DNS に追加（本リポジトリは Cloud DNS 管理ゾーン `momozo-inn-com` を使用しています）。
   - 例（gcloud で追加）:

```bash
# Momozo Inn — 静的サイト運用リポジトリ

このリポジトリは、Momozo Inn（momozo-inn.com）の静的ウェブサイトを管理するためのソースです。

現状のまとめ
- ホスティング: Firebase Hosting（`public/` ディレクトリ）
- プロジェクト: `momozo-core`
- カスタムドメイン: `www.momozo-inn.com` は Firebase に接続済み（HTTPS 配信、アドレスバーは `www.momozo-inn.com` のまま表示されます）
- 裸ドメイン（`momozo-inn.com`）の自動リダイレクト（apex→www）は、誤動作を回避するため一旦無効化しています（必要なら専用の hosting site で再構成します）

ディレクトリ構成（主要）
```
gcp-momozo-core/
├── public/                 # 公開ファイル（index.html 等）
├── infra/                  # インフラ定義（Terraform, scripts）
└── firebase.json           # Firebase Hosting の設定
```

クイックデプロイ
1. Firebase CLI にログイン
```bash
firebase login
```
2. ホスティングをデプロイ
```bash
firebase deploy --only hosting:site --project=momozo-core
```

カスタムドメイン（www）
- `www.momozo-inn.com` は Firebase Hosting に接続済みです。DNS は `www` を CNAME で `momozo-core.web.app.` に向けており、Firebase がホスト名を受けて配信します。
- 裸ドメイン（`momozo-inn.com`）を `www` にリダイレクトしたい場合は、別の hosting site を作って専用の redirect 設定を行うのが安全です（手順は下記）。

裸ドメインを apex→www でリダイレクトする（必要な場合）
```bash
# 1) 専用の hosting site を作成
firebase hosting:sites:create momozo-core-apex --project=momozo-core

# 2) targets に割り当て（ローカルで一度実行）
firebase target:apply hosting apex-redirect momozo-core-apex --project=momozo-core

# 3) firebase.json に apex-redirect のエントリを追加してデプロイ
firebase deploy --only hosting:apex-redirect --project=momozo-core
```

README の更新履歴
- Firebase Hosting に移行し、以前の GCP ロードバランサ設定は Terraform で破棄済みです。

運用メモ
- 変更は `public/` を編集してコミット、`firebase deploy` で反映します。
- Terraform 関連の変更（`infra/terraform`）は別途管理しており、GCS バケットは Terraform の構成から不要な部分を削除済みです。

追加のドキュメントや CI 設定の追記が必要なら教えてください。
````
