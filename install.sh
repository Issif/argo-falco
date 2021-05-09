#!/bin/bash

echo " -- Install ArgoCD --"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo " -- Install Argo Events --"
kubectl create namespace argo
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install-validating-webhook.yaml
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml
kubectl apply -f argo-events/deployment/project.yaml -n argocd
kubectl apply -f argo-events/deployment/application.yaml -n argocd

echo "-- Install Argo Worklows --"
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo-workflows/stable/manifests/namespace-install.yaml 
kubectl apply -f argo-workflow/deployment/project.yaml -n argocd
kubectl apply -f argo-workflow/deployment/application.yaml -n argocd

echo "-- Install Falco --"
kubectl apply -f falco/deployment/project.yaml -n argocd
kubectl apply -f falco/deployment/application.yaml -n argocd

echo "-- Access to ArgoCD UI --"
ARGO_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Credentials for ArgoCD UI are admin / ${ARGO_PASSWORD}"
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

echo "-- Access to Argo Workflow UI --"
kubectl port-forward svc/argo-server -n argo 2746:2746 &