#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

readonly CT_VERSION=v3.4.0
readonly KIND_VERSION=0.11.1
readonly CLUSTER_NAME=chart-testing
readonly K8S_VERSION=v1.19.0

run_ct_container() {
    echo 'Running ct container...'
    docker run --rm --interactive --detach --network host --name ct \
        --volume "$(pwd)/.circleci/ct.yaml:/etc/ct/ct.yaml" \
        --volume "$(pwd):/workdir" \
        --workdir /workdir \
        "quay.io/helmpack/chart-testing:${CT_VERSION}" \
        cat
    echo
}

cleanup() {
    echo 'Removing ct container...'
    docker kill ct > /dev/null 2>&1

    echo 'Done!'
}

docker_exec() {
    docker exec --interactive ct "$@"
}

install_kind() {
    if command -v kind; then {
        echo "Kind is already installed"
        kind version
    } else {
        echo "Installing kind with version ${KIND_VERSION}"
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-amd64
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/kind
        kind version
    }
    fi
}

create_kind_cluster() {
    install_kind

    kind create cluster \
      --name "${CLUSTER_NAME}" \
      --config .circleci/kind-config.yaml \
      --image "kindest/node:${K8S_VERSION}" \
      --wait 60s


    echo 'Copying kubeconfig to container...'
    docker_exec mkdir -p /root/.kube
    local kubeconfig
    kubeconfig="$(kind get kubeconfig --name "${CLUSTER_NAME}")"
    echo "${kubeconfig}" > .kubeconfig
    docker cp .kubeconfig ct:/root/.kube/config

    docker_exec kubectl cluster-info
    echo

    docker_exec kubectl get nodes
    echo
}

install_local_path_provisioner() {
    docker_exec kubectl delete storageclass standard
    docker_exec kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
}

install_charts() {
    docker_exec ct install
    echo
}

main() {
    run_ct_container
    trap cleanup EXIT

    changed=$(docker_exec ct list-changed)
    if [[ -z "${changed}" ]]; then
        echo 'No chart changes detected.'
        return
    fi

    echo 'Chart changes detected.'
    create_kind_cluster
    install_local_path_provisioner
    install_charts
}

main
