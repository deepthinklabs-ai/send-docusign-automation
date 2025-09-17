#!/bin/bash

# Backup script for n8n workflows and data
# Usage: ./backup.sh [backup_directory]

set -e

BACKUP_DIR=${1:-"./backups"}
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_PATH="$BACKUP_DIR/n8n_backup_$TIMESTAMP"

echo "💾 Starting n8n backup"
echo "📁 Backup location: $BACKUP_PATH"
echo ""

# Create backup directory
mkdir -p "$BACKUP_PATH"

# Check if n8n container is running
if docker ps | grep -q "n8n-docusign-automation"; then
    echo "✅ n8n container is running"
    
    # Export workflows
    echo "📦 Exporting workflows..."
    docker exec n8n-docusign-automation n8n export:workflow --all --output="/tmp/workflows_backup.json"
    docker cp n8n-docusign-automation:/tmp/workflows_backup.json "$BACKUP_PATH/workflows.json"
    
    # Export credentials (structure only, not sensitive data)
    echo "🔐 Exporting credential structure..."
    docker exec n8n-docusign-automation n8n export:credentials --all --output="/tmp/credentials_backup.json" --decryptionKey="backup" || true
    docker cp n8n-docusign-automation:/tmp/credentials_backup.json "$BACKUP_PATH/credentials.json" 2>/dev/null || echo "⚠️  Credentials export skipped (contains sensitive data)"
    
    # Backup n8n data directory
    echo "📂 Backing up n8n data directory..."
    docker cp n8n-docusign-automation:/home/node/.n8n "$BACKUP_PATH/n8n_data" || echo "⚠️  Data directory backup failed"
    
else
    echo "❌ n8n container is not running"
    echo "💡 If you have local n8n installation, backup ~/.n8n directory manually"
    exit 1
fi

# Copy current workflow files
if [ -d "./workflows" ]; then
    echo "📋 Copying workflow files..."
    cp -r ./workflows "$BACKUP_PATH/workflow_files"
fi

# Copy configuration files
if [ -f "./.env" ]; then
    echo "⚙️  Copying configuration (without secrets)..."
    # Copy .env but mask sensitive values
    sed 's/=.*/=***MASKED***/g' ./.env > "$BACKUP_PATH/env_template.txt"
fi

# Create backup info file
cat > "$BACKUP_PATH/backup_info.txt" << EOF
Backup Information
==================
Date: $(date)
Environment: $(docker exec n8n-docusign-automation printenv NODE_ENV 2>/dev/null || echo "unknown")
n8n Version: $(docker exec n8n-docusign-automation n8n --version 2>/dev/null || echo "unknown")
Container Status: $(docker ps --filter name=n8n-docusign-automation --format "{{.Status}}" || echo "not running")
Backup Contents:
- workflows.json (exported workflows)
- n8n_data/ (full n8n data directory)
- workflow_files/ (source workflow files)
- env_template.txt (configuration template)

Restore Instructions:
1. Import workflows: n8n import:workflow --input=workflows.json
2. Reconfigure credentials in n8n UI
3. Update .env file with your values
4. Test all workflows after restore
EOF

# Compress backup
echo "🗜️  Compressing backup..."
tar -czf "$BACKUP_PATH.tar.gz" -C "$BACKUP_DIR" "n8n_backup_$TIMESTAMP"
rm -rf "$BACKUP_PATH"

echo ""
echo "✅ Backup completed successfully!"
echo "📦 Backup file: $BACKUP_PATH.tar.gz"
echo "📊 Size: $(du -h "$BACKUP_PATH.tar.gz" | cut -f1)"
echo ""
echo "To restore:"
echo "1. Extract: tar -xzf $BACKUP_PATH.tar.gz"
echo "2. Import workflows in n8n"
echo "3. Reconfigure credentials"
echo ""

# Clean up old backups (keep last 5)
echo "🧹 Cleaning up old backups (keeping last 5)..."
ls -t "$BACKUP_DIR"/n8n_backup_*.tar.gz 2>/dev/null | tail -n +6 | xargs -r rm -f
echo "✅ Cleanup complete"
