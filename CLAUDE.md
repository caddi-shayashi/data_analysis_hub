# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Data Analysis Hub** - CADDi製造業AIデータプラットフォームの経営戦略立案を支援するデータ分析プロジェクト

### 分析対象
- 受注実績・営業履歴 (Salesforce)
- プロダクト利用状況 (APIログ)
- 各種KPIデータ

### 技術スタック
- **データ処理**: pandas, polars, dask, bigframes
- **機械学習**: scikit-learn, xgboost, lightgbm, prophet
- **可視化**: matplotlib, seaborn, plotly, dash, streamlit
- **BigQuery**: MCP経由でアクセス

## 重要な開発規則

### ファイル削除時の注意
**rmコマンドが使用できない場合は必ず`trash-cli`を使用すること**
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

## MCP使い分けガイド

### Perplexity MCP
**デフォルト動作**: 特段の指定がない限り、常に`perplexity_ask`を使用すること
- `ask`: 簡単な質問・用語確認（**デフォルト**）
- `research`: 包括的調査（引用付き）- 詳細調査が必要な場合のみ
- `reason`: 論理的推論・戦略導出 - 複雑な分析が必要な場合のみ

### Salesforce MCP (公式)
Salesforce公式のMCP Server。TypeScript直接統合で高セキュリティ。
- **リポジトリ**: github.com/salesforcecli/mcp
- **NPMパッケージ**: @salesforce/mcp
- **認証**: Salesforce CLIの既存認証を利用
- **注意**: Developer Preview版

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

## Sub Agents定義

### bigquery-analyst
BigQueryデータ分析専門。Perplexity不使用。

### market-intelligence  
市場調査・競合分析。Perplexity全機能活用。

### data-quality-checker
データ品質検証。Perplexity不使用。

### api-log-analyzer
APIログ分析。ask/reasonのみ使用。

### cohort-analyst
コホート分析。全Perplexity機能活用。

### report-automator
レポート生成。ask/reasonのみ使用。

## プロジェクト構造
```
data_analysis_hub/
├── .claude/agents/     # エージェント設定
├── notebooks/          # Jupyter notebooks
├── data/              
│   ├── raw/
│   ├── processed/
│   └── external/
├── output/            # 分析結果
└── CLAUDE.md          # このファイル
```

## パッケージ管理
uvを使用：
```bash
uv sync              # 依存関係インストール
uv add package-name  # パッケージ追加
uv run jupyter lab   # Jupyter起動
```