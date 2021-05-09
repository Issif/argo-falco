#!/bin/bash

kubectl apply -n argo-workflow -f https://raw.githubusercontent.com/argoproj/argo-workflows/stable/manifests/namespace-install.yaml 

cd ./argo-workflow
kubectl apply -f project.yaml -n argocd
kubectl apply -f application.yaml -n argocd