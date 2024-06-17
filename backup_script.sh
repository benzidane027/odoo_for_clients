#!/bin/bash

# Configuration
CONTAINER_NAME="container_database"
DB_NAME="REAL"
DB_USER="odoo"
DB_PASSWORD="odoo"

BACKUP_NEW_DIR="/home/solvex/service.backup/backup_$(date +%d_%m_%Y)"
BACKUP_OLD_DIR="/home/solvex/service.backup/backup_old"
FILESRORE_PATH="/home/solvex/service.odoo/filestore/filestore"
EXTRA_ADDONS_PATH="/home/solvex/service.odoo/extra-addons"

DATE="$(date +%S_%M_%H_%d_%m_%Y)"
DATABASE_BACKUP_FILE="$BACKUP_NEW_DIR/database_${DB_NAME}_${DATE}.sql.gz"
FILESTORE_BACKUP_FILE="$BACKUP_NEW_DIR/filestore_${DB_NAME}_${DATE}.zip"
EXTRA_ADDONS_BACKUP_FILE="$BACKUP_NEW_DIR/extra_addons_${DB_NAME}_${DATE}.zip"

PROXMOX_REPO="root@pam@10.0.0.12:8007:backup-container"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_NEW_DIR"
mkdir -p "$BACKUP_OLD_DIR"

# Dump the PostgreSQL database from the Docker container
echo "Dumping PostgreSQL database from Docker container..."
docker  exec -t "$CONTAINER_NAME" pg_dump  -U "$DB_USER" -d "$DB_NAME" | bzip2 --best > "$DATABASE_BACKUP_FILE"
if [ $? -ne 0 ]; then
  echo "database failed! to dumped"
else
  echo "database dumped successful."
fi

echo "valkiry0024"| sudo -S zip -r  "$FILESTORE_BACKUP_FILE" "$FILESRORE_PATH/$DB_NAME"

if [ $? -ne 0 ]; then
  echo "filestore failed! to dumped"
else
  echo "filestore dumped successful."
fi

echo "valkiry0024"| sudo -S zip -r  "$EXTRA_ADDONS_BACKUP_FILE" "$EXTRA_ADDONS_PATH" 

if [ $? -ne 0 ]; then
  echo "extra-addons failed! to dumped"

else
  echo "extra-addons dumped successful."
fi


# Login to Proxmox Backup Server
echo "Logging in to Proxmox Backup Server..."
proxmox-backup-client login --repository "$PROXMOX_REPO"

if [ $? -ne 0 ]; then
  echo "Proxmox login failed!"
else
  echo "Proxmox login successful."
fi

#Upload the backup file
echo "Uploading backup file to Proxmox Backup Server..."
proxmox-backup-client backup root.pxar:"$BACKUP_NEW_DIR" --repository "$PROXMOX_REPO"

if [ $? -ne 0 ]; then
  echo "Files upload failed!"
else
  echo "Files upload successful."
fi

# Logout from Proxmox Backup Server
echo "Logging out from Proxmox Backup Server..."
proxmox-backup-client logout --repository "$PROXMOX_REPO"

if [ $? -ne 0 ]; then
  echo "Proxmox logout failed!"
else
  echo "Proxmox logout successful."
fi

mv "$BACKUP_NEW_DIR"/* "$BACKUP_OLD_DIR"
echo "backup moved to $BACKUP_OLD_DIR successful."
rm -rf "$BACKUP_NEW_DIR"
echo "$BACKUP_NEW_DIR remove successful."

cd "$BACKUP_OLD_DIR" || { echo "Directory not found: $BACKUP_OLD_DIR"; exit 1; }
ls -tp | grep -v '/$' | tail -n +7 | xargs -I {} rm -- {}


