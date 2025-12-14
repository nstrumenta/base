# nstrumenta/developer - Full development environment
# Extends nstrumenta/base with development tools
# Used by: .devcontainer, local development, integration tests

FROM nstrumenta/base:latest

# Google Cloud SDK - for deployment and GCP integration
COPY --from=gcr.io/google.com/cloudsdktool/google-cloud-cli:latest /usr/lib/google-cloud-sdk /usr/lib/google-cloud-sdk
ENV PATH=/usr/lib/google-cloud-sdk/bin:$PATH

# Development tools: Chromium for Angular tests, tmux
RUN apt-get update && apt-get install -y \
    chromium \
    chromium-driver \
    tmux \
    && rm -rf /var/lib/apt/lists/*

# Python packaging tools for publishing
RUN python3 -m pip install --upgrade pip setuptools wheel twine

# MCAP CLI - useful for inspecting/converting MCAP files during development
RUN set -eux; \
    MCAP_VERSION=v0.0.50; \
    dpkgArch="$(dpkg --print-architecture)"; \
    url=; \
    case "${dpkgArch##*-}" in \
    'amd64') \
    url="https://github.com/foxglove/mcap/releases/download/releases%2Fmcap-cli%2F${MCAP_VERSION}/mcap-linux-amd64"; \
    ;; \
    'arm64') \
    url="https://github.com/foxglove/mcap/releases/download/releases%2Fmcap-cli%2F${MCAP_VERSION}/mcap-linux-arm64"; \
    ;; \
    *) echo >&2 "error: unsupported architecture '$dpkgArch'"; exit 1 ;; \
    esac; \
    wget "$url" -O /usr/local/bin/mcap && \
    chmod +x /usr/local/bin/mcap

# GitHub CLI - useful for development workflow
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install gh -y \
    && rm -rf /var/lib/apt/lists/*

# Docker CLI (uses host's docker daemon via socket mount)
RUN set -eux; \
    DOCKER_VERSION=29.1.3; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
    'amd64') \
    url="https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz"; \
    ;; \
    'arm64') \
    url="https://download.docker.com/linux/static/stable/aarch64/docker-${DOCKER_VERSION}.tgz"; \
    ;; \
    *) echo >&2 "error: unsupported architecture '$dpkgArch'"; exit 1 ;; \
    esac; \
    curl -fsSL "$url" | tar xz -C /tmp && \
    mv /tmp/docker/docker /usr/local/bin/docker && \
    rm -rf /tmp/docker

# Environment for Chromium
ENV CHROME_BIN=/usr/bin/chromium

# Verify installations
RUN gcloud --version && \
    chromium --version && \
    twine --version && \
    mcap version && \
    gh --version && \
    docker --version

LABEL org.opencontainers.image.source="https://github.com/nstrumenta/base"
LABEL org.opencontainers.image.description="nstrumenta/developer: Full development environment with gcloud, chromium, python tools"
LABEL org.opencontainers.image.version="24.12.0"
