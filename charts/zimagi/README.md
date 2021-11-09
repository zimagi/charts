# Zimagi

Zimagi is a fast and powerful open source distributed data processing platform that empowers developers to implement powerful production-ready data pipelines with less code.

## TLDR
```bash
helm install zimagi zimagi/zimagi
```

## Introduction
This chart bootstraps an [Zimagi](https://github.com/zimagi/zimagi) deployment on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
$ helm repo add zimagi https://charts.zimagi.com
$ helm install my-release zimagi/zimagi
```

These commands deploy Zimgi on the Kubernetes cluster in the default configuration. The [Parameters](./values.yaml) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release
```

## Parameters

Under dev.

## Configuration

### Configure Ingress

This chart provides support for Ingress resources. If you have an ingress controller installed on your cluster you can utilize the ingress controller to serve your application.

To enable Ingress integration, set `ingress.enabled` to `true`. The `ingress.hostname` property can be used to set the host name. The `ingress.tls` parameter can be used to add the TLS configuration for this host. It is also possible to have more than one host, with a separate TLS configuration for each host

### Configure extra environment variables

To add extra environment variables (useful for advanced operations like custom init scripts), use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: ZIMAGI_LOG_LEVEL
    value: DEBUG
```

Alternatively, use a ConfigMap or a Secret with the environment variables. To do so, use the extraEnvVarsCM or the extraEnvVarsSecret values.

### Configure image and Init Containers

YOu can overwrite the current image of the database checker init container/
.

### Set Pod affinity

This chart allows you to set custom Pod affinity using the XXX.affinity parameter(s). Find more information about Pod affinity in the Kubernetes documentation.

As an alternative, you can use the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the bitnami/common chart. To do so, set the XXX.podAffinityPreset, XXX.podAntiAffinityPreset, or XXX.nodeAffinityPreset parameters.


### Persistence

You can define extra volumes with parameter `extraVolumes` and the specific mount path with parameter `extraMountPath`

## Kubernetes cheat sheet
```bash
# Get pods in a specific namespace
kubectl --namespace <namespace> get pods
# Watch the status of the namespace, exit: Ctr + c
kubectl --namespace <namespace> get pods --watch
# Get the description of a specific pod from a specific namespace
kubectl --namespace <namespace> describe <pod_name>
# Get the logs of a specific pod fro ma specific namespace, exit: Ctr + c
kubectl --namespace <namespace> logs --tail <pod_name>
# Get the service endpoints of application for a specific namespace
kubectl --namespace <namespace> get services
# Port forward service to the localhost
kubectl --namespace <namespace> svc/<service_name> <host_port>:80
```
