
# ✅ Lab 3: Kubernetes Fundamentals with Pods, ReplicaSets

**Time:** 25 Minutes  

---

## 🧾 Lab Summary

In this lab, you will deploy MinIO—a high-performance object storage solution—as a containerized application on Kubernetes. This lab introduces core Kubernetes concepts like **Pods**, **ReplicaSets**, and **Services** while guiding you through a hands-on deployment of MinIO.

---

## 🎯 Objectives

- 🚀 Deploy MinIO as a Pod  
- 🔄 Ensure Availability with a ReplicaSet  
- 🌐 Expose MinIO Using a Service  
- ✅ Test and Verify the Deployment  

---

## ☘️ Step 1: Starting a Minikube Cluster

Start k3s Cluster

```bash
minikube start
alias kubectl='kubectl'
```

Verify the cluster is running:

```bash
kubectl get nodes
```

You should see a node with the status `Ready`.

---

## 🧩 PART 1: Deploy MinIO as a Pod

### ☘️ Step 1: Explore Pod YAML File

In Lab3 folder, you have been provided with minio_pod.yaml file. Explore that file

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: minio
  labels:
    app: minio
spec:
  containers:
  - name: minio
    image: minio/minio
    args:
    - server
    - /data
    env:
    - name: MINIO_ROOT_USER
      value: "admin"
    - name: MINIO_ROOT_PASSWORD
      value: "password"
    ports:
    - containerPort: 9000
    - containerPort: 9001
```

### ☘️ Step 2: Deploy the Pod

Open Vscode terminal and Make sure you're in the `Lab3` folder:

```bash
cd Lab3
```
Let's deploy the minio pod on minikube 

```bash
kubectl apply -f minio_pod.yaml
```

### ☘️ Step 3: Verify the Pod

Let's check the status of Pod now

```bash
kubectl get pods
```

### ☘️ Step 4: Describe the Pod

To see more detailed information about pod, describe the pod.
Make sure to replace pod_name with your pod name.

```bash
kubectl describe pod pod_name
```

### ☘️ Step 5: View Pod Logs

Make sure to replace pod_name with your pod name.

```bash
kubectl logs pod_name
```

### ☘️ Step 6: Connect to Pod

Make sure to replace pod_name with your pod name.

```bash
kubectl exec -it pod_name -- /bin/bash
```

To exit the shell:

```bash
exit
```

### ☘️ Step 7: Delete the Pod

Make sure to replace pod_name with your pod name.

```bash
kubectl delete pod pod-name
```

---

## 🧩 PART 2: Deploy MinIO with ReplicaSet

### ☘️ Step 1: Explore ReplicaSet YAML File

In Lab3 folder, you are also provided with minio_replicaset.yaml. Explore the file first

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: minio-replicaset
  labels:
    app: minio
spec:
  replicas: 3
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
        image: minio/minio
        args:
        - server
        - /data
        env:
        - name: MINIO_ROOT_USER
          value: "admin"
        - name: MINIO_ROOT_PASSWORD
          value: "password"
        ports:
        - containerPort: 9000
        - containerPort: 9001
```

### ☘️ Step 2: Deploy the ReplicaSet

In terminal, make sure you are in Lab3 folder
Let's deploy the replicaset.

```bash
kubectl apply -f minio_replicaset.yaml
```

### ☘️ Step 3: Verify the ReplicaSet

```bash
kubectl get replicaset
kubectl get pods
```

You should see 3 pods running.

### ☘️ Step 4: Delete a Pod 

Let's try deleting a pod/replica. 
Make sure to replace pod_name with name of one of your pod

```bash
kubectl delete pod pod-name
```

Check if Kubernetes recreates it:

```bash
kubectl get pods
```
Did noticed that Kuberneted has automatically recreated a pod for us?

### ☘️ Step 5: Scale the ReplicaSet Up
Let's scale up the pod from 3 to 5

```bash
kubectl scale replicaset minio-replicaset --replicas=5
```

### ☘️ Step 6: Verify Pods

```bash
kubectl get pods
```
How many pods do you see now?

### ☘️ Step 7: Scale the ReplicaSet Down

Let's scale down replicas/pods from 5 to 2

```bash
kubectl scale replicaset minio-replicaset --replicas=2
```

### ☘️ Step 8: Verify Pods After Scale Down

```bash
kubectl get pods
```

Did you noticed that some pods are getting terminated, at the end only 2 pods will stay running

### ☘️ Step 9: Delete the ReplicaSet

```bash
kubectl delete rs minio-replicaset
```

---

## ✅ Conclusion

In this lab, you:

- Deployed MinIO as a Pod
- Used a ReplicaSet to ensure availability and scaling
- Interacted with and managed Kubernetes objects
- Understood the core concepts of Pods and ReplicaSets

---

🎉 **Congratulations**, you have successfully completed the lab!  
✨ **END OF LAB** ✨
