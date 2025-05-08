
# ✅ Lab 12: Understanding PodDisruptionBudgets (PDB) and Horizontal Pod Autoscaler (HPA) in Kubernetes

🕒 **Estimated Time**: 25–30 minutes

---

## 🎯 Objective
This lab introduces two important Kubernetes features for availability and scalability: **PodDisruptionBudgets (PDB)** and **Horizontal Pod Autoscaler (HPA)**. You will learn to set a disruption budget to maintain high availability and apply autoscaling to scale pods based on CPU utilization.

---


#  PART 1- PodDisruptionBudget (PDB)
PDB ensures that a minimum number of Pods remain available during voluntary disruptions like node drains or rolling updates.


## ☘️ Step 1: Create a Deployment

```bash
kubectl create deployment web --image=nginx --replicas=3
```

Expose the deployment:

```bash
kubectl expose deployment web --port=80 --target-port=80 --type=ClusterIP
```

---

## ☘️ Step 2: Create a PodDisruptionBudget

You have been provided with  file named `pdb.yaml` in Lab12 folder.

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: web-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: web
```
🔍 What This File Does
This PodDisruptionBudget (PDB) ensures that at least 2 pods with the label app: web are always available during any voluntary disruptions, such as:

- Node maintenance (kubectl drain)
- Rolling updates
- Cluster scaling

## ☘️ Step 2: Apply the PDB:

```bash
kubectl apply -f pdb.yaml
```

## ☘️ Step 3: Check PDB status:

```bash
kubectl get pdb
```

## ☘️ Step 4: Simulate a Node Drain to Test PDB:
In Kubernetes, draining a node simulates a voluntary disruption by cordoning the node (preventing new pods from being scheduled) and evicting all the pods on that node. PDB will prevent more pods than the minAvailable number from being evicted.
– Drain the Node

```bash
kubectl drain minikube --ignore-daemonsets --delete-emptydir-data
```

This command will attempt to evict pods on the node. If the PDB works as expected, it will block the eviction of more than one MinIO pod, ensuring two remain running

## ☘️ Step 5: Verify the Behavior

After running the drain command, check the status of the pods:

```bash
kubectl get pods -o wide
```

## ☘️ Step 6: Uncordon the Node
After testing the node drain and PDB behavior, you can uncordon the node to allow scheduling again:

```bash
kubectl uncordon minikube
```


# Part-2  Horizontal Pod Autoscaler (HPA)
HPA automatically adjusts the number of pod replicas based on observed CPU utilization or other metrics.

---

## ☘️ Step 1: Install Metrics Server (if not already)
The Metrics Server is a cluster-wide aggregator of resource usage data (like CPU and memory) in Kubernetes. It collects metrics from the Kubelets on each node and provides it through the Kubernetes API

```bash
minikube addons enable metrics-server
```

## ☘️ Step 2: Verify it's running:

```bash
kubectl get deployment metrics-server -n kube-system
kubectl top nodes
```

---

## ☘️ Step 3: Apply HPA to the Deployment

```bash
kubectl autoscale deployment web --cpu-percent=50 --min=2 --max=5
```

## ☘️ Step 4: Check HPA status:

```bash
kubectl get hpa
```

---

## ☘️ Step 5: Simulate High Load to Test HPA Scaling
To test the HPA, simulate CPU load on one of the MinIO pods. You can do this by running a CPU-intensive process inside a MinIO pod:
– Identify a running MinIO pod:

```bash
kubectl get pods -l app=minio
```

## ☘️ Step 6: Connect to Pod terminal

```bash
kubectl exec -it <minio-pod-name> -- /bin/sh
```


## ☘️ Step 7 : Run a CPU load inside the pod (e.g., an infinite loop):

```bash
while true; do :; done
```

This will artificially increase the CPU usage and trigger the HPA to scale up the number of pods.

## ☘️ Step 8 : Monitor the HPA
Open a new terminal and Run the following command to monitor the HPA and observe it scaling the MinIO pods:

```bash
kubectl get hpa -w
```


As the CPU usage increases, the HPA will increase the number of MinIO replicas up to the maximum (5 replicas, in this case). Once the CPU usage decreases, the HPA will scale down the pods.



## ✅ End of Lab

