#!/bin/bash

NAMESPACE=weblate
SERVICE_NAME=weblate

BLUE="blue"
GREEN="green"

CURRENT_VERSION=$(kubectl get service $SERVICE_NAME -o=jsonpath='{.spec.selector.version}' --namespace=${NAMESPACE}) 

OLD_VERSION=""

if [ "$CURRENT_VERSION" == "$BLUE" ]; then
    OLD_VERSION=$GREEN
else
    OLD_VERSION=$BLUE
fi

echo Old Version is $OLD_VERSION

kubectl -n $NAMESPACE scale deployment/$SERVICE_NAME-$OLD_VERSION --replicas=1

kubectl -n $NAMESPACE rollout status deployment/$SERVICE_NAME-$OLD_VERSION 

kubectl -n $NAMESPACE patch service $SERVICE_NAME -p '{"spec":{"selector":{"version": "'$OLD_VERSION'"}}}'

kubectl -n $NAMESPACE scale deployment/$SERVICE_NAME-$CURRENT_VERSION --replicas=0

