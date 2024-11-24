#!/bin/bash

echo -e "\e[1;34m
  █████████      ███████      █████████ 
  ██     ██    ███     ███   ███     ███
  ██          ███       ███  ███     ███
  █████████   ███       ███  ███████████
         ██   ███       ███  ███     ███
  ██     ██    ███     ███   ███     ███
  █████████      ███████    █████   █████
                
==============================================
    Node              : BlockMesh Network
    Telegram Channel  : @schoolofairdrop              
    Telegram Group    : @soadiscussion         
==============================================\e[0m"

# Install/Update BlockMesh Node
echo "Installing/Updating BlockMesh Node"

# Get the latest release URL for blockmesh-cli-x86_64-unknown-linux-gnu.tar.gz
LATEST_RELEASE=$(curl -s https://api.github.com/repos/block-mesh/block-mesh-monorepo/releases/latest | grep "browser_download_url" | grep "blockmesh-cli-x86_64-unknown-linux-gnu.tar.gz" | cut -d '"' -f 4)

# Check for tar command and install it if not found
if ! command -v tar &> /dev/null; then
    sudo apt install tar -y
fi
sleep 1

# Define the blockmesh directory
BLOCKMESH_DIR="$HOME/blockmesh"

# Check if blockmesh folder exists and remove it immediately
if [ -d "$BLOCKMESH_DIR" ]; then
    echo "Removing existing 'blockmesh' directory..."
    rm -rf "$BLOCKMESH_DIR"
fi

# Create the blockmesh directory
mkdir -p "$BLOCKMESH_DIR"

# Download the BlockMesh binary
echo "Downloading the latest BlockMesh binary..."
wget -O "$BLOCKMESH_DIR/blockmesh-cli-x86_64-unknown-linux-gnu.tar.gz" $LATEST_RELEASE

# Extract the archive into the blockmesh directory
echo "Extracting the BlockMesh binary..."
tar -xzvf "$BLOCKMESH_DIR/blockmesh-cli-x86_64-unknown-linux-gnu.tar.gz" -C "$BLOCKMESH_DIR"
sleep 1

# Remove the archive after extraction
rm "$BLOCKMESH_DIR/blockmesh-cli-x86_64-unknown-linux-gnu.tar.gz"

# Check the extracted directory structure
echo "Checking the extracted folder structure..."
ls -R "$BLOCKMESH_DIR"

# Set the path to the release folder based on the structure
# Assuming the structure is now "$HOME/blockmesh/target/x86_64-unknown-linux-gnu/release/"
RELEASE_DIR="$BLOCKMESH_DIR/target/x86_64-unknown-linux-gnu/release"

if [ ! -d "$RELEASE_DIR" ]; then
    echo "Error: release directory not found at $RELEASE_DIR"
    exit 1
fi

# Navigate to the blockmesh folder
cd "$RELEASE_DIR"

# Prompt user for input
echo "Enter your email:"
read USER_EMAIL

echo "Enter your password:"
read USER_PASSWORD

# Create or update the service file
sudo bash -c "cat <<EOT > /etc/systemd/system/blockmesh.service
[Unit]
Description=BlockMesh CLI Service
After=network.target

[Service]
User=$USER
ExecStart=$HOME/blockmesh/target/x86_64-unknown-linux-gnu/release/blockmesh-cli login --email $USER_EMAIL --password $USER_PASSWORD
WorkingDirectory=$HOME/blockmesh/target/x86_64-unknown-linux-gnu/release
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOT"

# Reload systemd services and enable BlockMesh service
sudo systemctl daemon-reload
sudo systemctl enable blockmesh
sudo systemctl start blockmesh

# Final output
echo "Installation/Update completed successfully"
