kubectl create -f mongo-pvc.yaml
kubectl create -f app-configmap.yaml
kubectl create -f mongodb-deployment.yaml
kubectl create -f mongodb-service.yaml
sleep 15
kubectl create -f nodejs-app-deployment.yaml
kubectl create -f node-service.yaml