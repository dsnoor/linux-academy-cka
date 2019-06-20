# Run a job
vim pi-job.yaml

```
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  template:
    spec:
      containers:
      - name: pi
        image: perl
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never
  backoffLimit: 4
```

kubectl create -f pi-job.yaml
kubectl describe job pi
kubectl describe pod $(kubectl get pods | grep pi | awk '{print $1}')
kubectl logs $(kubectl get pods | grep pi | awk '{print $1}')



