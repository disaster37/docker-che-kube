FROM alpine:3.9
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

ARG http_proxy
ARG https_proxy

# Set environment
ENV RANCHER_VERSION=v2.3.2 \
    HELM_VERSION=v2.13.1 \
    KUBECTL_VERSION=v1.15.5

# Add required for CHE
ADD https://raw.githubusercontent.com/disaster37/che-scripts/master/alpine.sh /tmp/alpine.sh
RUN sh /tmp/alpine.sh

# Add packages
RUN \
    apk --update add docker-bash-completion docker openssh-client &&\
    rm -rf /var/cache/apk/*
   
# Add docker-compose
RUN \
    apk --update add py-pip python-dev libffi-dev openssl-dev gcc libc-dev make &&\
    pip install docker-compose

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


# Clean image
RUN \
    rm -rf /var/cache/apk/* &&\
    rm -rf /tmp/*
    
USER dev
WORKDIR "/projects"
VOLUME "/home/dev"

CMD ["tail", "-f", "/dev/null"]
