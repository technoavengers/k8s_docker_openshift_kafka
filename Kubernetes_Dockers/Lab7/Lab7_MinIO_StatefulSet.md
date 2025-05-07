
# ✅ Lab 7: Upgrading MinIO as a StatefulSet in Kubernetes

**Time**: 20 mins

## Lab Summary
In this lab, participants will deploy MinIO as a StatefulSet in Kubernetes, ensuring data persistence with Persistent Volumes. StatefulSets are ideal for stateful applications like MinIO, as they provide stable network identities, ordered deployment, and stable storage. This lab will guide participants through upgrading MinIO, explaining potential differences from deploying MinIO as a Deployment.

## 🎯 Objectives
- Deploy MinIO as a StatefulSet.
- Observe stable network identities.
- Understand ordered deployment and termination.
- Clean up resources.

---

## ☘️ Pre-requiste : Verify Cluster
1. Make sure your minikube cluster is running 

```bash
kubectl get nodes
```
You should see a node with the status `Ready`.

2. If above step failed, then start k3s:

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" sh -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```


## ☘️ Cleanup 📦🧰🔍
```bash
kubectl delete --all deployment
kubectl delete --all replicaset
kubectl delete --all pod
kubectl delete svc minio-service
```

## 🛠️ Step 1: Deploy MinIO as a StatefulSet

**Difference from Deployment**: StatefulSets ensure that each Pod has a unique, persistent identity and storage, even across rescheduling. Unlike Deployments, StatefulSets are used for applications requiring stable network identities and persistent storage.

### YAML File
Explore StatefulSet yaml file provided at Location: `Lab7/minio_statefulset.yaml`

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: minio-statefulset
spec:
  serviceName: "minio"
  replicas: 2
  selector:
    matchLabels:
      app: minio
  template:
    metadata:
      labels:
        app: minio
    spec:
      containers:
      - name: minio
        image: minio/minio:latest
        args:
        - server
        - /data
        - --console-address
        - ":9001"
        env:
        - name: MINIO_ACCESS_KEY
          value: "admin"
        - name: MINIO_SECRET_KEY
          value: "password"
        ports:
        - containerPort: 9000
          name: minio
        volumeMounts:
        - name: data
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
      storageClassName: standard
```

### Apply the StatefulSet configuration:
Make sure you are in Lab7


```bash
cd Kubernetes_Dockers/Lab7
```

Let's create the Statefulset

```bash
kubectl apply -f minio_statefulset.yaml
```

### Verify the StatefulSet:
```bash
kubectl get statefulset minio-statefulset
```

### Check the Pods:
```bash
kubectl get pods -l app=minio
```

> Note: Each Pod in the StatefulSet will have a stable identifier, such as
- `minio-statefulset-0`,
- `minio-statefulset-1`

---

## 🔍 Step 2: Observe Stable Network Identities

**Difference from Deployment**: In StatefulSets, each Pod gets a consistent DNS name based on its ordinal index, ensuring stable network identities.

### Check the Pod Host name:
```bash
kubectl get pod minio-statefulset-0 -o jsonpath='{.spec.hostname}'
```

### Check the Pod's IP address:
```bash
kubectl get pod minio-statefulset-0 -o jsonpath='{.status.podIP}'
```

The DNS name follows the pattern:
```
<pod_name>.<service_name>.<namespace>.svc.cluster.local
```

> Note: The stable network identity allows other applications to reliably connect to specific MinIO instances.

---

## 🔄 Step 3: Understand Ordered Deployment and Termination

**Difference from Deployment**: StatefulSets deploy and terminate Pods in an ordered fashion, ensuring that the next Pod only starts after the previous one is Running and Ready.

### Scale the StatefulSet to 5 replicas:
```bash
kubectl scale statefulset minio-statefulset --replicas=5
kubectl get pods -l app=minio --watch
```

> Watch how the Pods are created one by one. To come out of this watch mode, press “Ctrl+C”.

> Note: Pods will be created in order: 
- `minio-statefulset-0`, 
- `minio-statefulset-1`, ..., `minio-statefulset-4`

---

## 🧹 Step 5: Check PVC

```bash
kubectl get pvc
```
Did you noticed every pod has been attached to its own persistent volume and name of the persistent volume claim matches pod names

## 🧹 Step 5: Clean Up Resources

### Delete the StatefulSet and PVC:
```bash
kubectl delete statefulset minio-statefulset
kubectl delete pvc -l app=minio
```

---

**✅ END OF LAB**
