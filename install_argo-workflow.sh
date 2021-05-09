#!/bin/bash

kubectl create ns argo-workflow
kubectl apply -n argo-workflow -f https://raw.githubusercontent.com/argoproj/argo-workflows/stable/manifests/namespace-install.yaml 

cd ./argo-workflow/deployment/
kubectl apply -f project.yaml -n argocd
kubectl apply -f application.yaml -n argocd