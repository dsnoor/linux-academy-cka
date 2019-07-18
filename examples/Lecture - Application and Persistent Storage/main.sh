## On a new server (to be used as NFS server, other than your k8s servers)
sudo apt update
sudo apt install nfs-kernel-server

# make a directory to share with my pods
sudo mkdir -p /var/nfs/general
sudo chown nobody:nogroup /var/nfs/general

# edit exports file /etc/experts
# content as below
/var/nfs/general 172.31.28.152(rw,sync,no_subtree_check) xx.xxx.xxx.xx(rw,sync,no_subtree_check)

# restart the nfs server
sudo systemctl restart nfs-kernel-server

# on my three client nodes, install nfs-common
sudo apt install nfs-common

# create the pv, run on k8s master
kubectl create -f pv.yaml
kubectl get pv


## Now as the user, we want to Claim the pv admin created above
kubectl create -f pvc.yaml
kubectl get pvc

# then we create a pod that uses the pvc
kubectl create -f nfs-pod.yaml
kubectl get pod -o wide
kubectl exec -it nfs-pod -- sh # start a shell and check if the pv is there
# then check on other k8s client nodes' mount point to see if files changes are propogated through