#!/bin/bash

cd ./falco/deployment/
kubectl apply -f project.yaml -n argocd
kubectl apply -f application.yaml -n argocd
