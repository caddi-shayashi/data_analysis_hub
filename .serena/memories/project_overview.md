# Data Analysis Hub プロジェクト概要

## プロジェクトの目的
CADDi製造業AIデータプラットフォームの経営戦略立案を支援するデータ分析プロジェクト

### 主な分析対象
- 受注実績・営業履歴 (Salesforce)
- プロダクト利用状況 (APIログ)
- 各種KPIデータ

## ディレクトリ構造
```
data_analysis_hub/
├── .claude/agents/     # エージェント設定（6つの専門エージェント）
├── notebooks/          # Jupyter分析ノートブック
├── data/              
│   ├── raw/           # 生データ
│   ├── processed/     # 前処理済みデータ
│   └── external/      # 外部データソース
├── scripts/           # 再利用可能なPythonスクリプト（現在は空）
├── output/            # 分析結果・レポート
├── .serena/           # Serena MCP関連
├── pyproject.toml     # プロジェクト設定・依存関係
├── CLAUDE.md          # Claude Code用ガイド
├── README.md          # プロジェクト説明
└── main.py            # メインエントリーポイント（現在は簡単な実装）
```

## 専門エージェント
1. **bigquery-analyst** - BigQueryデータ分析専門
2. **market-intelligence** - 市場調査・競合分析
3. **data-quality-checker** - データ品質検証
4. **api-log-analyzer** - APIログ分析
5. **cohort-analyst** - コホート分析
6. **report-automator** - レポート生成