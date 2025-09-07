# 技術スタック

## パッケージマネージャー
- **uv** - 高速なPythonパッケージマネージャー

## Python環境
- Python 3.11+ (3.11.11使用)
- 仮想環境: .venv/

## 主要なデータ処理ライブラリ
- **pandas** >= 2.0.0 - データ分析の基本
- **polars** >= 0.20.0 - 高速データ処理
- **numpy** >= 1.24.0, <2.0.0 - 数値計算（pandas 2.1互換性のため）
- **dask** - 並列・分散処理

## BigQuery & GCP関連
- **google-cloud-bigquery** >= 3.11.0
- **bigframes** >= 1.0.0 - pandas互換の分散処理API
- **pandas-gbq** >= 0.19.0

## 機械学習
- **scikit-learn** >= 1.3.0
- **xgboost** >= 2.0.0
- **lightgbm** >= 4.1.0
- **imbalanced-learn** >= 0.11.0

## 時系列予測
- **prophet** >= 1.1.5
- **statsmodels** >= 0.14.0
- **torch** >= 2.0.0
- **pytorch-forecasting** >= 0.10.0

## 可視化・ダッシュボード
- **matplotlib** >= 3.7.0
- **seaborn** >= 0.12.0
- **plotly** >= 5.17.0
- **dash** >= 2.18.0
- **streamlit** >= 1.28.0

## Jupyter環境
- **jupyter** >= 1.0.0
- **jupyterlab** >= 4.0.0
- **ipywidgets** >= 8.1.0

## データ品質
- **great-expectations** >= 1.2.0
- **pandera** >= 0.17.0

## 開発ツール（dev-dependencies）
- **pytest** >= 7.4.0 - テスト
- **pytest-cov** >= 4.1.0 - カバレッジ測定
- **black** >= 23.10.0 - コードフォーマッター
- **flake8** >= 6.1.0 - リンター
- **mypy** >= 1.6.0 - 型チェッカー

## MCP（Model Context Protocol）ツール
- BigQuery MCP
- Perplexity MCP（ask/research/reason）
- Filesystem MCP（推奨）
- Sequential Thinking MCP
- Atlassian MCP（Confluence/Jira）
- PDF Reader MCP
- Serena MCP（コード解析）
- Salesforce MCP（公式版）