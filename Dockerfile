FROM alpine:3.9
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

# Set environment
ENV RANCHER_VERSION=v2.2.0 \
    HELM_VERSION=v2.13.1 \
    KUBECTL_VERSION=v1.14.1 \
    GID=1001 \
    UID=1001 \
    GROUP=dev \
    USER=dev \
    APP_HOME=/home/dev

# Add packages
RUN \
    apk --update add bash curl docker-bash-completion docker git vim sudo openssh-client zip wget make &&\
    rm -rf /var/cache/apk/*

# Add rancher cli
RUN \
    curl -fL https://github.com/rancher/cli/releases/download/${RANCHER_VERSION}/rancher-linux-amd64-${RANCHER_VERSION}.tar.gz -o /tmp/rancher.tar.gz &&\
    tar -xvzf /tmp/rancher.tar.gz -C /tmp &&\
    mv /tmp/rancher-*/rancher /usr/bin/

# Add helm cli
RUN \
    curl -fL https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -o /tmp/helm.tar.gz &&\
    tar -xvzf /tmp/helm.tar.gz -C /tmp &&\
    mv /tmp/linux-amd64/helm /usr/bin/

# Add kube cli
RUN \
    curl -fL https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -o /usr/bin/kubectl &&\
    chmod +x /usr/bin/kubectl

# Add dev account
RUN \
    addgroup -g ${GID} ${GROUP} && \
    adduser -g "${USER} user" -D -h ${APP_HOME} -G ${GROUP} -s /bin/bash -u ${UID} ${USER} &&\
    echo "%dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/dev

# Clean image
RUN \
    rm -rf /var/cache/apk/* &&\
    rm -rf /tmp/*


VOLUME ["${APP_HOME}"]
CMD  ["bash"]
