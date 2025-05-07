
# ✅ Lab 4: Exposing MinIO with a Kubernetes Service

**🕒 Time:** 20 Minutes  

---

## 🧾 Lab Summary

This lab walks you through deploying MinIO using a ReplicaSet, exposing it with a Kubernetes Service
You will learn about Service types, how labels connect Services to Pods, and how scaling works in practice—essential skills for real-world Kubernetes deployment and service discovery.

---

## 🎯 Objectives 🧠🎓📌

By the end of this lab, you will be able to:

- 🌐 Understand how Kubernetes Services expose Pods to network traffic  
- 🧩 Deploy MinIO as a ReplicaSet with appropriate labels  
- ⚙️ Create and apply a NodePort Service that maps to Pods using selectors  
- 🔌 Use port-forwarding to access internal services externally  

---

## 📚 Service Concepts Recap 🧠🗺️

- Kubernetes Services expose a set of Pods as a network service  
- Services use **labels and selectors** to route traffic to the appropriate Pods  
- **Types of Services**:
  - 🔒 `ClusterIP`: Default, internal communication only  
  - 🌍 `NodePort`: Exposes the service on a static port on each node’s IP  
  - ☁️ `LoadBalancer`: Uses cloud provider’s external load balancer  

---

## 🛠️ Step-by-Step Instructions

## ☘️ Pre-requiste : Verify Cluster
1. Make sure your minikube/k3s cluster is running 

```bash
kubectl get nodes
```
You should see a node with the status `Ready`.

2. If above step failed, then start Minikube with 4 CPUs and 8GB of memory:

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" sh -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

### ☘️ Cleanup

```bash
kubectl delete --all replicaset
kubectl delete --all pod
```

### ☘️ Step 1: Create ReplicaSet

Open terminal and make sure you are in Lab4 folder

```bash
cd Lab4
```

Let's create Minio Replicaset with 3 replicas

```bash
kubectl apply -f minio_replicaset.yaml
```

---

### ☘️ Step 2: Check Pods and Labels

Verify the Pods and their labels:

```bash
kubectl get pods --show-labels
```

---

### ☘️ Step 3: Explore the MinIO Service YAML

In Lab4, you have been provided with a minio_service.yaml. Explore that file

- Services use **labels and selectors** to route traffic to the appropriate Pods  
Check how service is using selector label to match the pods labels and redirect traffic.

- **Remember**:
  - 🔒 `port`: Port at which service is listening  
  - 🌍 `targetPort`: Port at which container is listening, service will direct traffic to targetPort in container 
  - ☁️ `nodePort`: Its optional, but you can define it between 30000-32767, if you dont provide then kubernetes will provide port between this range (30000-32767)

- **Types of Services**:
  - 🔒 `ClusterIP`: Default, internal communication only  
  - 🌍 `NodePort`: Exposes the service on a static port on each node’s IP  
  - ☁️ `LoadBalancer`: Uses cloud provider’s external load balancer  


```yaml
apiVersion: v1
kind: Service
metadata:
  name: minio-service
spec:
  selector:
    app: minio
  ports:
  - name: minio-svc
    protocol: TCP
    port: 9000
    targetPort: 9000
  - name: minio-console
    protocol: TCP
    port: 9001
    targetPort: 9001
    nodePort: 30000
  type: NodePort
```

---

### ☘️ Step 4: Apply the Service YAML

```bash
kubectl apply -f minio_service.yaml
```

---

### ☘️ Step 5: Check Services

```bash
kubectl get services
```
Did you noticed service has been provided with external link? This is your loadbalancer url

---

### ☘️ Step 6: Access MinIO using Loadbalancer URL

Run below command in terminal to get your EC2 IP address

```bash
curl http://169.254.169.254/latest/meta-data/public-ipv4
```

- Open your browser
- Access Minio via [ec2-ip-address:30000]
- Login with the provided credentials

If you see blank screen, change your browser setting to allow javascript,images and popup for above url

🔐 **Credentials**:
- **Username**: `admin`
- **Password**: `password`



---

### ☘️ Step 8: Clean Up Resources

Delete the ReplicaSet and Service:

```bash
kubectl delete rs minio-replicaset
kubectl delete service minio-service
```

Verify cleanup:

```bash
kubectl get all
```

---

## ✅ Conclusion

In this lab, you:

- Deployed MinIO using a ReplicaSet  
- Exposed MinIO using a Kubernetes NodePort Service  
- Tested the setup using port forwarding  

---

🎉 **Congratulations**, you have successfully completed the lab!  
✨ **END OF LAB** ✨
