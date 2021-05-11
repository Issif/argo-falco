#!/bin/bash

echo " -- Install ArgoCD --"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo ""
echo " -- Install Argo Events --"
kubectl create namespace argo-events
kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml
kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install-validating-webhook.yaml
kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml
kubectl apply -f argo-events/deployment/project.yaml -n argocd
kubectl apply -f argo-events/deployment/application.yaml -n argocd
echo ""
echo "-- Install Argo Worklows --"
kubectl create namespace argo
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo-workflows/stable/manifests/install.yaml
kubectl patch -n argo cm workflow-controller-configmap -p '{"data": {"containerRuntimeExecutor": "pns"}}'
kubectl apply -f argo-workflow/deployment/project.yaml -n argocd
kubectl apply -f argo-workflow/deployment/application.yaml -n argocd
echo ""
echo "-- Install Falco --"
kubectl apply -f falco/deployment/project.yaml -n argocd
kubectl apply -f falco/deployment/application.yaml -n argocd
echo ""
echo "-- Wait until Pods are up & running --"
ARGOCD_SERVER=$(kubectl get pods -n argocd | grep argocd-server | cut -f1 -d" ")
ARGOWORKFLOW_SERVER=$(kubectl get pods -n argo | grep argo-server | cut -f1 -d" ")
kubectl -n argocd wait pod/${ARGOCD_SERVER} --for=condition=Ready --timeout=-1s
kubectl -n argo wait pod/${ARGOWORKFLOW_SERVER} --for=condition=Ready --timeout=-1s
echo ""
echo "-- Access to Argo CD and Argo Workflow UI --"
kubectl port-forward svc/argo-server -n argo 2746:2746 &
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
ARGO_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo -e "\033[0;31mLink for ArgoCD UI https://localhost:8080 (credentials are admin / ${ARGO_PASSWORD})\033[0m"
echo -e "\033[0;31mLink for Argo Workflow https://localhost:2746\033[0m"