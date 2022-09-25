FROM golang:1.18.5 AS builder
LABEL maintainer="snyt45@gmail.com"

ENV GO111MODULE=on

ENV LANG ja_JP.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y curl wget tzdata file locales && \
    apt install -y vim-nox && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    locale-gen ja_JP.UTF-8
RUN mkdir /.cache && \
    chmod 777 /.cache && \
    mkdir /usertmp && \
    chmod 777 /usertmp

WORKDIR ${GOPATH}
