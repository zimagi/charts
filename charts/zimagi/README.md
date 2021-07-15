# Zimagi

### Open Source Distributed Data Processing Platform

Zimagi is a fast and powerful open source distributed data processing platform that empowers developers to implement powerful production-ready data pipelines with less code.

## Getting started

### Cheat sheet
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

### Install dependencies
Zimagi has two dependencies a postgresql cluster and a redis stack.

### Deploy postgresql

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami

kubectl create namespace data

helm install data \
  --namespace data \
  --set postgresqlUsername=zimagi \
  --set postgresqlPassword=zimagi \
  --set postgresqlDatabase=zimagi \
  --set replication.enabled=true \
  --set replication.slaveReplicas=2 \
  --set replication.synchronousCommit="on" \
  --set replication.numSynchronousReplicas=1 \
  --set metrics.enabled=true \
  --set persistence.enabled=true \
  --set persistence.size=8Gi \
  bitnami/postgresql
```
The script above will deploy a high available persisted (8Gi) Postgresql cluster.

### Teardown postgresql cluster
To teardown the cluster run the next command:
```bash
helm del -n data data
```

### Deploy redis stack
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami

kubectl create namespace tasks

helm install tasks \
  --namespace tasks \
  --set password=zimagi \
  --set cluster.slaveCount=3 \
  --set metrics.enabled=true \
    bitnami/redis
```
The script above will deploy a high available persisted (8Gi) redis stack.

### Teardown redis stack
```bash
helm del -n tasks tasks
```

## Deploy Zimagi
```bash
kubectl create namespace zimagi
```

### Deploy command-api
```bash
helm install command-api \
  --namespace zimagi \
  --set entrypoint=zimagi-command \
  --set logLevel=warning \
  --set database.host=data-postgresql \
  --set database.port=5432 \
  --set database.user=zimagi \
  --set database.pass=zimagi \
  --set redis.host=tasks-redis-master.tasks \
  --set redis.port=6379 \
  --set redis.pass=zimagi \
  ./
```

### Teardwon command-api
```bash
helm del -n zimagi command-api
```

### Deploy data-api
```bash
helm install data-api \
  --namespace zimagi \
  --set entrypoint=zimagi-data \
  --set logLevel=warning \
  --set database.host=data-postgresql.data \
  --set database.port=5432 \
  --set database.user=zimagi \
  --set database.pass=zimagi \
  --set redis.host=tasks-redis-master.tasks \
  --set redis.port=6379 \
  --set redis.pass=zimagi \
  ./
```

### Teardwon data-api
```bash
helm del -n zimagi data-api
```

### Deploy scheduler
```bash
helm install scheduler \
  --namespace zimagi \
  --set entrypoint=zimagi-scheduler \
  --set logLevel=warning \
  --set database.host=data-postgresql.data \
  --set database.port=5432 \
  --set database.user=zimagi \
  --set database.pass=zimagi \
  --set redis.host=tasks-redis-master.tasks \
  --set redis.port=6379 \
  --set redis.pass=zimagi \
  ./
```

### Teardwon scheduler
```bash
helm del -n zimagi scheduler
```

### Deploy worker
```bash
helm install worker \
  --namespace zimagi \
  --set entrypoint=zimagi-worker \
  --set logLevel=warning \
  --set database.host=data-postgresql.data \
  --set database.port=5432 \
  --set database.user=zimagi \
  --set database.pass=zimagi \
  --set redis.host=tasks-redis-master.tasks \
  --set redis.port=6379 \
  --set redis.pass=zimagi \
  ./
```

### Teardwon worker
```bash
helm del -n zimagi scheduler
```