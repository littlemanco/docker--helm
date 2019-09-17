FROM debian:stretch-slim

# Discovery labels
LABEL "maintainer" "support@littleman.co"
LABEL "source": "https://github.com/littlemanco/docker-helm"
LABEL "documentation": "https://github.com/littlemanco/docker-helm"

# Base image updates
RUN apt-get update && \
  apt-get dist-upgrade --yes

# Install packages required fur further install
RUN apt-get install --yes \
  apt-transport-https \
  curl \
  gpg \
  lsb-release

# Install kubectl
RUN apt-get update && \
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
  apt-get update && \
  apt-get install -y kubectl

# Install helm
RUN export TMPDIR=$(mktemp -d) && \
  cd ${TMPDIR} && \
  curl https://storage.googleapis.com/kubernetes-helm/helm-v2.14.3-linux-amd64.tar.gz > helm.tar.gz && \
  tar \
    --extract \
    --file helm.tar.gz && \
  mv linux-amd64/helm /usr/local/bin/helm && \
  cd / && \
  rm -rf ${TMPDIR}

# Install Google Cloud
#
# Allows deploying to GKE clusters
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
  echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
  apt-get update && \
  apt-get install --yes \
    google-cloud-sdk
