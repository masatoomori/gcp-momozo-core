# Momozo Inn - シンプルな静的ウェブサイト

このリポジトリは、Google Cloud Platform上でホストされるMomozo Inn（momozo-inn.com）の静的ウェブサイトを管理するためのプロジェクトです。

## 🌟 プロジェクト概要

- **プロジェクトID**: `momozo-core`
- **ドメイン**: `momozo-inn.com`
- **ホスティング**: Google Cloud Storage 静的ウェブサイト
- **インフラ管理**: Terraform
- **リージョン**: `asia-northeast1`

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
- Terraform v1.0以降

### 2. 環境設定

```bash
# Google Cloud認証
gcloud auth login
gcloud auth application-default login

# プロジェクトの設定
gcloud config set project momozo-core
```

### 3. Terraform状態管理バケットの作成（初回のみ）

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

1. `website/` ディレクトリ内のHTMLファイルを編集
2. 変更をコミット
3. デプロイスクリプトを実行

```bash
# コンテンツを編集後
./deploy.sh
```

Terraformが自動的に変更を検知し、更新されたファイルのみをGoogle Cloud Storageにアップロードします。

## 🌐 アクセスURL

デプロイ後、以下のURLでウェブサイトにアクセスできます：

### 直接アクセス
```
https://storage.googleapis.com/momozo-inn.com/index.html
```

### バケットURL
```
https://momozo-inn.com.storage.googleapis.com
```

## 🔧 設定詳細

### 環境変数

以下の環境変数が使用されます：

```bash
export TF_VAR_project_id=momozo-core
export TF_VAR_region=asia-northeast1
export TF_VAR_domain_name=momozo-inn.com
```

### Terraformリソース

- **Google Storage Bucket**: ドメイン名と同名のバケット
- **Bucket IAM Member**: 全ユーザーに読み取り権限を付与
- **Storage Objects**: HTMLファイルをアップロード

## 📚 詳細ドキュメント

- [ウェブサイトコンテンツ詳細](website/README.md)
- [インフラセットアップガイド](infra/scripts/README.md)

## 🛠️ 開発・運用

### ローカル開発

HTMLファイルをローカルで編集・プレビューした後、デプロイスクリプトで本番環境に反映します。

### バックアップとバージョン管理

- Git: ソースコード管理
- Cloud Storage バージョニング: アップロードファイルの履歴管理
- Terraform状態: インフラ設定の管理

### モニタリング

Google Cloud Consoleで以下を監視できます：

- Cloud Storage使用量
- アクセスログ
- エラー状況

## 🔒 セキュリティ

- **公開読み取り専用**: バケットは読み取り専用で公開
- **HTTPS**: Google Cloud Storageによる自動HTTPS配信
- **IAM**: 最小権限の原則に基づく権限設定

## 🆘 トラブルシューティング

### よくある問題

1. **認証エラー**
   ```bash
   gcloud auth application-default login
   ```

2. **バケット名の衝突**
   - バケット名はグローバルでユニークである必要があります
   - 別のドメイン名を使用するか、プロジェクトIDを含める

3. **権限不足**
   - プロジェクトでStorage Admin権限が必要
   ```bash
   gcloud projects add-iam-policy-binding momozo-core \
     --member="user:your-email@domain.com" \
     --role="roles/storage.admin"
   ```

4. **Terraform初期化エラー**
   ```bash
   cd infra/terraform
   terraform init -reconfigure
   ```

### サポート

問題が発生した場合：

1. [Google Cloud ドキュメント](https://cloud.google.com/storage/docs/hosting-static-website)を確認
2. Terraformエラーは `terraform validate` で構文をチェック
3. リソース競合の場合は `terraform import` を検討

## 📄 ライセンス

このプロジェクトはMIT License の下で公開されています。

## 🤝 貢献

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

---

**Built with ❤️ using Google Cloud Platform and Terraform**