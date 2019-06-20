kubectl describe node <master-node-name> | grep Taints
# Taints:             node-role.kubernetes.io/master:NoSchedule

## Taint is set on Node
# add a taint to a node
kubectl taint nodes node1 teir=frontend:NoSchedule
# remove a taint from a node
kubectl taint nodes node1 teir:NoSchedule-

## Toleration is set on PodSpec
tolerations:
- key: "key"
  operator: "Equal"
  value: "value"
  effect: "NoSchedule"

tolerations:
- key: "key"
  operator: "Exists"
  effect: "NoSchedule"
  
# A toleration "matches" a taint if the keys are the same and the effects are the same, and
#   - the `operator` is `Exsits` (in which case no `value` should be specified), or
#   - the `operator` is `Equal` and the `value` are equal
# `Operator` defaults to `Equal` if not specified
