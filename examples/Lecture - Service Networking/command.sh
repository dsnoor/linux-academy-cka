#!/bin/bash

kubectl get pods -o wide
kubectl get deployments

# let's expose the pods to outside
kubectl expose deployment webhead --type="NodePort" --port 80
kubectl get services

