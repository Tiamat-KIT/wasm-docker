FROM  ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    libssl-dev \
    && apt-get clean && rm -rf /var/lin/apt/lists/*

RUN apt install pkg-config -y


# Rust Install 
ENV RUST_HOME /usr/local/lib/rust
ENV RUSTUP_HOME ${RUST_HOME}/rustup
ENV CARGO_HOME ${RUST_HOME}/cargo 
ENV CARGO_TARGET_DIR /tmp/target
ENV RUST_BACKTRACE 1

ENV USER_NAME tiamat
ENV TZ Asia/Tokyo


RUN mkdir /usr/local/lib/rust && \
    chmod u+x ${RUST_HOME}
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > ${RUST_HOME}/rustup.sh \
    && chmod u+x ${RUST_HOME}/rustup.sh \
    && ${RUST_HOME}/rustup.sh -y --default-toolchain nightly --no-modify-path
ENV PATH $PATH:$CARGO_HOME/bin

RUN cargo init develop
RUN adduser ${USER_NAME} && \
    chown -R ${USER_NAME} /develop && \
    chown -R ${USER_NAME} ${CARGO_HOME} && \
    chown -R ${USER_NAME} ${RUST_HOME}
USER ${USER_NAME}

WORKDIR /develop
RUN rustup update 
RUN rustup set profile minimal && \
    rustup default nightly && \
    rustup target add wasm32-unknown-unknown --toolchain nightly
RUN rustup set profile default && rustup default stable
RUN cargo install wasm-bindgen-cli 
RUN cargo install --locked trunk
RUN touch index.html
RUN cargo add leptos
# RUN trunk serve --open --watch . --port 8080