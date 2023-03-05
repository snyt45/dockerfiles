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

セットアップ方法は[こちら](https://github.com/snyt45/windows11-dotfiles)

### WSL側

TODO: setup用のスクリプトを作る。

#### 0. WSL Setting
WSLディストリビューションの設定を行う。

- DNSの名前解決に使うresolv.confの自動生成をOFF
- WSLでsystemdを有効にする

1. `/etc/wsl.conf`を編集する(`sudo vi /etc/wsl.conf`)
```
[network]
generateResolvConf = false

[boot]
systemd=true
```

2. `/etc/resolv.conf`を編集する(`sudo vi /etc/resolv.conf`)
```
nameserver 8.8.8.8
```

3. WSLを再起動する(`wsl --shutdown`)

#### 1. Git Setting
gitconfigの設定を行う。

```
git config --global user.name "global"
git config --global user.email "global@example.com"
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

| Dir | 説明 |
| --- | --- |
| ~/work/ | 作業データ共有用のディレクトリ |
| ~/.shared_cache/ | 作業用コンテナで作業時のキャッシュを残すためのディレクトリ |

```
mkdir -p ~/work/ && mkdir -p ~/.shared_cache/
```


#### 6. Git認証用のSSHディレクトリを作成する

| Dir | 説明 |
| --- | --- |
| ~/.ssh/ | Git認証用のSSH鍵を置くディレクトリ |

```
mkdir -p ~/.ssh/
```

`.ssh`配下にSSH鍵と`config`ファイルをコピーしてくる。

SSH鍵は適切なパーミッションに変更する
```
chmod 600 main
```

#### 7. WSL側の情報をホスト側に送信できるようにする

名前付きパイプをDockerでマウントすることで、Dockerコンテナ側からホスト側に情報を送信できるようにします。

参考：https://github.com/peccu/copy-from-container-in-wsl

<details>
<summary>クリップボード対応</summary>

作業コンテナ内のクリップボードをホスト側に共有するための対応です。

※Vimでヤンクした内容は自動でホスト側に共有するようにvimrcに設定済みです。

クリップボード用の名前付きパイプを作成します。

```
[ -p ~/clip ] && echo already exists the pipe for clip || mkfifo ~/clip
```

`clip.sh`を作成します。

```
cat <<'SETTING' >> ~/clip.sh
#!/bin/bash
while true
do
  # 文字化け対応
  # see: https://nodamushi.hatenablog.com/entry/2018/01/12/195253
  cat $HOME/clip | iconv -f UTF-8 -t CP932 | /mnt/c/Windows/system32/clip.exe
done
SETTING
```

パーミッションを設定します。

```
chmod +x ~/clip.sh
```

`crontab -e`でcrontabに書き込みます。

```
@reboot $HOME/clip.sh
```

`.bashrc`でcrontabの起動チェックするようにします。

```
cat <<'SETTING' >> ~/.bashrc
if [[ -n `service cron status | grep not` ]];then
  echo "cron is not running. Type password to run it."
  sudo service cron start
fi
SETTING
```

</details>


### 作業用コンテナ側

#### 1. Git Setting

プロジェクト毎に設定を行う。

```
git config --local user.name "pj.tarou"
git config --local user.email "pj@example.com"
```

## make操作コマンド

<details>
<summary>作業用コンテナのイメージをビルド</summary>

```
make build target="workbench"
```
</details>


<details>
<summary>作業用コンテナのイメージを削除</summary>

```
make clean target="workbench"
```
</details>


<details>
<summary>作業用コンテナを起動&アタッチ</summary>

```
make target="workbench"
```

makeコマンドでtargetを指定してコンテナを起動し、作業用コンテナにアタッチして作業を開始する。
</details>


<details>
<summary>作業用コンテナを削除</summary>

```
make stop target="workbench"
```

makeコマンドでtargetを指定してコンテナを削除する。
</details>


<details>
<summary>全てのdocker imageを削除</summary>

```
make allrmi
```
</details>


<details>
<summary>全てのdocker containerを削除</summary>

```
make allrm
```
</details>


<details>
<summary>makeコマンドのヘルプを表示</summary>

```
make help
```
</details>


## 作業Memo

<details>
<summary>voltaを永続化する方法</summary>

ホームディレクトリから `shared_cache` に移動する。
```
make target="workbench"
sudo mv ~/.volta ~/.shared_cache/
```

`VOLTA_HOME`を`$HOME/.shared_cache/.volta`に設定しているため、
この操作を一度行えば、次回以降は`shared_cache`側を見るようになる。

</details>


<details>
<summary>Dockerfileや構成ファイルの設定を反映させる方法</summary>
一度コンテナを削除してビルドし直したうえでアタッチする。

```
make stop target="workbench"
make build target="workbench"
make target="workbench"
```
</details>


<details>
<summary>作業用コンテナで起動したアプリケーションサーバにlocalhostでアクセスする方法(viteの場合)</summary>

- 作業コンテナ起動時に公開するポートを指定する(`make target="workbench" port=3030`)
- アプリケーションサーバ起動時、`0.0.0.0`でLISTENするよう変更する
  - (例)viteの場合、yarn dev --host
</details>

<details>
<summary>GitHubでSSH鍵を使った複数アカウントの対応</summary>

1. メインとサブアカウントのSSH鍵を作成して、GihHubに登録します。

```
# メインアカウントのSSH鍵を作成
mkdir -p ~/.ssh && cd ~/.ssh
ssh-keygen -t ed25519 -C "main@example.com" -f "main"
cat main.pub #=> GitHubのSSH鍵に登録

# サブアカウントのSSH鍵を作成
ssh-keygen -t ed25519 -C "sub@example.com" -f "sub"
cat sub.pub #=> GitHubのSSH鍵に登録
```

2. `config`というファイルを作成して、アカウント毎に対応するSSH鍵を設定します。

```
vim ~/.ssh/config
```

[config]
```
Host github-main
	HostName github.com
	User main.tarou
	IdentityFile ~/.ssh/main
	IdentitiesOnly yes
Host github-sub
	HostName github.com
	User sub.tarou
	IdentityFile ~/.ssh/sub
	IdentitiesOnly yes
```

3. 正しく設定できたか確認します。

```
# 作成確認
ssh -T git@github-main
ssh -T git@github-sub
```

参考：https://mykii.blog/use-many-github-accounts-by-ssh/
</details>


<details>
<summary>GitHubにSSH接続してpushする方法(Clone前のリポジトリの場合)</summary>

例）`git clone git@github-main:snyt45/dockerfiles.git`

</details>


<details>
<summary>GitHubにSSH接続してpushする方法(Clone済みのリポジトリの場合)</summary>

リポジトリに移動した状態で`git config -e`してurlを書き換える

```
// 書き換え前
url = https://github.com/snyt45/dockerfiles.git

// 書き換え後
url = git@github-main:snyt45/dockerfiles.git
```

参考： https://msyksphinz.hatenablog.com/entry/2019/10/28/040000
</details>


<details>
<summary>GitHub CLIの複数アカウント対応</summary>
アカウント毎に設定を行う。

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

参考: https://gist.github.com/yermulnik/017837c01879ed3c7489cc7cf749ae47
</details>

<details>
<summary>cronを有効にするためにsystemdを有効にする</summary>

WSLで「/etc/wsl.conf」というファイルを作成する。

以下の内容を記載する。

```
[boot]
systemd=true
```

powershellでWSLをシャットダウンする。

```
wsl --shutdown
```

systemdがPID=1で起動していることを確認する。

```
ps -ae
```

参考： https://snowsystem.net/other/windows/wsl2-ubuntu-systemctl/
</details>

<details>
<summary>cronのログを有効にする</summary>

systemdがPID=1で起動していることを確認する。

```
ps -ae
```

ログを有効化するためにコメントアウトを外す。

```
vi /etc/rsyslog.d/50-default.conf
```

```
#cron.*                   /var/log/cron.log     # 編集前
  ↓
cron.*                    /var/log/cron.log     # 編集後
```

ログを確認する。

```
cat /var/log/cron.log
```

参考： https://www.server-memo.net/ubuntu/ubuntu_cron_log.html
</details>

## Inspire

[作業環境をDockerfileにまとめて、macOSでもLinuxでもWSL2でも快適に過ごせるようになった話](https://zenn.dev/hinoshiba/articles/workstation-on-docker)
