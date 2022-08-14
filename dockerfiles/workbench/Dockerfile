FROM ubuntu:22.04 AS workbench
LABEL maintainer="snyt45@gmail.com"

########################################################################################################################
# 基本設定
########################################################################################################################
# タイムゾーンを東京に設定
ENV TZ Asia/Tokyo
# ロケールを日本語に設定
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF8

########################################################################################################################
# ソフトウェアインストール
########################################################################################################################
# デフォルトシェルをbashにする
SHELL ["/bin/bash", "-l", "-c"]
# aptの高速化
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list
RUN apt update && \
    apt upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
      tzdata \
      language-pack-ja \
      sudo \
      curl \
      git \
      vim \
      tmux \
      fzf \
      ripgrep \
      bat \
      zoxide

# node、yarn インストール
RUN curl https://get.volta.sh | bash
RUN volta install node && volta install yarn

# starship インストール
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

# vim
# TODO: 毎回、:PlugInstallは大変なのでどうにかしたい
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

########################################################################################################################
# dotfiles
########################################################################################################################
ADD ./setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh
ADD ./dotfiles /etc/dotfiles
RUN chmod +x /etc/dotfiles/bin/ide

########################################################################################################################
# シンボリックリンク作成
########################################################################################################################
RUN ln -sf /usr/bin/batcat /usr/local/bin/bat && \
    mkdir -p ~/.vim && \
    ln -sf /etc/dotfiles/.vim/vimrc ~/.vim/ && \
    ln -sf /etc/dotfiles/.bash_profile ~/ && \
    ln -sf /etc/dotfiles/.bashrc_local ~/ && \
    ln -sf /etc/dotfiles/.tmux.conf ~/ && \
    mkdir -p ~/bin && \
    ln -sf /etc/dotfiles/bin/ide /usr/local/bin/

########################################################################################################################
# bash
########################################################################################################################
# bashrcにbashrc_localを読み込む設定を追加
RUN echo "if [ -f "$HOME/.bashrc_local" ]; then . "$HOME/.bashrc_local"; fi;" >> ~/.bashrc

ENTRYPOINT ["/bin/bash"]
