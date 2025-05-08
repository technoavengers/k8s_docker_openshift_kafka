
# ✅ Lab 8: Managing Configuration with ConfigMaps and Secrets in Kubernetes

**Time**: 20 mins

## Lab Summary
In this lab, participants will enhance the MinIO StatefulSet by incorporating Kubernetes ConfigMaps and Secrets to manage configuration and sensitive information. They will learn how to externalize MinIO configuration using ConfigMaps and securely manage access keys using Secrets. This approach ensures that configuration and sensitive data are separated from the application code, making it easier to manage and secure stateful applications in Kubernetes.

## 🎯 Objectives
- Create a ConfigMap for MinIO configuration.
- Apply the ConfigMap using kubectl.
- Verify the creation of the ConfigMap.
- Create a Secret for MinIO access keys.
- Apply the Secret using kubectl.
- Verify the creation of the Secret.
- Modify the MinIO StatefulSet to use ConfigMap and Secret.

> 📂 **Note**: YAML files for this lab are under `labs/Lab5`. Open terminal in VS Code and navigate to that folder first.

---

## ☘️ Pre-requiste : Verify Cluster
1. make sure your k3s cluster is running, if not run below to start k3s cluster

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" sh -
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/k3s.yaml
sudo chown $USER:$USER $HOME/k3s.yaml
export KUBECONFIG=$HOME/k3s.yaml
```

## ☘️ Cleanup 📦🧰🔍
```bash
kubectl delete --all deployment
kubectl delete --all replicaset
kubectl delete --all pod
kubectl delete svc minio-service
kubectl delete --all statefulsets
```

## 🛠️ Step 1: Create a ConfigMap for MinIO Configuration

**Purpose**: ConfigMaps allow you to decouple configuration artifacts from image content to keep containerized applications portable.

You have been provided with a `minio_configmap.yaml` in Lab8, Explore that file 

### YAML: `minio_configmap.yaml`
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: minio-config
data:
  MINIO_VOLUMES: "/data"
  MINIO_SERVER_URL: "http://minio:9000"
```

> ✅ This ConfigMap stores MinIO configuration variables such as the storage volume location and the server URL.


### Apply the ConfigMap:
```bash
kubectl apply -f minio_configmap.yaml
```

### Verify the ConfigMap:
```bash
kubectl get configmap minio-config
```
---

## 🔐 Step 2: Create a Secret for MinIO Access Keys

**Purpose**: Secrets in Kubernetes allow you to store and manage sensitive information such as passwords, OAuth tokens, and SSH keys securely.

You have been provided with a `minio_secret.yaml` in Lab8 folder, explore that file 

### YAML: `minio_secret.yaml`
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: minio-secret
type: Opaque
data:
  rootuser: bWluaW9hZG1pbg==        # Base64 for 'minioadmin'
  rootpassword: bWluaW9zZWNyZXQ=    # Base64 for 'miniosecret'
```

### Apply the Secret:
```bash
kubectl apply -f minio_secret.yaml
```

### Verify the Secret:
```bash
kubectl get secret minio-secret
```

> ✅ Verify that the Secret is created and contains the expected data.

---

## ✏️ Step 3: Modify the MinIO StatefulSet to Use ConfigMap and Secret

You have provided with a `minio_statefulset_with_config.yaml` which is using above configmap and statefulset. explore that file first. Focus on 

### YAML: `minio_statefulset_with_config.yaml`
```yaml
        envFrom:
        - configMapRef:
            name: minio-config
        - secretRef:
            name: minio-secret
```

### Apply the StatefulSet:
```bash
kubectl apply -f minio_statefulset_with_config.yaml
```

## 🔍 Step 4: Verify the Configuration

### Check Pods:
```bash
kubectl get pods -l app=minio
```


### Check Environment Variables set inside Pod:

When you run below command, it is going to show all environment variables that are set inside the pod

```bash
kubectl exec -it minio-statefulset-0 -- env
```

> Did you see below environment variables?:
- `MINIO_ROOT_USER` and `MINIO_ROOT_PASSWORD` (from Secret)
- `MINIO_VOLUMES` and `MINIO_SERVER_URL` (from ConfigMap)

---

## 🧹 Step 5: Clean Up Resources

```bash
kubectl delete statefulset minio-statefulset
kubectl delete configmap minio-config
kubectl delete secret minio-secret
```

---

**✅ END OF LAB**
