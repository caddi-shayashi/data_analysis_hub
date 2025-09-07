# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Data Analysis Hub** - CADDi製造業AIデータプラットフォームの経営戦略立案を支援するデータ分析プロジェクト

### 分析対象
- 受注実績・営業履歴 (Salesforce)
- プロダクト利用状況 (APIログ)
- 各種KPIデータ
- 市場動向・競合情報

### 技術スタック
- **データ処理**: pandas, polars, dask, bigframes
- **機械学習**: scikit-learn, xgboost, lightgbm, prophet, lifetimes
- **可視化**: matplotlib, seaborn, plotly, dash, streamlit
- **BigQuery**: MCP経由でアクセス
- **AI/LLM**: Gemini API (自然言語分析)

## 重要な開発規則

### ファイル削除時の注意
**rmコマンドが使用できない場合は必ず`trash-cli`を使用すること**
```bash
# NG: rm file.txt (権限エラーになる可能性)
# OK: trash file.txt
```

### BigQuery使用時
1. **必須**: 常に`dry_run=true`でコスト確認
2. **必須**: WHERE句で日付フィルタリング
3. **推奨**: 大規模JOINは段階的に処理
4. **推奨**: LIMIT句を活用して探索的分析
5. **注意**: プロジェクトIDの確認（caddi-ceo-office vs esperanto-drawer-prod）

### データ処理の優先順位
1. BigQuery上で処理可能 → **bigframes** or **BigQuery SQL**
2. ローカル大量データ → **polars** (高速)
3. 複雑な前処理 → **pandas** (機能豊富)
4. 並列処理必要 → **dask** (分散処理)

### コーディング規約
- **PEP 8準拠**
- **Type hints必須** (Python 3.11+の機能を活用)
- **Docstrings必須** (Google Style)
- **テスト必須** (pytest使用)
- **エラーハンドリング必須**

## MCP使い分けガイド

### Perplexity MCP
**デフォルト動作**: 特段の指定がない限り、常に`perplexity_ask`を使用すること
- `ask`: 簡単な質問・用語確認（**デフォルト**）
- `research`: 包括的調査（引用付き）- 詳細調査が必要な場合のみ
- `reason`: 論理的推論・戦略導出 - 複雑な分析が必要な場合のみ

### BigQuery MCP
- `list_dataset_ids`: データセット一覧取得
- `list_table_ids`: テーブル一覧取得
- `get_table_info`: テーブル詳細情報
- `execute_sql`: SQL実行（必ずdry_run=trueから始める）

### Salesforce MCP (公式)
Salesforce公式のMCP Server。TypeScript直接統合で高セキュリティ。
- **リポジトリ**: github.com/salesforcecli/mcp
- **NPMパッケージ**: @salesforce/mcp
- **認証**: Salesforce CLIの既存認証を利用
- **注意**: Developer Preview版
- **主要ツール**:
  - `sf-get-username`: ユーザー名/エイリアス解決
  - `sf-query-org`: SOQLクエリ実行
  - `sf-deploy-metadata`: メタデータデプロイ
  - `sf-retrieve-metadata`: メタデータ取得

### Filesystem MCP
**積極的に使用すること**。高速・効率的なファイル操作を提供。
- `mcp__filesystem__*`: 通常のRead/Writeより高機能
- 複数ファイル同時読み込み可能
- ディレクトリツリー表示
- ファイル検索・パターンマッチング
- **推奨**: 大量ファイル操作時は必ず使用

### Serena MCP (コード解析)
大規模コードベースの理解・リファクタリング時に使用
- シンボル単位の操作が必要な場合
- 依存関係の調査が必要な場合
- メモリ機能でプロジェクト情報を保存

### Atlassian MCP
- Confluence: ドキュメント管理・共有
- Jira: タスク管理・課題追跡

## Sub Agents定義

### bigquery-analyst
BigQueryデータ分析専門。Perplexity不使用。
- SQL最適化
- コスト削減提案
- パフォーマンスチューニング

### market-intelligence  
市場調査・競合分析。Perplexity全機能活用。
- 市場規模推定
- 競合動向分析
- トレンド予測

