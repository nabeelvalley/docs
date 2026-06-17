---
published: true
title: Antlr in a Container
subtitle: How to configure ANTLR in a Devcontainer
---

To install ANTLR in a VSCode DevContainer you need to:

1. Select a container with Java
2. Download Antlr
3. Add the relevant aliases to the `bash.bashrc` file (even if you're using `zsh`)
4. Set the `CLASSPATH` in the environment

The following will handle `2`, `3`, and `4`:

```Dockerfile
WORKDIR /usr/local/lib
RUN wget https://www.antlr.org/download/antlr-4.9.2-complete.jar

RUN echo "alias antlr4='java -jar /usr/local/lib/antlr-4.9.2-complete.jar'" >> /etc/bash.bashrc
RUN echo "alias grun='java org.antlr.v4.gui.TestRig'" >> /etc/bash.bashrc

ENV CLASSPATH .:/usr/local/lib/antlr-4.9.2-complete.jar:$CLASSPATH
```

Integrating with the generated Java image from VSCode you will have the following full `Dockerfile`

`.devcontainer/Dockerfile`

```Dockerfile
# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.166.1/containers/java/.devcontainer/base.Dockerfile

# [Choice] Java version: 11, 15
ARG VARIANT="15"
FROM mcr.microsoft.com/vscode/devcontainers/java:0-${VARIANT}

# [Option] Install Maven
ARG INSTALL_MAVEN="false"
ARG MAVEN_VERSION=""
# [Option] Install Gradle
ARG INSTALL_GRADLE="false"
ARG GRADLE_VERSION=""
RUN if [ "${INSTALL_MAVEN}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/sdkman/bin/sdkman-init.sh && sdk install maven \"${MAVEN_VERSION}\""; fi \
    && if [ "${INSTALL_GRADLE}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/sdkman/bin/sdkman-init.sh && sdk install gradle \"${GRADLE_VERSION}\""; fi

# [Option] Install Node.js
ARG INSTALL_NODE="true"
ARG NODE_VERSION="lts/*"
RUN if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# Install ANTLR
WORKDIR /usr/local/lib
RUN wget https://www.antlr.org/download/antlr-4.9.2-complete.jar

RUN echo "alias antlr4='java -jar /usr/local/lib/antlr-4.9.2-complete.jar'" >> /etc/bash.bashrc
RUN echo "alias grun='java org.antlr.v4.gui.TestRig'" >> /etc/bash.bashrc

ENV CLASSPATH .:/usr/local/lib/antlr-4.9.2-complete.jar:$CLASSPATH

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
```
