#!/bin/bash
# Define project names for each compose file
HOME_AUTOMATION_PROJECT="homeautomation"
MEDIA_STACK_PROJECT="mediastack"
SERVER_CORE_PROJECT="servercore"
GAMES_PROJECT="gameservers"
IMMICH_PROJECT="immich-stack"

# Define the path to the directory containing the Docker Compose files
COMPOSE_FILES_DIR="/home/simon/nixos/composeConfigs/"

# Function to check for cloudflared updates
check_cloudflared_update() {
    echo "Checking for cloudflared updates..."
    
    # Get current image ID
    local current_image_id=$(docker images --format "{{.ID}}" cloudflare/cloudflared:latest 2>/dev/null)
    
    # Pull latest image quietly to check for updates
    docker pull cloudflare/cloudflared:latest > /dev/null 2>&1
    
    # Get new image ID after pull
    local new_image_id=$(docker images --format "{{.ID}}" cloudflare/cloudflared:latest 2>/dev/null)
    
    if [[ "$current_image_id" != "$new_image_id" && -n "$new_image_id" ]]; then
        echo "🔄 New cloudflared update available!"
        echo "Current image ID: ${current_image_id:-"none"}"
        echo "Latest image ID:  $new_image_id"
        echo
        read -p "Would you like to update the cloudflared container? (y/N): " -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            update_cloudflared
            return 0
        else
            echo "Skipping cloudflared update."
            return 1
        fi
    else
        echo "✅ Cloudflared is up to date."
        return 1
    fi
}

# Function to update only cloudflared
update_cloudflared() {
    echo "🔄 Updating cloudflared container..."
    
    # Stop the current cloudflared container
    echo "Stopping cloudflared container..."
    docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" stop cloudflared
    
    # Remove the old container
    echo "Removing old cloudflared container..."
    docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" rm -f cloudflared
    
    # Start the new cloudflared container
    echo "Starting updated cloudflared container..."
    docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" up -d --no-deps cloudflared
    
    # Check if container is running
    if docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" ps cloudflared | grep -q "Up"; then
        echo "✅ Cloudflared container updated and running successfully!"
    else
        echo "❌ Warning: Cloudflared container may not be running properly. Check with 'docker ps'"
    fi
    
    echo
}

# Navigate to the directory containing the Docker Compose files
cd "$COMPOSE_FILES_DIR" || { echo "Directory $COMPOSE_FILES_DIR not found"; exit 1; }

# Check for cloudflared updates first
check_cloudflared_update

# Pull the latest images for each project (excluding cloudflared - handled separately)
echo "Pulling the latest images for all projects (excluding cloudflared)..."
docker-compose -f home-automation.yml -p "$HOME_AUTOMATION_PROJECT" pull
docker-compose -f media-stack.yml -p "$MEDIA_STACK_PROJECT" pull
# Pull server-core images but exclude cloudflared from the pull
docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" pull $(docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" config --services | grep -v cloudflared)
docker-compose -f game-servers.yml -p "$GAMES_PROJECT" pull
docker compose -f immich.yml -p "$IMMICH_PROJECT" pull

# Stop specific containers from the compose files (excluding cloudflared)
echo "Stopping containers defined in the compose files (excluding cloudflared)..."
docker-compose -f game-servers.yml -p "$GAMES_PROJECT" down
docker compose -f immich.yml -p "$IMMICH_PROJECT" down
docker-compose -f home-automation.yml -p "$HOME_AUTOMATION_PROJECT" down
docker-compose -f media-stack.yml -p "$MEDIA_STACK_PROJECT" down

# For server-core, we need to stop individual services except cloudflared
echo "Stopping server-core containers (excluding cloudflared)..."
docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" stop $(docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" config --services | grep -v cloudflared)
docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" rm -f $(docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" config --services | grep -v cloudflared)

# Recreate and start the containers in the specified order
echo "Starting server-core containers (excluding cloudflared)..."
docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" up -d --no-deps --remove-orphans  $(docker-compose -f server-core.yml -p "$SERVER_CORE_PROJECT" config --services | grep -v cloudflared)

echo "Recreating and starting containers from media-stack.yml..."
docker-compose -f media-stack.yml -p "$MEDIA_STACK_PROJECT" up -d --remove-orphans 

echo "Recreating and starting containers from home-automation.yml..."
docker-compose -f home-automation.yml -p "$HOME_AUTOMATION_PROJECT" up -d --remove-orphans 

echo "Recreating and starting containers from game-servers.yml..."
docker-compose -f game-servers.yml -p "$GAMES_PROJECT" up -d --remove-orphans 

echo "Recreating and starting containers from immich.yml..."
docker compose -f immich.yml -p "$IMMICH_PROJECT" up -d --remove-orphans 

# Remove unused images
echo "Removing unused images..."
docker image prune -f

echo "All containers have been recreated and started (cloudflared left running), and unused images have been removed."
