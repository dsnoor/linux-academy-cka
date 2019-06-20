# filter pods with label
kubectl get pods -l app=nginx

# add label inline
kubectl label pod <pod-name> test=sure --overwrite
kubectl label pods -l app=nginx tier=frontend
kubectl delete pods -l test=sure