
# ✅ Lab 5: Working with Deployments

🕒 **Estimated Time:** 15–20 minutes

## 🎯 Objective
In this lab, you'll learn how to:
- Deploy an application using a Deployment in Kubernetes.
- Understand how ReplicaSets are managed.
- Update the deployment image.
- Check revision history.
- Roll back to a previous version.

---

## 🛠️ Step-by-Step Instructions

## ☘️ Pre-requiste : Verify Cluster
1. Make sure your minikube cluster is running 

```bash
kubectl get nodes
```
You should see a node with the status `Ready`.

2. If above step failed, then start Minikube with 4 CPUs and 8GB of memory:

```bash
minikube start --cpus=4 --memory=8192
```


## 🧹 Step 1: Clean Up the Cluster 🧽🗑️🧼
Ensure your cluster is clean before beginning:

```bash
kubectl delete --all pod
kubectl delete --all rs
kubectl delete --all deployment
kubectl delete svc minio-service
```

---

## 📦 Step 2:  Explore Deployment MinIO YAML 📝🚀📄
You have been provided with deployment file `minio_deployment.yaml` in Lab5 folder. Explore that file


## 📦 Step 3:  Create Deployment 📝🚀📄

Open Vscode terminal and go to Lab5

```bash
cd Lab5
```

Let's create Minio deployment from provided file

```bash
kubectl create -f minio_deployment.yaml
```

---

## 📦 Step 4: Check All Resources
```bash
kubectl get all
```

---

## 🔧 Step 5: Update the Deployment Image 🛠️🐳✏️

1. Modify the Deployment YAML for an upgrade:  
   Open `minio_deployment.yaml` and update the image field to:

   ```yaml
   image: minio/minio:RELEASE.2024-08-26T15-33-07Z
   ```

2. Apply the updated Deployment configuration:
  Again in terminal, apply the changes done to deployment file

   ```bash
   kubectl apply -f minio_deployment.yaml
   ```

3. Monitor the rolling update:
  Check the status of changes done
   ```bash
   kubectl rollout status deployment/minio-deployment
   ```

4. Verify the Pods are updated:
   Verify the timestamp of pod creation, it will ensure that pods are recreated with above image
   ```bash
   kubectl get pods -l app=minio
   ```

---

## 🕰️ Step 5: Review Deployment Revision History 📜🔍📘

Let's check revision history for all changes made

```bash
kubectl rollout history deployment minio-deployment
```
You should see 2 revision,
- Revision 1 - it is created when first time when it is deployed
- Revision 2 - it is created because we changed the image and apply the changes.

---

## ⏪ Step 6: Rollback to Revision 1 🔄🎯🔙

```bash
kubectl rollout undo deployment minio-deployment --to-revision=1
```

### ✅ Now verify the status:
```bash
kubectl get all
```
🧐 *Notice: Pods from the first ReplicaSet should be active again.*

---

## ❌ Step 7: Delete the Deployment 🧼🗑️📦

```bash
kubectl delete -f minio_deployment.yaml
```

---

## 🧾 Conclusion

In this lab, you:
- Created a deployment using a YAML definition.
- Observed how ReplicaSets and Pods are managed by the deployment.
- Performed an update and observed the rollout.
- Checked deployment revision history.
- Rolled back to a previous revision.

Understanding these concepts is vital for managing application lifecycle and version control in production-grade Kubernetes environments.

🎉 **Congratulations**, you have successfully completed the lab!  
✨ **END OF LAB** ✨
