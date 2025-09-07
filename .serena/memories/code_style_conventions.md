# コードスタイルとコンベンション

## Python コーディング規約
- **Python 3.11+** を使用
- **型ヒント**は可能な限り使用（mypyで型チェック）
- **コメント**はプロジェクトのCLAUDE.mdに従い、特に指示がない限り追加しない

## コードフォーマット
- **Black** - 自動コードフォーマッター（設定済み）
- **インデント**: 4スペース（Pythonデフォルト）
- **行の長さ**: Blackのデフォルト（88文字）

## コード品質チェック
- **flake8** - スタイルガイドチェック
- **mypy** - 静的型チェック
- **pytest** - テスト実行

## ファイル命名規則
- Pythonファイル: snake_case（例: data_processor.py）
- Notebook: 番号プレフィックス付き（例: 00_installation_test.ipynb）
- ディレクトリ: 小文字（例: notebooks/, data/, scripts/）

## ディレクトリ構造の規則
- **data/** - データファイルは.gitignoreで除外（.gitkeepで構造維持）
- **output/** - 出力結果も.gitignoreで除外
- **notebooks/** - 分析用Jupyterノートブック
- **scripts/** - 再利用可能なPythonモジュール

## 重要な開発規則（CLAUDE.mdより）

### ファイル削除時の注意
```bash
# NG: rm file.txt (権限エラーになる可能性)
# OK: trash file.txt
```

### BigQuery使用時
1. 常に`dry_run=true`でコスト確認
2. WHERE句で日付フィルタリング必須
3. 大規模JOINは段階的に処理

### データ処理の優先順位
1. BigQuery上で処理可能 → bigframes
2. ローカル大量データ → polars
3. 複雑な前処理 → pandas
4. 並列処理必要 → dask

### MCP使用規則
- Perplexity MCPはデフォルトで`ask`を使用
- Filesystem MCPを積極的に活用（大量ファイル操作時）
- Serena MCPは大規模コードベース理解時に使用

## プロジェクト固有の注意事項
- 環境変数ファイル（.env）はGitにコミットしない
- 認証情報はconfig/auth/に保存（.gitignore対象）
- Salesforce認証はSalesforce CLIの既存認証を利用