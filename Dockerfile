FROM  ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    libssl-dev \
    wget \
    && apt-get clean && rm -rf /var/lin/apt/lists/*

RUN apt install -y pkg-config 

# Install Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh \
    && sh rustup.sh -y --default-toolchain stable --profile default \
    && rm rustup.sh

# Set environment variables for Rust
ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUST_HOME="/root"
ENV RUSTUP_HOME="/root/.rustup"
ENV CARGO_HOME="/root/.cargo"
ENV CARGO_TARGET_DIR="/root/.cargo/target"

# Set the default Rust toolchain
RUN rustup default stable
ENV RUST_BACKTRACE=1

# ENV USER_NAME tiamat
ENV TZ Asia/Tokyo
# Set the default Rust toolchain
RUN rustup default stable

RUN cargo init develop
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