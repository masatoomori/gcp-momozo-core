# Momozo Inn - シンプルな静的ウェブサイト

このリポジトリは、Google Cloud Platform 上でホストされる Momozo Inn（momozo-inn.com）の静的ウェブサイトを管理するためのプロジェクトです。

# Momozo Inn - シンプルな静的ウェブサイト

このリポジトリは、Google Cloud Platform 上でホストされる Momozo Inn（momozo-inn.com）の静的ウェブサイトを管理するためのプロジェクトです。

## 🌟 プロジェクト概要

- **プロジェクト ID**: `momozo-core`
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
terraform output lb_ip_address

# DNS の反映確認（Google Public DNS）
dig @8.8.8.8 +short www.momozo-inn.com A

# 証明書の状態確認
gcloud compute ssl-certificates describe dev-www-cert --project=momozo-core --format="yaml"


証明書の状態が `PROVISIONING` から `ACTIVE` に変わると、HTTPS 配信が有効になります（DNS の反映状況と合わせて数分〜数十分かかります）。

### 環境変数

以下の環境変数が使用されます：

```bash
export TF_VAR_project_id=momozo-core
export TF_VAR_region=asia-northeast1
export TF_VAR_domain_name=momozo-inn.com
````

- **Google Storage Bucket**: ドメイン名と同名のバケット
- **Bucket IAM Member**: 全ユーザーに読み取り権限を付与
- **Storage Objects**: HTML ファイルをアップロード

## 📚 詳細ドキュメント

## 🛠️ 開発・運用

### バックアップとバージョン管理

- Git: ソースコード管理
- Cloud Storage バージョニング: アップロードファイルの履歴管理
- Terraform 状態: インフラ設定の管理

### モニタリング

Google Cloud Console で以下を監視できます：

- Cloud Storage 使用量
- アクセスログ
- エラー状況

## 🔒 セキュリティ

- **公開読み取り専用**: バケットは読み取り専用で公開
- **HTTPS**: Google Cloud Storage による自動 HTTPS 配信
- **IAM**: 最小権限の原則に基づく権限設定

## 🆘 トラブルシューティング

### よくある問題

1. **認証エラー**

   ```bash
   gcloud auth application-default login
   ```

2. **バケット名の衝突**

   - バケット名はグローバルでユニークである必要があります
   - 別のドメイン名を使用するか、プロジェクト ID を含める

3. **権限不足**

   - プロジェクトで Storage Admin 権限が必要

   ```bash
   gcloud projects add-iam-policy-binding momozo-core \
     --member="user:your-email@domain.com" \
     --role="roles/storage.admin"
   ```

4. **Terraform 初期化エラー**

   ```bash
   cd infra/terraform
   terraform init -reconfigure
   ```

問題が発生した場合：

1. [Google Cloud ドキュメント](https://cloud.google.com/storage/docs/hosting-static-website)を確認
2. Terraform エラーは `terraform validate` で構文をチェック
3. リソース競合の場合は `terraform import` を検討

## 📄 ライセンス

このプロジェクトは MIT License の下で公開されています。

## 🤝 貢献

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

---

Built with ❤️ using Google Cloud Platform and Terraform
