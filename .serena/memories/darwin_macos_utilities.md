# Darwin/macOS システムユーティリティ

## システム情報
- **OS**: Darwin (macOS)
- **Platform**: darwin
- **OS Version**: Darwin 24.6.0

## macOS特有のコマンド

### ファイル管理
```bash
# ファイル削除（rmの代替）
trash file.txt  # trash-cliを使用（rmが権限エラーになる場合）

# ファイル検索
mdfind "search term"  # Spotlight検索
find . -name "*.py"   # 標準的なfind

# ディレクトリツリー表示
tree  # インストール必要: brew install tree
ls -R  # 再帰的リスト表示

# ファイル情報
stat file.txt  # 詳細なファイル情報
mdls file.txt  # Spotlightメタデータ
```

### プロセス管理
```bash
# プロセス確認
ps aux | grep python
top  # リアルタイムプロセス監視
htop  # より高機能（brew install htop）

# ポート使用確認
lsof -i :8080  # 特定ポート
netstat -an | grep LISTEN
```

### 環境変数
```bash
# 環境変数確認
printenv
echo $PATH
echo $VIRTUAL_ENV

# 環境変数設定（一時的）
export VAR_NAME=value

# 環境変数設定（永続的）
# ~/.zshrc または ~/.bash_profile に追加
```

### パス関連
```bash
# 現在のディレクトリ
pwd

# ホームディレクトリ
cd ~
echo $HOME

# 前のディレクトリに戻る
cd -
```

### テキスト処理
```bash
# ファイル内容表示
cat file.txt
less file.txt  # ページング
head -n 10 file.txt  # 最初の10行
tail -n 10 file.txt  # 最後の10行

# テキスト検索
grep -r "pattern" .  # 再帰的検索
grep -i "pattern" file.txt  # 大文字小文字無視
ag "pattern"  # Silver Searcher（高速）
rg "pattern"  # ripgrep（さらに高速）
```

### ディスク使用量
```bash
# ディスク使用量確認
df -h  # ディスク全体
du -sh *  # カレントディレクトリのサイズ
du -sh directory/  # 特定ディレクトリ
ncdu  # インタラクティブ（brew install ncdu）
```

### ネットワーク
```bash
# ネットワーク確認
ifconfig  # ネットワークインターフェース
ping google.com  # 接続確認
curl -I https://example.com  # HTTPヘッダー確認
wget url  # ファイルダウンロード（brew install wget）
```

### macOS固有の注意点
1. **大文字小文字を区別しないファイルシステム**（デフォルト）
   - file.txt と File.txt は同じファイルとして扱われる

2. **.DS_Store ファイル**
   - Finderが自動生成するメタデータファイル
   - .gitignoreに追加済み

3. **隔離属性（Quarantine）**
   - ダウンロードファイルに付与される
   - `xattr -d com.apple.quarantine file` で削除

4. **Gatekeeper**
   - 未署名アプリの実行制限
   - システム環境設定で制御

## Homebrew（パッケージマネージャー）
```bash
# インストール確認
brew --version

# パッケージ検索・インストール
brew search package
brew install package

# アップデート
brew update
brew upgrade
```

## プロジェクトで使用する主要ツール
- **Python**: .venv/bin/python（仮想環境）
- **uv**: ~/.local/bin/uv（Pythonパッケージマネージャー）
- **Git**: システムインストール済み
- **trash-cli**: rmコマンドの代替