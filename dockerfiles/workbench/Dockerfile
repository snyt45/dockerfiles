FROM ubuntu:22.04 AS workbench
LABEL maintainer="snyt45@gmail.com"

ARG local_uid=9001
ARG local_gid=9001
ARG local_home
ARG local_whoami
ARG local_docker_gid
ARG password=password

########################################################################################################################
# apt install
########################################################################################################################
# apt高速化
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list
# rootユーザーで実施。この後作成するユーザーだとライブラリによってインストールが進行しないことがあったため。
RUN apt update && apt install -y \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*
RUN add-apt-repository -y ppa:jonathonf/vim
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
      tzdata \
      language-pack-ja \
      sudo \
      curl \
      wget \
      unzip \
      socat \
      trash-cli \
      git \
      vim \
      tmux \
      fzf \
      ripgrep \
      bat \
      zoxide \
      golang \
      python3-pip \
      universal-ctags \
      rbenv
# Docker
# ref: https://matsuand.github.io/docs.docker.jp.onthefly/engine/install/ubuntu/
# リポジトリのセットアップ
RUN apt update && \
    apt install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Docker Engineのインストール
RUN apt update && \
    apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

########################################################################################################################
# ユーザー作成 & 切替
########################################################################################################################
# rootユーザーのパスワードをrootに設定。rootユーザーに切替えたいとき用。
RUN echo "root:root" | chpasswd
# ホストと同じユーザーグループ作成(gid: ${local_gid}、グループ名: ${local_whoami})
RUN groupadd -g ${local_gid} ${local_whoami}
# ユーザー作成(uidが同じユーザーの作成を許す、ホームディレクトリ作成する、uid: ${local_uid}、gid(primary): ${local_gid}、 gid(secondary): sudo、ユーザー名: ${local_whoami})
RUN useradd -o -m -u ${local_uid} -g ${local_gid} -G sudo ${local_whoami}
# 作成したユーザーのパスワードを${password}に設定
RUN echo ${local_whoami}:${password} | chpasswd
# 作成したユーザーがパスワードなしでsudoコマンドを実行できるようにする
RUN echo "${local_whoami} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${local_whoami}
WORKDIR /home/${local_whoami}/

########################################################################################################################
# ソフトウェアインストール
########################################################################################################################
# starship
RUN sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
# deno
RUN curl -fsSL https://deno.land/install.sh | sh
# volta
RUN ["/bin/bash", "-l", "-c", "curl https://get.volta.sh | bash"]
RUN ["/bin/bash", "-l", "-c", "volta install node"]
RUN ["/bin/bash", "-l", "-c", "volta install yarn"]
# efm-langserver
RUN go install github.com/mattn/efm-langserver@latest
# Lint
RUN ["/bin/bash", "-l", "-c", "pip install vim-vint"]
RUN sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.10.0/hadolint-Linux-x86_64 && \
    sudo chmod +x /bin/hadolint
# lazygit
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[0-36.]+') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
# delta
RUN sudo wget https://github.com/dandavison/delta/releases/download/0.14.0/delta-0.14.0-x86_64-unknown-linux-musl.tar.gz && \
    sudo tar -zxvf delta-0.14.0-x86_64-unknown-linux-musl.tar.gz && \
    cd delta-0.14.0-x86_64-unknown-linux-musl && \
    sudo mv ./delta /usr/local/bin
# GitHub CLI
RUN type -p curl >/dev/null || sudo apt install curl -y && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    sudo apt update && \
    sudo apt install gh -y
# rbenv
RUN mkdir -p "$(rbenv root)"/plugins && \
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build && \
    rbenv install 3.1.2 && \
    rbenv global 3.1.2

########################################################################################################################
# ファイル追加・権限
########################################################################################################################
ADD ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sudo chmod +x /usr/local/bin/entrypoint.sh
ADD ./dotfiles /etc/dotfiles
RUN sudo chmod +x /etc/dotfiles/bin/ide
RUN sudo chmod +x /etc/dotfiles/bin/clip.sh
RUN sudo chmod +x /etc/dotfiles/bin/code

########################################################################################################################
# シンボリックリンク作成
########################################################################################################################
# bat
RUN sudo ln -s /usr/bin/batcat /usr/local/bin/bat
# vim
RUN mkdir -p /home/${local_whoami}/.vim/ && \
    ln -s /etc/dotfiles/.vim/vimrc /home/${local_whoami}/.vim/ && \
    mkdir -p /home/${local_whoami}/.vim/autoload/ && \
    curl -fLo /home/${local_whoami}/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN mkdir -p /home/${local_whoami}/.vim/config && \
    for file in /etc/dotfiles/.vim/config/*; do ln -s ${file} /home/${local_whoami}/.vim/config; done
# bash
RUN ln -sf /etc/dotfiles/.bashrc /home/${local_whoami}/ && \
    ln -sf /etc/dotfiles/.bash_profile /home/${local_whoami}/ && \
    ln -s /etc/dotfiles/.bashrc_local /home/${local_whoami}/ && \
    ln -s /etc/dotfiles/.tmux.conf /home/${local_whoami}/
# bin
RUN sudo ln -s /etc/dotfiles/bin/ide /usr/local/bin/
RUN sudo ln -s /etc/dotfiles/bin/clip.sh /usr/local/bin/
RUN sudo ln -s /etc/dotfiles/bin/code /usr/local/bin/
RUN sudo ln -s /home/${local_whoami}/.local/bin/vint /usr/local/bin/
# deno
RUN sudo ln -s /home/${local_whoami}/.deno/bin/deno /usr/local/bin/deno
# lazygit
RUN mkdir -p /home/${local_whoami}/.config/lazygit && \
    ln -s /etc/dotfiles/.config/lazygit/config.yml /home/${local_whoami}/.config/lazygit

########################################################################################################################
# permission
########################################################################################################################
RUN sudo chown -R ${local_whoami}:${local_whoami} /etc/dotfiles && \
    sudo chown -R ${local_whoami}:${local_whoami} "${local_home}"

########################################################################################################################
# 基本設定
########################################################################################################################
# タイムゾーンを東京に設定
ENV TZ Asia/Tokyo
# ロケールを日本語に設定
# docker buildの途中に日本語になるとbuildが進行しない/エラーになるため最後に日本語化している
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF8

# docker run実行時に毎回実行する
# docker run時に環境変数やdocker.sockをマウントするため、このタイミングでdocker.sockなどに対して設定している
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
