FROM debian:stable-slim

LABEL "name"="make"
LABEL "maintainer"="Simon Vadée <simon.vadee@gmail.com>"
LABEL "version"="0.0.1"

LABEL "com.github.actions.name"="Build docker images"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="gray-dark"

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    gnupg2 \
    apt-transport-https \
    ca-certificates \
    wget \
    software-properties-common \
    make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable" \
    && apt-get update \
    && apt-get install docker-ce docker-ce-cli containerd.io

ENTRYPOINT ["/bin/make"]