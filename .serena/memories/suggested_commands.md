# 推奨コマンド一覧

## パッケージ管理（uv）
```bash
# 依存関係のインストール
uv sync

# 新しいパッケージの追加
uv add package-name

# 開発用パッケージの追加
uv add --dev package-name

# Pythonスクリプトの実行
uv run python script.py

# Jupyter Labの起動
uv run jupyter lab

# Jupyter Notebookの起動
uv run jupyter notebook
```

## コード品質チェック
```bash
# コードフォーマット（Black）
uv run black .
uv run black --check .  # チェックのみ

# リンティング（flake8）
uv run flake8 .
uv run flake8 scripts/  # 特定ディレクトリ

# 型チェック（mypy）
uv run mypy .
uv run mypy scripts/  # 特定ディレクトリ

# テスト実行（pytest）
uv run pytest
uv run pytest -v  # 詳細表示
uv run pytest --cov  # カバレッジ付き
uv run pytest tests/specific_test.py  # 特定テスト
```

## Git操作（Darwin/macOS）
```bash
# 基本操作
git status
git add .
git commit -m "commit message"
git push
git pull

# ブランチ操作
git branch -a
git checkout -b feature/branch-name
git merge main

# 差分確認
git diff
git diff --staged
```

## ファイル操作（macOS特有）
```bash
# ファイル削除（rmが使えない場合）
trash file.txt  # trash-cliを使用

# ファイル一覧
ls -la
ls -la data/

# ディレクトリ移動
cd notebooks/
cd ..

# ファイル検索
find . -name "*.py"
grep -r "pattern" .
```

## プロジェクト実行
```bash
# メインスクリプトの実行
uv run python main.py

# ノートブックのコマンドライン実行
uv run jupyter execute notebooks/00_installation_test.ipynb
```

## データ処理（BigQuery関連）
```bash
# BigQueryクエリ実行（Python経由推奨）
uv run python -c "from google.cloud import bigquery; print('BigQuery ready')"
```

## 環境確認
```bash
# Python環境確認
which python
python --version

# uv確認
which uv
uv --version

# 仮想環境の確認
echo $VIRTUAL_ENV

# インストール済みパッケージ一覧
uv pip list
```

## プロジェクトの初期セットアップ（新規環境）
```bash
# uvのインストール
curl -LsSf https://astral.sh/uv/install.sh | sh

# プロジェクトのセットアップ
uv sync

# 環境の確認
uv run python -c "import pandas; print('Setup complete')"
```