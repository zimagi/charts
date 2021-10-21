# Zimagi

Zimagi is a fast and powerful open source distributed data processing platform that empowers developers to implement powerful production-ready data pipelines with less code.

## TLDR
```bash
helm repo add zimagi https://zimagi.github.io/charts
helm install zimagi zimagi/zimagi
```

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
