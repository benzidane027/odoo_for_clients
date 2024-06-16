#!/bin/bash

# Configuration
CONTAINER_NAME="container_odoo"
DB_NAME="Real"
DB_USER="odoo"
DB_PASSWORD="odoo"
BACKUP_DIR="/home/solvex/service.backup"

BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$(date +%Y%m%d%H%M%S).sql"
PROXMOX_REPO="10.0.0.12"
PROXMOX_USER="root@pam"
PROXMOX_PASSWORD="valkiry"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Dump the PostgreSQL database from the Docker container
echo "Dumping PostgreSQL database from Docker container..."
docker exec -e PGPASSWORD="$DB_PASSWORD" "$CONTAINER_NAME" pg_dump -U "$DB_USER" -d "$DB_NAME" > "$BACKUP_FILE"

if [ $? -ne 0 ]; then
  echo "Database dump failed!"
  exit 1
else
  echo "Database dump completed: $BACKUP_FILE"
fi

# Login to Proxmox Backup Server
echo "Logging in to Proxmox Backup Server..."
echo "$PROXMOX_PASSWORD" | proxmox-backup-client login --repository "$PROXMOX_REPO" --username "$PROXMOX_USER"

if [ $? -ne 0 ]; then
  echo "Proxmox login failed!"
  exit 1
else
  echo "Proxmox login successful."
fi

# Upload the backup file
echo "Uploading backup file to Proxmox Backup Server..."
proxmox-backup-client upload "$BACKUP_FILE" --repository "$PROXMOX_REPO"

if [ $? -ne 0 ]; then
  echo "File upload failed!"
  exit 1
else
  echo "File upload successful."
fi

echo "Backup process completed successfully."

# Logout from Proxmox Backup Server
echo "Logging out from Proxmox Backup Server..."
proxmox-backup-client logout --repository "$PROXMOX_REPO"

if [ $? -ne 0 ]; then
  echo "Proxmox logout failed!"
  exit 1
else
  echo "Proxmox logout successful."
fi

exit 0