### data-quality-checker
データ品質検証。Perplexity不使用。
- 欠損値チェック
- 外れ値検出
- データ型整合性確認

### api-log-analyzer
APIログ分析。ask/reasonのみ使用。
- レスポンスタイム分析
- エラー率監視
- 使用パターン分析

### cohort-analyst
コホート分析。全Perplexity機能活用。
- リテンション率計算
- LTV予測
- セグメント比較

### report-automator
レポート生成。ask/reasonのみ使用。
- 定期レポート作成
- ダッシュボード更新
- エグゼクティブサマリー

## プロジェクト構造
```
data_analysis_hub/
├── 📓 notebooks/              # Jupyter分析ノートブック
│   └── bigquery_nl_analysis_with_gemini.ipynb
├── 📊 data/                   
│   └── salesforce_metadata/   # SFメタデータ
├── 🗄️ dm_business_planning/   # BigQuery dimension tables設計
│   ├── dim_company/           # 会社ディメンション
│   ├── dim_member/            # メンバーディメンション
│   ├── dim_pipeline/          # パイプラインディメンション
│   ├── dim_product/           # プロダクトディメンション
│   ├── dim_revenue/           # 売上ディメンション
│   ├── dim_time/              # 時間ディメンション
│   └── README.md              # ディメンション設計ドキュメント
├── 🔧 scripts/                # 実行スクリプト（今後追加予定）
├── 📈 output/                 # 分析結果出力
├── 🤖 .claude/                
│   └── agents/                # カスタムエージェント
├── 📋 CLAUDE.md               # このファイル
├── 📖 README.md               # プロジェクト説明
├── 📦 pyproject.toml          # 依存関係定義
└── 🔒 .gitignore              # Git除外設定
```

## パッケージ管理

### uv使用方法
```bash
# 初期セットアップ
uv sync              # 依存関係インストール

# パッケージ追加
uv add package-name  # 本番依存関係
uv add --dev package-name  # 開発依存関係

# 実行
uv run jupyter lab   # Jupyter起動
uv run python script.py  # スクリプト実行
uv run pytest        # テスト実行
```

## BigQueryデータセット情報

### メインデータセット
- **プロジェクト**: `caddi-ceo-office`
- **データセット**: `dm_business_planning`
  - `salesforce_account_mart` - 顧客マスタ
  - `salesforce_opportunity_mart` - 商談データ
  - dimension tables（設計中）:
    - `dim_company` - 会社ディメンション
    - `dim_member` - メンバーディメンション
    - `dim_pipeline` - パイプラインディメンション
    - `dim_product` - プロダクトディメンション
    - `dim_revenue` - 売上ディメンション
    - `dim_time` - 時間ディメンション

### ソースデータ
- **プロジェクト**: `esperanto-drawer-prod`
- **データセット**: `dl_salesforce`
  - `Account` - Salesforceアカウント元データ

## Git操作

### ブランチ戦略
```bash
# feature開発
git checkout -b feature/機能名

# hotfix
git checkout -b hotfix/修正内容

# リリース
git checkout -b release/v1.0.0
```

### コミットメッセージ規約
```
feat: 新機能追加
fix: バグ修正
docs: ドキュメント更新
style: コード整形
refactor: リファクタリング
test: テスト追加・修正
chore: ビルド・ツール関連
```

## トラブルシューティング

### よくある問題と解決方法

1. **BigQueryアクセスエラー**
   - IAM権限を確認
   - プロジェクトIDを確認（caddi-ceo-office vs esperanto-drawer-prod）
   - gcloud auth application-default loginを実行

2. **パッケージインストールエラー**
   - uv syncで依存関係を再インストール
   - Python 3.11以上を使用しているか確認

3. **Jupyter起動エラー**
   - uv run jupyter labを使用
   - ポート8888が使用されていないか確認

4. **Gemini APIエラー**
   - API KEYが.envに設定されているか確認
   - APIの利用制限に達していないか確認

## 連絡先

- **プロジェクトオーナー**: @caddi-shayashi
- **Slack**: #data-analysis-hub
- **GitHub**: https://github.com/caddi-shayashi/data_analysis_hub

---

*Last Updated: 2025-01-07*