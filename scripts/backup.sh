#!/bin/bash
set -e

BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/${BACKUP_DATE}"

echo "🔒 Starting backup process..."
echo "Backup directory: ${BACKUP_DIR}"

# Run backup playbook
ansible-playbook -i inventory/production/hosts.yml \
  playbooks/backup-restore.yml \
  --tags backup \
  -e "backup_timestamp=${BACKUP_DATE}"

echo "✅ Backup completed successfully!"
