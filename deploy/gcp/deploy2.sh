#!/bin/bash
# Key Enhancements
# Instance Template and Managed Instance Group: The script creates an instance template and a managed instance group for each client. This allows for easy scaling and management of instances.
# Autoscaling: Autoscaling is configured to adjust the number of instances based on CPU utilization. You can adjust the min-num-replicas and max-num-replicas to control the scaling range.
# Startup Script: The startup script installs Docker and Docker Compose and starts the application. Ensure the path to docker-compose.prod.yml is correct.
# Security and Cost Management: Firewall rules are set up to allow HTTP and HTTPS traffic. You can further enhance security and manage costs using Google Cloud's tools.
# This setup provides a scalable infrastructure that starts small and can grow based on demand. You may need to customize the script further to fit your specific application and infrastructure needs.

# Variables
PROJECT_ID="your-gcp-project-id"
ZONE="us-central1-a"
MACHINE_TYPE="e2-micro" # Start with the smallest instance type
IMAGE_FAMILY="debian-11"
IMAGE_PROJECT="debian-cloud"
BASE_DOMAIN="getledger.com"
EMAIL="your-email@example.com" # For Let's Encrypt SSL
DNS_PROVIDER_API_KEY="your-dns-provider-api-key" # Replace with your DNS provider's API key

# Function to create a new client instance
create_client_instance() {
  CLIENT_NAME=$1
  INSTANCE_TEMPLATE_NAME="${CLIENT_NAME}-template"
  INSTANCE_GROUP_NAME="${CLIENT_NAME}-group"
  DOMAIN_NAME="${CLIENT_NAME}.${BASE_DOMAIN}"

  # Create an instance template
  gcloud compute instance-templates create $INSTANCE_TEMPLATE_NAME \
    --project=$PROJECT_ID \
    --machine-type=$MACHINE_TYPE \
    --image-family=$IMAGE_FAMILY \
    --image-project=$IMAGE_PROJECT \
    --tags=http-server,https-server \
    --metadata=startup-script='#!/bin/bash
      sudo apt-get update &&
      sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common &&
      curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - &&
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" &&
      sudo apt-get update &&
      sudo apt-get install -y docker-ce &&
      sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
      sudo chmod +x /usr/local/bin/docker-compose &&
      sudo usermod -aG docker $USER &&
      docker-compose -f /path/to/docker-compose.prod.yml up -d'

  # Create a managed instance group
  gcloud compute instance-groups managed create $INSTANCE_GROUP_NAME \
    --project=$PROJECT_ID \
    --base-instance-name=$CLIENT_NAME \
    --template=$INSTANCE_TEMPLATE_NAME \
    --size=1 \
    --zone=$ZONE

  # Set up autoscaling
  gcloud compute instance-groups managed set-autoscaling $INSTANCE_GROUP_NAME \
    --project=$PROJECT_ID \
    --zone=$ZONE \
    --min-num-replicas=1 \
    --max-num-replicas=10 \
    --target-cpu-utilization=0.6

  # Automated DNS Management
  curl -X POST "https://api.cloudflare.com/client/v4/zones/YOUR_ZONE_ID/dns_records" \
    -H "Authorization: Bearer $DNS_PROVIDER_API_KEY" \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'"$DOMAIN_NAME"'","content":"'"$EXTERNAL_IP"'","ttl":120,"proxied":false}'

  echo "Deployment for $CLIENT_NAME complete. Access your app at http://$DOMAIN_NAME or https://$DOMAIN_NAME if SSL is configured."
}

# Example usage: create instances for multiple clients
create_client_instance "client1"
create_client_instance "client2"
create_client_instance "client3"

# Security: Set up firewall rules
gcloud compute firewall-rules create allow-http-https \
  --allow tcp:80,tcp:443 \
  --target-tags http-server,https-server \
  --description "Allow HTTP and HTTPS traffic"

# Cost Management: Use Google Cloud's billing and cost management tools
# gcloud alpha billing accounts list ...