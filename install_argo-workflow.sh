#!/bin/bash

cd ./argo-workflow
kubectl apply -f project.yaml -n argocd
kubectl apply -f application.yaml -n argocd