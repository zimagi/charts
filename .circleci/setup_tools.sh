#!/usr/bin/env bash

set -o errexit

readonly HELM_VERSION=3.6.0
readonly CHART_RELEASER_VERSION=0.2.1

echo "Installing Helm with version ${HELM_VERSION}"
curl -LO "https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
sudo mkdir -p "/usr/local/helm-v$HELM_VERSION"
sudo tar -xzf "helm-v$HELM_VERSION-linux-amd64.tar.gz" -C "/usr/local/helm-v$HELM_VERSION"
sudo ln -s "/usr/local/helm-v$HELM_VERSION/linux-amd64/helm" /usr/local/bin/helm
rm -f "helm-v$HELM_VERSION-linux-amd64.tar.gz"
helm version

echo "Installing chart-releaser with version ${CHART_RELEASER_VERSION}"
curl -LO "https://github.com/helm/chart-releaser/releases/download/v${CHART_RELEASER_VERSION}/chart-releaser_${CHART_RELEASER_VERSION}_Linux_x86_64.tar.gz"
sudo mkdir -p "/usr/local/chart-releaser-v$CHART_RELEASER_VERSION"
sudo tar -xzf "chart-releaser_${CHART_RELEASER_VERSION}_Linux_x86_64.tar.gz" -C "/usr/local/chart-releaser-v$CHART_RELEASER_VERSION"
sudo ln -s "/usr/local/chart-releaser-v$CHART_RELEASER_VERSION/chart-releaser" /usr/local/bin/chart-releaser
rm -f "chart-releaser_${CHART_RELEASER_VERSION}_Linux_x86_64.tar.gz"
chart-releaser version
