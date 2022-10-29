FROM ubuntu:22.04 AS builder
LABEL maintainer="snyt45@gmail.com"

ENV LANG ja_JP.UTF-8
ARG USERNAME=user
ARG GROUPNAME=user
ARG PASSWORD=password
ARG UID=1000
ARG GID=1000

# apt高速化
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list
RUN apt update && apt upgrade -y && apt install -y curl sudo git locales vim && \
    locale-gen ja_JP.UTF-8

RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    echo "$USERNAME ALL=(ALL) ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR /home/$USERNAME/
