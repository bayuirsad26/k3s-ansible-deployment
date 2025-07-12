#!/bin/bash
set -e

# --- Configuration ---
# Path where the new vault file will be created.
VAULT_FILE="inventory/production/group_vars/vault.yml"
TEMP_FILE=$(mktemp)

# --- Pre-flight Check ---
if ! command -v ansible-vault &> /dev/null; then
    echo "Error: ansible-vault is not installed or not in your PATH."
    echo "Please install Ansible to continue."
    exit 1
fi

echo "🔐 Generating secure random values for vault variables..."

# --- Generate Secrets ---
# Generate random passwords and keys using OpenSSL for strong randomness.
VAULT_POSTGRESQL_PASSWORD=$(openssl rand -base64 32)
VAULT_POSTGRESQL_REPLICATION_PASSWORD=$(openssl rand -base64 32)
VAULT_REDIS_PASSWORD=$(openssl rand -base64 32)
VAULT_GRAFANA_ADMIN_PASSWORD=$(openssl rand -base64 32)
VAULT_REGISTRY_PASSWORD=$(openssl rand -base64 32)
VAULT_BACKUP_ENCRYPTION_KEY=$(openssl rand -base64 48)
APP_DB_PASSWORD=$(openssl rand -base64 32)
GRAFANA_DB_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 64)
API_ENCRYPTION_KEY=$(openssl rand -base64 48)

echo "📄 Preparing vault content..."

# --- Create Plaintext YAML Content ---
# Use a "here document" to write the variables into a temporary file.
cat > "$TEMP_FILE" <<EOF
---
# This file was automatically generated and encrypted.
# DO NOT COMMIT THE UNENCRYPTED VERSION.

vault_postgresql_password: "$VAULT_POSTGRESQL_PASSWORD"
vault_postgresql_replication_password: "$VAULT_POSTGRESQL_REPLICATION_PASSWORD"
vault_redis_password: "$VAULT_REDIS_PASSWORD"
vault_grafana_admin_password: "$VAULT_GRAFANA_ADMIN_PASSWORD"
vault_registry_password: "$VAULT_REGISTRY_PASSWORD"
vault_backup_encryption_key: "$VAULT_BACKUP_ENCRYPTION_KEY"

# Database passwords
app_db_password: "$APP_DB_PASSWORD"
grafana_db_password: "$GRAFANA_DB_PASSWORD"

# Additional secrets
jwt_secret: "$JWT_SECRET"
api_encryption_key: "$API_ENCRYPTION_KEY"
EOF

# --- Encrypt the Vault File ---
echo "🔒 Encrypting the new vault file at: $VAULT_FILE"
echo "You will be prompted for a new vault password."

# Use ansible-vault to encrypt the temporary file into the final vault file.
ansible-vault encrypt "$TEMP_FILE" --output "$VAULT_FILE"

# --- Cleanup ---
# Securely remove the temporary plaintext file.
rm -f "$TEMP_FILE"

echo "✅ Success! Your new encrypted vault file has been created."
echo "You can now edit it using: ansible-vault edit $VAULT_FILE"
