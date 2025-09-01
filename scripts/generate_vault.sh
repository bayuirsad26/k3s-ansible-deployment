#!/bin/bash
set -e

# Configuration
VAULT_FILE="inventory/production/group_vars/vault.yml"
TEMP_FILE=$(mktemp)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔐 Generating secure vault file...${NC}"

# Pre-flight checks
if [ ! -f ".vault_pass" ]; then
    echo -e "${YELLOW}📝 Creating .vault_pass file...${NC}"
    openssl rand -base64 32 > .vault_pass
    chmod 600 .vault_pass
    echo -e "${GREEN}✅ Vault password file created${NC}"
fi

if [ -f "$VAULT_FILE" ]; then
    echo -e "${YELLOW}⚠️  Vault file already exists. Backup will be created.${NC}"
    cp "$VAULT_FILE" "${VAULT_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Generate secrets
echo -e "${GREEN}🎲 Generating random secure passwords...${NC}"

# Generate 32-character passwords for databases
PG_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
PG_REPL_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
REDIS_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
GRAFANA_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
REGISTRY_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
APP_DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
GRAFANA_DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)

# Generate longer keys for encryption
BACKUP_KEY=$(openssl rand -base64 64 | tr -d "=+/" | cut -c1-64)
JWT_SECRET=$(openssl rand -base64 64 | tr -d "=+/" | cut -c1-64)
API_KEY=$(openssl rand -base64 64 | tr -d "=+/" | cut -c1-64)

# Create vault content
cat > "$TEMP_FILE" <<EOF
---
# Auto-generated vault file - $(date)
# All passwords are randomly generated and secure

# Database passwords
vault_postgresql_password: "$PG_PASSWORD"
vault_postgresql_replication_password: "$PG_REPL_PASSWORD"
vault_redis_password: "$REDIS_PASSWORD"

# Application passwords
vault_grafana_admin_password: "$GRAFANA_PASSWORD"  
vault_registry_password: "$REGISTRY_PASSWORD"
app_db_password: "$APP_DB_PASSWORD"
grafana_db_password: "$GRAFANA_DB_PASSWORD"

# Encryption keys
vault_backup_encryption_key: "$BACKUP_KEY"
jwt_secret: "$JWT_SECRET"
api_encryption_key: "$API_KEY"
EOF

# Encrypt the vault
echo -e "${GREEN}🔒 Encrypting vault file...${NC}"
ansible-vault encrypt "$TEMP_FILE" --vault-password-file=.vault_pass --output "$VAULT_FILE"

# Cleanup
rm -f "$TEMP_FILE"

echo -e "${GREEN}✅ Vault file created successfully!${NC}"
echo -e "${YELLOW}📝 Important notes:${NC}"
echo "   - Vault password is stored in .vault_pass (keep secure!)"
echo "   - Vault file is encrypted at: $VAULT_FILE"
echo "   - Edit vault: ansible-vault edit $VAULT_FILE --vault-password-file=.vault_pass"
echo "   - View vault: ansible-vault view $VAULT_FILE --vault-password-file=.vault_pass"
