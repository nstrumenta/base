# nstrumenta/base - Minimal CI/CD image
# Node.js 24.12.0 LTS + essential tools for building and testing
# Used by: CircleCI build/test jobs

FROM node:24.12.0-bookworm-slim

# Essential system packages in one layer
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    jq \
    zip \
    ca-certificates \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /usr/lib/python*/EXTERNALLY-MANAGED \
    && python3 -m pip install --upgrade setuptools

# Verify installations
RUN node --version && \
    npm --version && \
    git --version && \
    jq --version && \
    python3 --version

LABEL org.opencontainers.image.source="https://github.com/nstrumenta/base"
LABEL org.opencontainers.image.description="nstrumenta/base: Node.js 24.12.0 LTS with minimal build/test tools"
