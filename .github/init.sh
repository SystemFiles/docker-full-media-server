#!/bin/bash
# Install docker and compose + create required directories

echo "Installing required docker and compose..."
apt-get update
apt-get install -y docker.io docker-compose curl
echo "Done!"

echo "Create the required directories for automated testing..."
mkdir -p /media/plex/tv
mkdir -p /media/plex/movies
mkdir -p /media/downloads
if [[ $? -eq 0 ]]; then
    echo "Directory creation completed successfully!"
    exit 0
else
    echo "Failed to create required directory structure..."
    exit 1
fi