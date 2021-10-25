# Charts for Kubernetes

Organisation Zimagi made Charts, ready to launch on [Kubernetes](https://kubernetes.io/) using [Helm](https://helm.sh/).

# TL;DR

```bash
$ helm repo add zimagi https//zimagi.github.io/charts
$ helm search repo zimagi
```

# Prerequisites
- Kubernetes 1.12+
- Helm 3.1.0

# Pre-commit framework

It is a multi-language package manager for pre-commit hooks. You specify a list of hooks you want and pre-commit manages the installation and execution of any hook written in any language before every commit. pre-commit is specifically designed to not require root access. If one of your developers doesn’t have node installed but modifies a JavaScript file, pre-commit automatically handles downloading and building node to run eslint without root.

```bash
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

