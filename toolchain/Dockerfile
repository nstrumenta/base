FROM node:24.1.0-bookworm-slim AS build-base
RUN echo "build-base"

# curl
RUN apt-get -y update; apt-get install curl wget -y
RUN apt-get install -y gnupg

# git
RUN apt-get install git -y

# uuid-runtime for uuidgen
RUN apt-get install uuid-runtime -y

#tmux
RUN  apt-get install -y tmux

# jq
RUN apt-get install jq -y

# fuse (for gcsfuse)
RUN apt-get install fuse -y

# zip
RUN apt-get install zip -y

# python
RUN apt-get install python3 python3-pip -y
RUN rm -f /usr/lib/python*/EXTERNALLY-MANAGED

#install gcsfuse
RUN GCSFUSE_REPO=gcsfuse-bookworm; \
    echo "deb https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN	apt-get -y update
RUN apt-get install gcsfuse -y

#github cli
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y

#install docker
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#go https://hub.docker.com/_/golang/tags
COPY --from=golang:1.24.4-bookworm /usr/local/go /usr/local/go
ENV GOPATH=/usr/local/go
ENV PATH=$GOPATH/bin:$PATH

#terraform https://hub.docker.com/r/hashicorp/terraform/tags
COPY --from=hashicorp/terraform:1.6 /bin/terraform /bin/terraform

COPY --from=gcr.io/google.com/cloudsdktool/google-cloud-cli:455.0.0-slim  /usr/lib/google-cloud-sdk /usr/lib/google-cloud-sdk
# Add gcloud to PATH
ENV PATH=/usr/lib/google-cloud-sdk/bin:$PATH


# mcap cli
RUN set -eux; \
    MCAP_VERSION=v0.0.50; \
    dpkgArch="$(dpkg --print-architecture)"; \
    url=; \
    case "${dpkgArch##*-}" in \
    'amd64') \
    url="https://github.com/foxglove/mcap/releases/download/releases%2Fmcap-cli%2F${MCAP_VERSION}/mcap-linux-amd64"\
    ;; \
    'arm64') \
    url="https://github.com/foxglove/mcap/releases/download/releases%2Fmcap-cli%2F${MCAP_VERSION}/mcap-linux-arm64"\
    ;; \
    *) echo >&2 "error: unsupported architecture '$dpkgArch' (likely packaging update needed)"; exit 1 ;; \
    esac; \
    wget "$url" -O /usr/local/bin/mcap
RUN chmod +x /usr/local/bin/mcap