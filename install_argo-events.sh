#!/bin/bash

cd ./argo-events
kubectl apply -f project.yaml -n argocd
kubectl apply -f application.yaml -n argocd