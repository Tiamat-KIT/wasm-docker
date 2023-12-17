FROM  ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    libssl-dev \
    wget \
    && apt-get clean && rm -rf /var/lin/apt/lists/*

RUN apt install -y pkg-config 

# Install Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Set environment variables for Rust
ENV PATH="/root/.cargo/bin:${PATH}"
ENV RUST_HOME="/usr/local/rust"
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_HOME="/usr/local/cargo"
ENV CARGO_TARGET_DIR="/usr/local/cargo-target"

ENV RUST_BACKTRACE=1

# ENV USER_NAME tiamat
ENV TZ Asia/Tokyo

RUN cargo init develop
# RUN adduser ${USER_NAME} 
# RUN chown -R ${USER_NAME} /develop 
# RUN chown -R ${USER_NAME} ${CARGO_HOME}
# RUN chown -R ${USER_NAME} ${RUST_HOME}
# USER ${USER_NAME}

WORKDIR /develop
RUN rustup update 
RUN rustup set profile minimal && \
    rustup default nightly && \
    rustup target add wasm32-unknown-unknown --toolchain nightly
RUN rustup set profile default && rustup default stable
RUN cargo install wasm-bindgen-cli 
RUN wget -qO- https://github.com/trunk-rs/trunk/releases/download/0.17.10/trunk-x86_64-unknown-linux-gnu.tar.gz | tar -xzf-
RUN mv trunk /usr/local/bin
RUN touch index.html
RUN cargo add leptos
# RUN trunk serve --open --watch . --port 8080