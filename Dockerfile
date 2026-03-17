FROM node:22-bookworm-slim

ARG OPENSHELL_VERSION=latest
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    docker.io \
    iproute2 \
    jq \
    procps \
    python3 \
    python3-pip \
    tini \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
      amd64) openshell_asset="openshell-x86_64-unknown-linux-musl.tar.gz" ;; \
      arm64) openshell_asset="openshell-aarch64-unknown-linux-musl.tar.gz" ;; \
      *) echo "Unsupported architecture: $arch"; exit 1 ;; \
    esac; \
    if [ "$OPENSHELL_VERSION" = "latest" ]; then \
      openshell_url="https://github.com/NVIDIA/OpenShell/releases/latest/download/${openshell_asset}"; \
    else \
      openshell_url="https://github.com/NVIDIA/OpenShell/releases/download/${OPENSHELL_VERSION}/${openshell_asset}"; \
    fi; \
    curl -fsSL "$openshell_url" -o /tmp/openshell.tgz; \
    tar -xzf /tmp/openshell.tgz -C /tmp; \
    install -m 0755 /tmp/openshell /usr/local/bin/openshell; \
    rm -f /tmp/openshell /tmp/openshell.tgz

RUN npm install -g nemoclaw

WORKDIR /workspace

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["bash"]
