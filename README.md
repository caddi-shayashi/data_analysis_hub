# Data Analysis Hub

CADDi製造業AIデータプラットフォームの経営戦略立案を支援するデータ分析プロジェクト

## 🎯 プロジェクト概要

Salesforce、APIログ、各種KPIデータを統合的に分析し、ビジネスインサイトを抽出するデータ分析基盤です。

## 📁 ディレクトリ構造

```
data_analysis_hub/
├── notebooks/          # Jupyter分析ノートブック
├── data/              
│   ├── raw/           # 生データ
│   ├── processed/     # 前処理済みデータ
│   └── external/      # 外部データソース
├── scripts/           # 再利用可能なPythonスクリプト
├── configs/           # 設定ファイル
├── output/            # 分析結果・レポート
└── CLAUDE.md          # Claude Code用ガイド
```

## 🚀 セットアップ

### 必要要件
- Python 3.11+
- uv (パッケージマネージャー)

### インストール
```bash
# uvのインストール
curl -LsSf https://astral.sh/uv/install.sh | sh

# 依存関係のインストール
uv sync

# Jupyter環境の起動
uv run jupyter lab
```

## 🛠️ 主要技術スタック

- **データ処理**: pandas, polars, dask, bigframes
- **機械学習**: scikit-learn, xgboost, lightgbm
- **時系列予測**: prophet, pytorch-forecasting
- **可視化**: matplotlib, seaborn, plotly
- **データウェアハウス**: BigQuery

## 📊 利用可能なMCPツール

- BigQuery MCP - データウェアハウス連携
- Perplexity MCP - 外部情報収集
- Filesystem MCP - ファイル操作
- Sequential Thinking MCP - 複雑問題解決
- Atlassian MCP - Confluence/Jira連携
- PDF Reader MCP - PDF分析
- Serena MCP - コード解析

## 📝 ライセンス

内部利用のみ

## 🤝 コントリビューション

プロジェクトへの貢献はClaude Codeを通じて行ってください。詳細は`CLAUDE.md`を参照。