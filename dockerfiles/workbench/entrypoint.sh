#!/bin/bash
set -eu

########################################################################################################################
# shared directory
########################################################################################################################
# bash_history
test -d /home/${LOCAL_WHOAMI}/.shared_cache/bash/ || mkdir -p /home/${LOCAL_WHOAMI}/.shared_cache/bash/
test -f /home/${LOCAL_WHOAMI}/.shared_cache/bash/bash_history || touch /home/${LOCAL_WHOAMI}/.shared_cache/bash/bash_history && chmod 600 /home/${LOCAL_WHOAMI}/.shared_cache/bash/bash_history
ln -s /home/${LOCAL_WHOAMI}/.shared_cache/bash/bash_history /home/${LOCAL_WHOAMI}/.bash_history

########################################################################################################################
# Docker
########################################################################################################################
# dockerグループのgidをホストと同じにする
sudo groupmod -g ${LOCAL_DOCKER_GID} docker
# ユーザーをdockerグループに追加
sudo gpasswd -a ${LOCAL_WHOAMI} docker
# ユーザー所有権とグループ所有権をrootとdockerに変更
#sudo chown root:docker /var/run/docker.sock
# 所有ユーザーと所有グループに読み込み・書き込み権限を付与
#sudo chmod 660 /var/run/docker.sock

/bin/bash
