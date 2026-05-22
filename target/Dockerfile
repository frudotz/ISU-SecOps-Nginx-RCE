FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    cmake \
    git \
    wget \
    libpcre3-dev \
    zlib1g-dev \
    libssl-dev \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Clone Nginx 1.25.3 which has QUIC/HTTP3 support
WORKDIR /src
RUN wget https://nginx.org/download/nginx-1.25.3.tar.gz && \
    tar zxf nginx-1.25.3.tar.gz

WORKDIR /src/nginx-1.25.3

# Compile with ASAN/UBSAN and HTTP/3
RUN ./configure \
    --with-http_v3_module \
    --with-stream_quic_module \
    --with-cc="clang" \
    --with-cc-opt="-fsanitize=address,undefined -g -O0 -fno-omit-frame-pointer" \
    --with-ld-opt="-fsanitize=address,undefined" \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid && \
    make -j$(nproc) && \
    make install

# Generate self-signed cert for QUIC/TLS 1.3 testing
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/key.pem -out /etc/nginx/cert.pem \
    -subj "/C=US/ST=State/L=City/O=Lab/OU=SecOps/CN=localhost"

COPY nginx.conf /etc/nginx/nginx.conf

# Set ASAN options to output logs to a specific file
ENV ASAN_OPTIONS="detect_leaks=0,halt_on_error=0,log_path=/var/log/nginx/asan"

CMD ["nginx", "-g", "daemon off;"]
