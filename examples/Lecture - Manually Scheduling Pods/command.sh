# label a node then check
kubectl label node <master-node> net=gigabit 
kubectl describe node <master-node> 
kubectl create -f webhead.yml