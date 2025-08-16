# Momozo Inn Website Infrastructure

このディレクトリには、Momozo Inn（momozo-inn.com）の静的ウェブサイトを構築・管理するためのTerraform設定が含まれています。

## 概要

- **プロジェクトID**: momozo-core
- **ドメイン**: momozo-inn.com
- **ホスティング**: Google Cloud Storage静的ウェブサイト
- **リージョン**: asia-northeast1

## アーキテクチャ

このウェブサイトは以下のGoogle Cloud Platformリソースを使用しています：

1. **Google Cloud Storage バケット**
   - ドメイン名と同名のバケット（`momozo-inn.com`）
   - 静的ウェブサイトホスティング設定
   - バージョニング有効化

2. **パブリックアクセス権限**
   - `allUsers` に `roles/storage.objectViewer` 権限を付与

3. **ウェブサイトコンテンツ**
   - `../../website/` ディレクトリからHTMLファイルをアップロード
   - `index.html` - メインページ
   - `404.html` - エラーページ

## セットアップ手順

### 1. 環境変数の設定

`.envrc.example` をコピーして `.envrc` を作成：

```bash
cp .envrc.example .envrc
```

### 2. Terraformの初期化

```bash
terraform init
```

### 3. プランの確認

```bash
terraform plan
```

### 4. リソースのデプロイ

```bash
terraform apply
```

## ウェブサイトコンテンツの更新

ウェブサイトのコンテンツを更新する場合：

1. `../../website/` ディレクトリ内のHTMLファイルを編集
2. Terraform apply を実行してCloud Storageに反映

```bash
# コンテンツを編集後
terraform apply
```

Terraformが自動的に変更を検知し、更新されたファイルのみをアップロードします。

## アクセスURL

デプロイ後、以下のURLでウェブサイトにアクセスできます：

- **直接アクセス**: `https://storage.googleapis.com/momozo-inn.com/index.html`
- **バケットURL**: `https://momozo-inn.com.storage.googleapis.com`

## ファイル構成

```
infra/terraform/
├── provider.tf          # Google Cloud Provider設定
├── variables.tf         # 変数定義
├── locals.tf           # ローカル値
├── website.tf          # ウェブサイトリソース
├── outputs.tf          # 出力値
├── state.tf           # Terraform状態管理
└── .envrc.example     # 環境変数サンプル

website/
├── index.html         # メインページ
└── 404.html          # エラーページ
```

## 出力値

Terraformが提供する出力値：

- `website_url`: ウェブサイトの直接URL
- `website_bucket_url`: バケットのURL
- `bucket_name`: 作成されたバケット名
- `domain_name`: 設定されたドメイン名

## 注意事項

1. **ドメイン設定**: カスタムドメインを使用するには、DNS設定が別途必要です
2. **HTTPS**: Cloud Storageの静的ホスティングはHTTPSをサポートしますが、カスタムドメインでHTTPSを使用するにはCloud Load Balancerの設定が必要です
3. **権限**: Google Cloudプロジェクトへの適切な権限が必要です

## トラブルシューティング

### よくある問題

1. **認証エラー**: `gcloud auth application-default login` を実行
2. **バケット名の衝突**: バケット名はグローバルでユニークである必要があります
3. **権限不足**: プロジェクトでStorage Admin権限が必要です

### サポート

問題が発生した場合は、以下を確認してください：

1. Google Cloud認証が正しく設定されているか
2. プロジェクトIDが正しいか
3. 必要な権限があるか
4. Terraformの構文エラーがないか（`terraform validate`）