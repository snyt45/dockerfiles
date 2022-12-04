# dockerfiles
作業用コンテナを管理するMakefileと構成ファイル群。

## 作業環境イメージ
参考：https://snyt45.com/D3wzdhCuc

![](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fmy_blog%2FDWXAyzZ2b4.png?alt=media&token=d98e3929-889a-4b26-bdfb-9a8c365c07d3)

## 作業用コンテナ Overview

![](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fyuta_sano%2F4dK7vi0zxJ.png?alt=media&token=0c5702cc-10df-48ce-a874-f74a30088d47)

![](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fyuta_sano%2FxgEWBY_DJj.png?alt=media&token=e70049d4-eaec-44e6-b2bd-5545aecc2f6e)

![](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fyuta_sano%2FiTuwXT4XTL.png?alt=media&token=46f74504-38db-4931-aa27-fe3bfe76e05c)

![](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fyuta_sano%2F5juDiFU-aK.png?alt=media&token=1af66f99-95ca-49c4-bbce-d8fa6b83ad27)

![](https://firebasestorage.googleapis.com/v0/b/firescript-577a2.appspot.com/o/imgs%2Fapp%2Fyuta_sano%2FjjoaEgY9xj.png?alt=media&token=99ea5f8d-b555-4f94-9528-4bfaf0f85c67)

## セットアップ

### 前提

WSL2セットアップ済みであること。

セットアップ方法は[こちら](https://github.com/snyt45/windows11-dotfiles#6-wsl2%E3%81%AE%E3%82%BB%E3%83%83%E3%83%88%E3%82%A2%E3%83%83%E3%83%97%E3%82%92%E8%A1%8C%E3%81%86)

### WSL側

TODO: setup用のスクリプトを作る。

#### 1. Git Setting
gitconfigの設定を行う。

```
git config --global user.name "メインアカウント"
git config --global user.email "メインアカウントメールアドレス"
git config --global core.editor vim
```

エイリアスメソッドの追加。
```
echo "alias g='git'" >> ~/.bashrc
source ~/.bashrc
```

#### 2. Clone

```
git clone https://github.com/snyt45/dockerfiles.git ~/.dockerfiles
```

#### 3. Requirement

```
sudo apt update && sudo apt upgrade
sudo apt install make
```

#### 4. Options

```
sudo apt install zoxide
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
source ~/.bashrc
```

#### 5. 共有用ディレクトリを作成する

```
mkdir -p ~/work/ && mkdir -p ~/.shared_cache/
```

| Dir | 説明 |
| --- | --- |
| ~/work/ | 作業データ共有用のディレクトリ |
| ~/.shared_cache/ | 作業用コンテナで作業時のキャッシュを残すためのディレクトリ |

#### 6. Git認証用のSSHディレクトリを作成する

参考：https://mykii.blog/use-many-github-accounts-by-ssh/

```
# メインアカウントのSSH鍵を作成
mkdir -p ~/.ssh && cd ~/.ssh
ssh-keygen -t ed25519 -C "メインアカウントのメールアドレス" -f "メインアカウントのファイル名"
cat {メインアカウントのファイル名}.pub # GitHubのSSH鍵に登録

# サブアカウントのSSH鍵を作成
ssh-keygen -t ed25519 -C "サブアカウントのメールアドレス" -f "サブアカウントのファイル名"
cat {サブアカウントのファイル名}.pub # GitHubのSSH鍵に登録
```

```
vim ~/.ssh/config
```

config
```
Host github-{メインアカウント}
	HostName github.com
	User {メインアカウントのユーザー名}
	IdentityFile ~/.ssh/{メインアカウントの秘密鍵}
	IdentitiesOnly yes
Host github-{サブアカウント}
	HostName github.com
	User {サブアカウントのユーザー名}
	IdentityFile ~/.ssh/{サブアカウントの秘密鍵}
	IdentitiesOnly yes
```

```
# 作成確認
ssh -T git@github-{メインアカウント用の名前}
ssh -T git@github-{サブアカウント用の名前}

# clone
cd ~/work

git clone git@github-{メインアカウント}:{ID}/{リポジトリ名}.git
git clone git@github-{サブアカウント}:{ID}/{リポジトリ名}.git
```

| Dir | 説明 |
| --- | --- |
| ~/.ssh/ | Git認証用のSSH鍵を置くディレクトリ |

#### 7. クリップボード対応
作業コンテナ内のクリップボードをホスト側に共有するための対応です。
※Vimでヤンクした内容は自動でホスト側に共有するようにvimrcに設定済みです。

参考：https://snyt45.com/uzCcEFHUw

Install

```
sudo apt install socat
```

 ~/.bashrcに追加

```
cat <<'SETTING' >> ~/.bashrc
if [[ $(command -v socat > /dev/null; echo $?) == 0 ]]; then
    # Start up the socat forwarder to clip.exe
    echo "Starting clipboard relay..."
    (setsid socat tcp-listen:8121,fork,bind=0.0.0.0 EXEC:'clip.exe' &) > /dev/null 2>&1
fi
# bashを開いて1度目は日本語のコピーがうまくいく
# bashを閉じて再度開くとsocatの子プロセスが動いたままのためなのかなぜか日本語のコピー時に文字化けする
# bashを閉じるときにsocatの子プロセスをkillして、開くたびにsocatの子プロセスを作るようにすると文字化け問題が解消したので毎回bashを閉じるとkillしている
function hndl_SIGHUP() {
  kill -9 $(lsof -t -i :8121)
  exit 1
}
trap hndl_SIGHUP SIGHUP
SETTING
```

#### 8. VSCode対応
作業コンテナ内で`code .`を実行すると、ホスト側で`code .`を実行するための対応です。
※ホスト側で`code .`を実行する仕組みのため、コンテナとホスト側でバインドマウントしているディレクトリのみ開けます。

Install

```
sudo apt install socat
```

 ~/.bashrcに追加

```
cat <<'SETTING' >> ~/.bashrc
if [[ $(command -v socat > /dev/null; echo $?) == 0 ]]; then
    # Start up the socat forwarder to VScode
    ALREADY_RUNNING_VSCODE=$(ps -auxww | grep -q "[l]isten:8122"; echo $?)
    if [[ $ALREADY_RUNNING_VSCODE != "0" ]]; then
        echo "Starting VScode relay..."
        (setsid socat tcp-listen:8122,fork,bind=0.0.0.0 EXEC:'/bin/bash' &) > /dev/null 2>&1
    else
        echo "VScode relay already running"
    fi
fi
SETTING
```

#### 9. GitHub CLI対応

アカウント毎に設定を行う。

参考: https://gist.github.com/yermulnik/017837c01879ed3c7489cc7cf749ae47

`mkdir -p ~/.config/gh && vi ~/.config/gh/config.yml`
```
git_protocol: ssh
aliases:
    personal: '!cp ~/.config/gh/hosts.yml.personal ~/.config/gh/hosts.yml && gh auth status'
    work: '!cp ~/.config/gh/hosts.yml.work ~/.config/gh/hosts.yml && gh auth status'
```

`mkdir -p ~/.config/gh && vi ~/.config/gh/hosts.yml.personal`
```
github.com:
    oauth_token: ghp_[…]
    git_protocol: ssh
    user: yuta.sano
```

`mkdir -p ~/.config/gh && vi ~/.config/gh/hosts.yml.work`
```
github.com:
    oauth_token: ghp_[…]
    git_protocol: ssh
    user: yuta.sano
```

### 作業用コンテナ側

#### 1. Git Setting

プロジェクト毎に設定を行う。

```
git config --local user.name "サブアカウント"
git config --local user.email "サブアカウントメールアドレス"
```

## 基本的なワークフロー

### 作業用コンテナにアタッチ

基本はmakeコマンドでtargetを指定して実行し、作業用コンテナにアタッチして作業を開始する。

```
make target="workbench"
```

- 作業用コンテナを起動して、コンテナにアタッチする
  - 作業用コンテナが存在しない場合はgit pullする
  - 作業用コンテナのイメージが存在しない場合はイメージをビルドする

### 初回のみvoltaをshared_cacheに移動する

ホームディレクトリからshared_cacheに移動することで永続化できる。

```
make target="workbench"
sudo mv ~/.volta ~/.shared_cache/
```

### Dockerfileや構成ファイルの設定を反映させたい場合

一度コンテナを削除してビルドし直したうえでアタッチする。

```
make stop target="workbench"
make build target="workbench"
make target="workbench"
```

### 作業用コンテナでアプリケーションサーバを起動する
作業用コンテナで起動したアプリケーションサーバにlocalhostでアクセスするためには以下の2点を実施する必要があります。

- `docker container run`時、`-p`オプションでコンテナのポート割り当てをする
- アプリケーションサーバ起動時、`0.0.0.0`でLISTENするよう変更する
  - (例)viteの場合、yarn dev --host

### 既存のClone済みのリポジトリでSSH鍵を使う

次のように url を書き換える。

参考： https://msyksphinz.hatenablog.com/entry/2019/10/28/040000

```
git config -e

// 書き換え前
[remote "origin"]
        url = https://github.com/snyt45/dockerfiles.git
        fetch = +refs/heads/*:refs/remotes/origin/*

// 書き換え後
[remote "origin"]
        url = git@github-snyt45:snyt45/dockerfiles.git
        fetch = +refs/heads/*:refs/remotes/origin/*
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

## Inspire

[作業環境をDockerfileにまとめて、macOSでもLinuxでもWSL2でも快適に過ごせるようになった話](https://zenn.dev/hinoshiba/articles/workstation-on-docker)
