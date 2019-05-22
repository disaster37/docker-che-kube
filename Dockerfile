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
    yum install -y docker-ce-cli vim make &&\
    yum clean all
    

USER user

EXPOSE 8080
