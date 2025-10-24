# renovate: datasource=docker depName=eclipse-temurin allowedVersions=<18
ARG JDK17_VERSION=17.0.16_8-jdk

FROM eclipse-temurin:$JDK17_VERSION as jdk17
FROM eclipse-temurin:21.0.8_9-jdk as jdk21
FROM ghcr.io/helmfile/helmfile:v1.1.7 as helmfile
FROM gitlab/glab:v1.74.0 as glab-cli
FROM jnorwood/helm-docs:v1.14.2 as helm-docs
FROM cloudtooling/dev-buildbox-base:0.1.4

ARG BUILD_DATE
ENV BUILD_DATE $BUILD_DATE

ENV PIP_BREAK_SYSTEM_PACKAGES 1
ENV JAVA_17_HOME /opt/java/openjdk17
ENV JAVA_21_HOME /opt/java/openjdk21

# renovate: datasource=maven depName=org.owasp:dependency-check-maven versioning=maven
ARG MAVEN_OWASP_DEPENDENCY_CHECK_PLUGIN_VERSION="8.3.1"

# renovate: datasource=github-tags depName=google/go-containerregistry extractVersion=^v(?<version>.*)$
ARG GCR_TOOLS_VERSION="0.20.6"

# renovate: datasource=github-tags depName=kubernetes/kubernetes extractVersion=^v(?<version>.*)$
ARG KUBECTL_VERSION="1.34.1"

# TODO: Use renovate to extract
ARG NODE_MAJOR_VERSION="20"

# renovate: datasource=github-tags depName=nvm-sh/nvm
ARG NVM_VERSION="0.40.3"

# update first
RUN apt-get update -y &&\
  # upgrade
  apt-get upgrade -y && \
  # clean up to slim image
  apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/


# Add JDK 17
RUN mkdir -p $JAVA_17_HOME
COPY --from=jdk17 /opt/java/openjdk $JAVA_17_HOME

# Add JDK 21
RUN mkdir -p $JAVA_21_HOME
COPY --from=jdk21 /opt/java/openjdk $JAVA_21_HOME

# Base tools
RUN apt-get update -y &&\
  apt-get install -y wget zip ruby-full git dos2unix curl maven && gem install bundler-audit &&\
  # Install Go Containerregistry Tool, e.g. cran
  curl -sL "https://github.com/google/go-containerregistry/releases/download/v${GCR_TOOLS_VERSION}/go-containerregistry_Linux_x86_64.tar.gz" > go-containerregistry.tar.gz &&\
  tar -zxvf go-containerregistry.tar.gz -C /usr/local/bin/ crane && chmod +x /usr/local/bin/crane && rm go-containerregistry.tar.gz &&\
  # kubectl
  curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && mv kubectl /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl &&\
  # helm
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash &&\
  helm plugin install https://github.com/databus23/helm-diff &&\
  helm plugin install https://github.com/jkroepke/helm-secrets &&\
  helm plugin install https://github.com/hypnoglow/helm-s3 &&\
  helm plugin install https://github.com/aslafy-z/helm-git &&\
  # Adding Maven
  apt install -y maven &&\
  # install ansible
  apt-get install -y ansible &&\
  python3 -m pip install molecule docker &&\
  # clean up to slim image
  apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Adding doc generation tools
COPY --from=helm-docs /usr/bin/helm-docs /usr/local/bin/helm-docs
RUN apt-get update -y &&\
  apt-get install -y pandoc &&\
  # clean up to slim image
  apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Add NodeJS
RUN mkdir -p /etc/apt/keyrings &&\
  # Download the new repository's GPG key and save it in the keyring directory
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg &&\
  # Add the new repository's source list with its GPG key for package verification
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR_VERSION}.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list &&\
  apt-get update && apt-get install -y nodejs && npm install -g yarn &&\
  # nx cli
  npm add --global nx@latest &&\
  # install changelog cli & json lint
  npm install -g conventional-changelog-cli jsonlint &&\
  # nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash  &&\
  . ~/.nvm/nvm.sh && nvm install v20 && \
  # clean up to slim image
  apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Add custom entrypoint
ADD --chown=root:root src/docker/entrypoint.sh /usr/local/bin/

# Copy Glab CLI
COPY --from=glab-cli /usr/bin/glab /usr/local/bin/glab
COPY --from=helmfile /usr/local/bin/helmfile /usr/local/bin/helmfile
