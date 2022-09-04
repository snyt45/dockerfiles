# dockerfiles
作業用コンテナを管理するMakefileと構成ファイル群。

## 作業環境イメージ
参考：https://snyt45.com/D3wzdhCuc

![](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fmy_blog%2FDWXAyzZ2b4.png?alt=media&token=d98e3929-889a-4b26-bdfb-9a8c365c07d3)

## 作業用コンテナ Overview

![](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fyuta_sano%2F4dK7vi0zxJ.png?alt=media&token=0c5702cc-10df-48ce-a874-f74a30088d47)

![](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fyuta_sano%2FxgEWBY_DJj.png?alt=media&token=e70049d4-eaec-44e6-b2bd-5545aecc2f6e)

![](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fyuta_sano%2FiTuwXT4XTL.png?alt=media&token=46f74504-38db-4931-aa27-fe3bfe76e05c)

## セットアップ

0. WSL2セットアップ

参考：https://github.com/snyt45/windows11-dotfiles#4-wsl2%E3%81%AE%E3%82%BB%E3%83%83%E3%83%88%E3%82%A2%E3%83%83%E3%83%97%E3%82%92%E8%A1%8C%E3%81%86

1. Download

```
git clone https://github.com/snyt45/dockerfiles.git ~/.dockerfiles
```

2. Requirement

```
sudo apt install make
```

3. 共有用ディレクトリを作成する

```
mkdir -p ~/work/ && mkdir -p ~/.shared_cache/
```

| Dir | 説明 |
| --- | --- |
| ~/work/ | 作業データ共有用のディレクトリ |
| ~/.shared_cache/ | 作業用コンテナで作業時のキャッシュを残すためのディレクトリ |

## 基本的なワークフロー

### 作業用コンテナにアタッチ

基本はmakeコマンドでtargetを指定して実行し、作業用コンテナにアタッチして作業を開始する。

```
make target="workbench"
```

- 作業用コンテナを起動して、コンテナにアタッチする
  - 作業用コンテナが存在しない場合はgit pullする
  - 作業用コンテナのイメージが存在しない場合はイメージをビルドする

### Dockerfileや構成ファイルの設定を反映させたい場合

一度コンテナを削除してビルドし直したうえでアタッチする。

```
make stop target="workbench"
make repopull target="workbench"
make build target="workbench"
make target="workbench"
```

## クリップボード対応
参考：https://snyt45.com/uzCcEFHUw

1. Install

```
sudo apt install socat
```

2. ~/.bashrcに追加

```
if [[ $(command -v socat > /dev/null; echo $?) == 0 ]]; then
    # Start up the socat forwarder to clip.exe
    ALREADY_RUNNING=$(ps -auxww | grep -q "[l]isten:8121"; echo $?)
    if [[ $ALREADY_RUNNING != "0" ]]; then
        echo "Starting clipboard relay..."
        (setsid socat tcp-listen:8121,fork,bind=0.0.0.0 EXEC:'clip.exe' &) > /dev/null 2>&1
    else
        echo "Clipboard relay already running"
    fi
fi
```

## makeコマンド

| コマンド | 説明 |
| ---- | ---- |
| make target="workbench" | repopull -> start -> attach の順に実行 |
| make repopull target="workbench" | dockerfilesのrepoをpull |
| make build target="workbench" | targetのdocker imagerをビルド |
| make stop target="workbench" | targetのdocker containerを削除 |
| make clean target="workbench" | targetのdocker imageを削除 |
| make allrm | 全てのdocker containerを削除 |
| make allrmi | 全てのdocker imageを削除 |
| make help | ヘルプを表示 |
