#!/bin/bash

# see kube-dns running
kubectl get pods -n kube-system
kubectl exec -it busybox -- nslookup kubenetes

# when you expose a service, its name becomes dns and exposed in the cluster
kubectl expose deployment dns-target
kubectl exec -it busybox -- nslookup dns-target

# or you can logon to the pod instance and check /etc/resolv.conf
cat /etc/resolv.conf
# nameserver 10.96.0.10
# search default.svc.cluster.local svc.cluster.local cluster.local ap-southeast-2.compute.internal
# options ndots:5

# check if kube-dns is on master
kubectl get pods -n kube-system | grep dns

# check service endpoints
kubectl get endpoints <service-name>
