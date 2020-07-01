# blue
kubectl -n weblate set image deployment/weblate-blue weblate=weblate/weblate:4.1-2 
kubectl -n weblate scale deployment/weblate-blue --replicas=1 

# green
kubectl -n weblate set image deployment/weblate-green weblate=weblate/weblate:4.1.1-1 
kubectl -n weblate scale deployment/weblate-green --replicas=1

# main svc
kubectl -n weblate patch service weblate -p '{"spec":{"selector":{"app": "weblate-green"}}}'

# port-forward
kubectl -n weblate port-forward svc/weblate 8080:8080 