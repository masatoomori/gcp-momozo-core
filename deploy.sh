#!/usr/bin/env bash
set -euo pipefail

# Firebase-only deploy script for Momozo Inn
# This script deploys the `public/` directory to Firebase Hosting.
# Terraform-related deployment remains under ./infra/terraform and is NOT touched here.

PROG_NAME=$(basename "$0")

DEFAULT_PROJECT="momozo-core"  # Assumption: project in README
DEFAULT_TARGET="site"          # firebase.json target name

usage() {
    cat <<EOF
Usage: $PROG_NAME [--project PROJECT] [--target TARGET] [--token TOKEN] [--dry-run]

Options:
    --project PROJECT   Firebase/GCP project id (default: ${DEFAULT_PROJECT})
    --target TARGET     hosting target name from firebase.json (default: ${DEFAULT_TARGET})
    --token TOKEN       CI token for non-interactive deploys
    --dry-run           Validate and print the deploy command without running it
    -h, --help          Show this help

Examples:
    # Interactive deploy (will use defaults or .firebaserc)
    ./deploy.sh

    # Non-interactive deploy to a specific project with token
    ./deploy.sh --project my-project --token XXX
EOF
}

PROJECT="${DEFAULT_PROJECT}"
TARGET="${DEFAULT_TARGET}"
TOKEN=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --project)
            PROJECT="$2"; shift 2;;
        --target)
            TARGET="$2"; shift 2;;
        --token)
            TOKEN="$2"; shift 2;;
        --dry-run)
            DRY_RUN=true; shift;;
        -h|--help)
            usage; exit 0;;
        *)
            echo "Unknown argument: $1"; usage; exit 2;;
    esac
done

echo "🔁 Firebase deploy (hosting)"
echo "Project: ${PROJECT}"
echo "Target: ${TARGET}"

# Check public directory
if [[ ! -d "public" || ! -f "public/index.html" ]]; then
    echo "❗ public/index.html が見つかりません。デプロイ前にコンテンツを public/ に置いてください。"
    exit 1
fi

# Check firebase CLI
if ! command -v firebase >/dev/null 2>&1; then
    echo "⚠️  firebase CLI が見つかりません。インストールしてください: npm install -g firebase-tools"
    exit 1
fi

# Build deploy command
DEPLOY_CMD=(firebase deploy --only hosting:${TARGET} --project "${PROJECT}")
if [[ -n "${TOKEN}" ]]; then
    DEPLOY_CMD+=(--token "${TOKEN}")
fi

if [[ "${DRY_RUN}" == true ]]; then
    echo "DRY RUN: ${DEPLOY_CMD[*]}"
    exit 0
fi

echo "➡️  実行コマンド: ${DEPLOY_CMD[*]}"

# Confirm interactive deploy
read -r -p "デプロイを実行しますか？ (y/N): " REPLY
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    echo "キャンセルしました。"
    exit 0
fi

# Run deploy
"${DEPLOY_CMD[@]}"

echo "✅ Firebase Hosting にデプロイしました。"
echo "確認:"
echo "  - デフォルトサイト URL: https://${PROJECT}.web.app または https://${PROJECT}.firebaseapp.com"
echo "  - カスタムドメイン (www.momozo-inn.com) は Firebase Console で接続済みであれば HTTPS で配信されます。"

echo "完了。"
