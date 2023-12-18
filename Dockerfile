# ベースイメージの指定
FROM ubuntu:latest

# apt-getのupdateと必要なパッケージのインストール
RUN apt-get update && \
    apt-get install -y curl gcc libssl-dev wget pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# pkg-configのインストール
RUN apt-get update && \
    apt-get install -y pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Rustのインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUSTUP_HOME="/root/.rustup"
ENV CARGO_HOME="/root/.cargo"
ENV RUST_HOME="/root/.rustup"
ENV CARGO_TARGET_DIR="/root/develop/target"

# 開発用のディレクトリ作成とcargo initの実行
RUN mkdir -p /root/develop && \
    cd /root/develop && \
    cargo init --name develop

# コンテナの起動時のディレクトリ指定
WORKDIR /root/develop/develop

# 追加のコマンド実行
RUN rustup update && \
    rustup set profile minimal && \
    rustup default nightly && \
    rustup target add wasm32-unknown-unknown --toolchain nightly && \
    rustup set profile default && \
    rustup default stable && \
    cargo install wasm-bindgen-cli && \
    cargo install --locked trunk && \
    touch index.html && \
    cargo add leptos
