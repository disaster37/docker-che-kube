FROM registry.centos.org/che-stacks/centos-stack-base:latest
MAINTAINER Sebastien LANGOUREAUX (linuxworkgroup@hotmail.com)

# Set environment
ENV RANCHER_VERSION=v2.2.0 \
    HELM_VERSION=v2.13.1 \
    KUBECTL_VERSION=v1.14.1 \
    VAULT_VERSION=1.1.2\
    TERRAFORM_VERSION=0.11.13\
    TERRAGRUNT_VERSION=v0.18.5

USER root

# Add packages
RUN \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &&\
    yum install -y docker-ce-cli vim zip wget make &&\
    yum clean all
    

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

# Add vault cli
RUN \
    curl -fL https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o /tmp/vault.zip &&\
    unzip /tmp/vault.zip -d /tmp &&\
    mv /tmp/vault /usr/bin/

# Add terraform cli
RUN \
    curl -fL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip &&\
    unzip /tmp/terraform.zip -d /tmp &&\
    mv /tmp/terraform /usr/bin/

# Add terragrun cli
RUN \
    curl -fL https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o /usr/bin/terragrunt &&\
    chmod +x /usr/bin/terragrunt


# Clean image
RUN rm -rf /tmp/*

USER user

EXPOSE 8080
