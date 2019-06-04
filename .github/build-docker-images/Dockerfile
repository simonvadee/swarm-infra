FROM docker:stable

LABEL "name"="make"
LABEL "maintainer"="Simon Vadée <simon.vadee@gmail.com>"
LABEL "version"="0.0.1"

LABEL "com.github.actions.name"="Build docker images"
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="gray-dark"

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    ca-certificates \
    make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/make"]