# Data Analysis Hub

CADDi製造業AIデータプラットフォームの経営戦略立案を支援するデータ分析プロジェクト

## 🎯 概要

このプロジェクトは、CADDiの営業データ、プロダクト利用状況、各種KPIを統合的に分析し、データドリブンな経営戦略の立案を支援します。BigQueryとGemini APIを活用した最先端のデータ分析基盤を提供します。

## ✨ 主な機能

### 📊 データ分析
- **営業データ分析**: Salesforceの受注実績・営業履歴の詳細分析
- **プロダクト分析**: APIログからの利用状況とユーザー行動分析
- **コホート分析**: 顧客セグメント別のLTV・リテンション分析
- **統合KPI分析**: 各種KPIの統合的な可視化とトレンド分析

### 🤖 AI機能
- **自然言語クエリ**: Gemini APIを使用した自然言語でのBigQueryデータ分析
- **自動レポート生成**: 定期的な分析レポートの自動生成
- **異常検知**: 機械学習による異常値・外れ値の自動検出

### 📈 可視化・ダッシュボード
- **インタラクティブダッシュボード**: Streamlit/Dashによるリアルタイム分析
- **カスタムレポート**: ビジネス要件に応じたカスタマイズ可能なレポート

## 🛠 技術スタック

### データ処理
- **pandas** (v2.0+) - データ処理の基盤
- **polars** (v0.20+) - 高速データ処理
- **dask** - 並列・分散処理
- **bigframes** - BigQuery互換の分散処理API

### データウェアハウス
- **Google BigQuery** - メインデータウェアハウス
- **BigQuery ML** - SQLベースの機械学習
- **Materialized Views** - 自動更新されるビュー

### 機械学習
- **scikit-learn** - 基本的な機械学習アルゴリズム
- **xgboost, lightgbm** - 勾配ブースティング
- **prophet** - 時系列予測
- **pytorch-forecasting** - 深層学習による高度な予測
- **lifetimes** - 顧客生涯価値(CLV/LTV)分析

### 可視化
- **matplotlib, seaborn** - 静的可視化
- **plotly** - インタラクティブグラフ
- **dash, streamlit** - Webダッシュボード

### 開発環境
- **uv** - 高速パッケージマネージャー
- **Jupyter Lab** - 分析環境
- **pytest** - テスティング

## 📁 プロジェクト構造

```
data_analysis_hub/
├── 📓 notebooks/              # 分析用Jupyterノートブック
│   └── bigquery_nl_analysis_with_gemini.ipynb  # 自然言語分析
├── 📊 data/                   # データファイル
│   ├── raw/                   # 生データ
│   ├── processed/             # 加工済みデータ
│   ├── external/              # 外部データソース
│   └── salesforce_metadata/   # Salesforceメタデータ
├── 🗄️ database/               # データベース関連
│   └── business_logic/        # ビジネスロジック管理
│       └── README.md          # Persistent UDFs等のドキュメント
├── 🔧 scripts/                # 実行スクリプト
│   ├── update_existing_columns_only.py  # スキーマ更新
│   └── fix_multiline_descriptions.py    # 説明文修正
├── 📈 output/                 # 分析結果の出力
├── 🤖 .claude/                # Claude Code設定
│   └── agents/                # カスタムエージェント定義
├── 📋 CLAUDE.md               # Claude Code用ガイドライン
└── 📦 pyproject.toml          # プロジェクト設定
```

## 🚀 セットアップ

### 前提条件
- Python 3.11以上
- Google Cloud SDKのインストールと認証
- BigQueryへのアクセス権限
- Gemini API キー（自然言語分析用）

### インストール

```bash
# リポジトリのクローン
git clone https://github.com/caddi-shayashi/data_analysis_hub.git
cd data_analysis_hub

# uvのインストール（未インストールの場合）
curl -LsSf https://astral.sh/uv/install.sh | sh

# 依存関係のインストール
uv sync

# 環境変数の設定
cp .env.example .env
# .envファイルを編集してAPI KEYを設定
```

### 起動

```bash
# Jupyter Labの起動
uv run jupyter lab

# Streamlitダッシュボードの起動（実装時）
uv run streamlit run app.py
```

## 📖 使用方法

### 1. 自然言語でのBigQuery分析

```python
# notebooks/bigquery_nl_analysis_with_gemini.ipynb を開く
analyzer = NLToBigQueryAnalyzer(project_id="caddi-ceo-office")
result = analyzer.analyze("先月の売上上位10社を教えて")
```

### 2. BigQueryデータセット

主要なデータセット:
- `dm_business_planning.salesforce_account_mart` - 顧客マスタ
- `dm_business_planning.salesforce_opportunity_mart` - 商談データ
- `data_analysis_hub.sf_account` - Salesforceアカウント（Materialized View）

### 3. カスタムエージェント

`.claude/agents/`配下のエージェント:
- **bigquery-analyst** - BigQuery専門の分析
- **market-intelligence** - 市場調査・競合分析
- **data-quality-checker** - データ品質検証
- **cohort-analyst** - コホート分析専門
- **report-automator** - レポート自動生成
- **api-log-analyzer** - APIログ分析

## 📊 利用可能なMCPツール

- **BigQuery MCP** - データウェアハウス連携
- **Perplexity MCP** - AI検索・調査・推論
- **Salesforce MCP** - Salesforceデータ連携
- **Filesystem MCP** - 高速ファイル操作
- **Sequential Thinking MCP** - 複雑問題解決
- **Atlassian MCP** - Confluence/Jira連携
- **PDF Reader MCP** - PDF分析
- **Serena MCP** - コード解析

## 🔐 セキュリティ

- API KEYは環境変数で管理
- BigQueryアクセスはIAMで制御
- 機密データはgitignoreで除外
- Salesforce認証はCLIトークンを利用

## 📝 開発ガイドライン

詳細な開発ガイドラインは[CLAUDE.md](CLAUDE.md)を参照してください。

### コーディング規約
- PEP 8準拠
- Type hintsの使用推奨
- Docstringsの記載必須

### テスト
```bash
# テストの実行
uv run pytest

# カバレッジレポート
uv run pytest --cov
```

## 🤝 コントリビューション

内部プロジェクトのため、CADDiメンバーのみコントリビューション可能です。

1. Feature branchを作成
2. 変更をコミット
3. Pull Requestを作成
4. コードレビュー後にマージ

## 📄 ライセンス

CADDi内部プロジェクト - Proprietary

## 📞 お問い合わせ

- プロジェクトオーナー: @caddi-shayashi
- Slackチャンネル: #data-analysis-hub

---

*Last Updated: 2025-01-07*