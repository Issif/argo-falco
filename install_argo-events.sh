#!/bin/bash

kubectl create namespace argo-events
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install-validating-webhook.yaml

cd ./argo-events
kubectl apply -f project.yaml -n argocd
kubectl apply -f application.yaml -n argocd