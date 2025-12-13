# nstrumenta/developer - Full development environment
# Extends nstrumenta/base with development tools
# Used by: .devcontainer, local development

FROM nstrumenta/base:latest

# Beads - git-backed issue tracker for AI agents
RUN curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash

# Configure git to use beads merge driver globally
RUN git config --global merge.beads.driver "bd merge %O %A %B" && \
    git config --global merge.beads.name "Beads JSONL merge driver"

# Google Cloud SDK - for deployment and GCP integration
COPY --from=gcr.io/google.com/cloudsdktool/google-cloud-cli:latest /usr/lib/google-cloud-sdk /usr/lib/google-cloud-sdk
ENV PATH=/usr/lib/google-cloud-sdk/bin:$PATH

# Development tools: Chromium for Angular tests, Python packaging tools
RUN apt-get update && apt-get install -y \
    chromium \
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

# Environment for Chromium
ENV CHROME_BIN=/usr/bin/chromium

# Verify installations
RUN bd --version && \
    gcloud --version && \
    chromium --version && \
    twine --version && \
    mcap version && \
    gh --version

LABEL org.opencontainers.image.source="https://github.com/nstrumenta/base"
LABEL org.opencontainers.image.description="nstrumenta/developer: Full development environment with beads, chromium, python tools"
LABEL org.opencontainers.image.version="24.12.0"
