# Pull Request Template

<!-- I want to review in Japanese. -->

## Change Summary

1.
1.

## Checklist

- [ ] 最新の `main` ブランチをマージしている
- [ ] 関連する Issue が紐づいている
- [ ] コードが Lint を通過している
- [ ] コードがフォーマットされている
- [ ] 必要なテストが追加されている
- [ ] ドキュメントが更新されている
- [ ] 動作確認が完了している

<!-- for GitHub Copilot review rule -->

## Review Guidelines

レビューする際には、以下の prefix(接頭辞)をつけてください

- [must] → 必須の変更箇所 (must have)
- [should] → 推奨される変更箇所 (should have)
- [optional] → 任意の変更箇所 (optional)
- [refactor] → リファクタリング (refactor)
- [style] → スタイルの変更 (style)
- [perf] → パフォーマンス改善 (performance)
- [bug] → バグ修正 (bug fix)
- [docs] → ドキュメントの変更 (docs)
- [tests] → テストの追加・変更 (tests)
- [deprecate] → 非推奨化 (deprecate)
- [remove] → 機能やコードの削除 (remove)
- [discuss] → 議論が必要な箇所 (discuss)
- [clarify] → 明確化が必要な箇所 (clarification)
- [fyi] → 参考情報 (for your information)

## Coding Style

- **Markdown Linter**: Markdown ファイルをコミットする際には、[MarkdownLint](https://github.com/DavidAnson/markdownlint) を使用して Lint を通してください。
  - 推奨コマンド: `markdownlint . --fix`
- **コードフォーマット**: スタイルガイドに従ってコードをフォーマットしてください。
  - Python: [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
  - SQL: [BigQuery Style Guide](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#style-guide)

<!-- for GitHub Copilot review rule-->

## Pull Request Rules

- まずは **Draft** で PR を作成してください。
- レビューに出せる状態になったら **Open** に変更してください。
- **レビューなしでの `main` ブランチへのマージは禁止** です。

<!-- I want to review in Japanese. -->
