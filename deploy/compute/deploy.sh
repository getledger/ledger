
#!/bin/bash

# Variables
PROJECT_ID="your-gcp-project-id"
ZONE="us-central1-a"
INSTANCE_NAME="docker-compose-instance"
MACHINE_TYPE="e2-medium"
IMAGE_FAMILY="debian-11"
IMAGE_PROJECT="debian-cloud"
DOMAIN_NAME="yourdomain.com"
EMAIL="your-email@example.com" # For Let's Encrypt SSL

# Create a GCE instance
gcloud compute instances create $INSTANCE_NAME \
  --project=$PROJECT_ID \
  --zone=$ZONE \
  --machine-type=$MACHINE_TYPE \
  --image-family=$IMAGE_FAMILY \
  --image-project=$IMAGE_PROJECT \
  --tags=http-server,https-server

# Get the external IP of the instance
EXTERNAL_IP=$(gcloud compute instances describe $INSTANCE_NAME \
  --zone=$ZONE \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo "Instance created with IP: $EXTERNAL_IP"

# SSH into the instance and set up Docker and Docker Compose
gcloud compute ssh $INSTANCE_NAME --zone $ZONE --command "
  sudo apt-get update &&
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common &&
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - &&
  sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable' &&
  sudo apt-get update &&
  sudo apt-get install -y docker-ce &&
  sudo curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-\$(uname -s)-\$(uname -m)\" -o /usr/local/bin/docker-compose &&
  sudo chmod +x /usr/local/bin/docker-compose &&
  sudo usermod -aG docker \$USER
"

# Copy your docker-compose.prod.yml to the instance
gcloud compute scp docker-compose.prod.yml $INSTANCE_NAME:~/ --zone $ZONE

# SSH into the instance and deploy the application
gcloud compute ssh $INSTANCE_NAME --zone $ZONE --command "
  docker-compose -f ~/docker-compose.prod.yml up -d
"

# Set up a DNS A record pointing to the external IP
echo "Please update your DNS A record for $DOMAIN_NAME to point to $EXTERNAL_IP"

# Optionally, set up Let's Encrypt for SSL
gcloud compute ssh $INSTANCE_NAME --zone $ZONE --command "
  sudo apt-get install -y certbot &&
  sudo certbot certonly --standalone -d $DOMAIN_NAME --email $EMAIL --agree-tos --non-interactive &&
  sudo cp /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem /etc/ssl/certs/ &&
  sudo cp /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem /etc/ssl/private/
"

echo "Deployment complete. Access your app at http://$DOMAIN_NAME or https://$DOMAIN_NAME if SSL is configured."