#!/bin/bash

# Variables
PROJECT_ID="your-gcp-project-id"
ZONE="us-central1-a"
CLUSTER_NAME="ledger-cluster"
BASE_DOMAIN="getledger.com"
EMAIL="your-email@example.com" # For Let's Encrypt SSL
DNS_PROVIDER_API_KEY="your-dns-provider-api-key" # Replace with your DNS provider's API key

# Enable necessary GCP services
gcloud services enable container.googleapis.com

# Create a GKE cluster
gcloud container clusters create $CLUSTER_NAME \
  --project=$PROJECT_ID \
  --zone=$ZONE \
  --machine-type=e2-medium \
  --num-nodes=3 \
  --enable-autoscaling --min-nodes=1 --max-nodes=10 \
  --preemptible

# Get credentials for kubectl
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID

# Create a namespace for the application
kubectl create namespace ledger

# Deploy Persistent Volumes and Claims
kubectl apply -f pv-pvc.yaml -n ledger

# Deploy the application using Kubernetes manifests
kubectl apply -f k8s-deployment.yaml -n ledger

# Set up an Ingress controller for DNS and SSL
kubectl apply -f ingress.yaml -n ledger

# Automated DNS Management (example using Cloudflare API)
curl -X POST "https://api.cloudflare.com/client/v4/zones/YOUR_ZONE_ID/dns_records" \
  -H "Authorization: Bearer $DNS_PROVIDER_API_KEY" \
  -H "Content-Type: application/json" \
  --data '{"type":"A","name":"'"$BASE_DOMAIN"'","content":"'"$(kubectl get ingress ledger-ingress -n ledger -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"'", "ttl":120,"proxied":false}'

echo "Deployment complete. Access your app at http://$BASE_DOMAIN or https://$BASE_DOMAIN if SSL is configured."

# Cost Management: Use Google Cloud's billing and cost management tools
# gcloud alpha billing accounts list ...