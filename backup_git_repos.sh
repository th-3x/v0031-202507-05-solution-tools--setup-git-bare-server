#!/bin/bash
# Git Repository Backup Script
# Backs up all bare repositories in git-bare directory

BACKUP_DIR="/home/ln5/dev--path/v01--git-server/backups"
GIT_BARE_DIR="/home/ln5/dev--path/v01--git-server/git-bare"
DATE=$(date +%Y%m%d_%H%M%S)
HOSTNAME=$(hostname)

echo "💾 Git Repository Backup Script"
echo "==============================="
echo "Date:     $(date)"
echo "Host:     $HOSTNAME"
echo "User:     $(whoami)"
echo "Source:   $GIT_BARE_DIR"
echo "Backup:   $BACKUP_DIR"
echo ""

# Check if source directory exists
if [ ! -d "$GIT_BARE_DIR" ]; then
    echo "❌ Source directory not found: $GIT_BARE_DIR"
    exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Count repositories
REPO_COUNT=$(find "$GIT_BARE_DIR" -name "*.git" -type d | wc -l)
echo "📊 Found $REPO_COUNT repositories to backup"

if [ $REPO_COUNT -eq 0 ]; then
    echo "⚠️  No repositories found in $GIT_BARE_DIR"
    echo "   Create repositories with: ./create_new_repo.sh <name>"
    exit 1
fi

# List repositories
echo ""
echo "📦 Repositories to backup:"
find "$GIT_BARE_DIR" -name "*.git" -type d | while read repo; do
    repo_name=$(basename "$repo")
    repo_size=$(du -sh "$repo" | cut -f1)
    echo "  - $repo_name ($repo_size)"
done

echo ""
# Create timestamped backup
BACKUP_FILE="$BACKUP_DIR/git-repos-backup-$DATE.tar.gz"

echo "🔄 Creating backup: $(basename "$BACKUP_FILE")"
echo "   This may take a moment..."

# Create backup with progress
tar -czf "$BACKUP_FILE" -C "$(dirname "$GIT_BARE_DIR")" "$(basename "$GIT_BARE_DIR")" 2>/dev/null

if [ $? -eq 0 ]; then
    BACKUP_SIZE=$(du -sh "$BACKUP_FILE" | cut -f1)
    echo "✅ Backup created successfully!"
    echo ""
    echo "📁 Backup Details:"
    echo "   File: $(basename "$BACKUP_FILE")"
    echo "   Size: $BACKUP_SIZE"
    echo "   Path: $BACKUP_FILE"
    
    # Create backup info file
    INFO_FILE="${BACKUP_FILE}.info"
    cat > "$INFO_FILE" << EOF
Backup Information
==================
Date: $(date)
Host: $HOSTNAME
User: $(whoami)
Source: $GIT_BARE_DIR
Repositories: $REPO_COUNT
Size: $BACKUP_SIZE

Repositories backed up:
$(find "$GIT_BARE_DIR" -name "*.git" -type d | while read repo; do
    repo_name=$(basename "$repo")
    repo_size=$(du -sh "$repo" | cut -f1)
    echo "- $repo_name ($repo_size)"
done)

Restore command:
tar -xzf $(basename "$BACKUP_FILE") -C /desired/location/
EOF
    
    echo ""
    echo "📋 Recent backups:"
    ls -lht "$BACKUP_DIR"/git-repos-backup-*.tar.gz | head -5 | while read line; do
        echo "   $line"
    done
else
    echo "❌ Backup failed!"
    exit 1
fi

# Optional: Clean up old backups (keep last 10)
echo ""
echo "🧹 Cleaning up old backups (keeping last 10)..."
OLD_BACKUPS=$(ls -t "$BACKUP_DIR"/git-repos-backup-*.tar.gz 2>/dev/null | tail -n +11)
if [ -n "$OLD_BACKUPS" ]; then
    echo "$OLD_BACKUPS" | xargs rm -f
    echo "   Removed $(echo "$OLD_BACKUPS" | wc -l) old backup(s)"
    # Also remove corresponding .info files
    echo "$OLD_BACKUPS" | sed 's/\.tar\.gz$/.tar.gz.info/' | xargs rm -f 2>/dev/null
else
    echo "   No old backups to remove"
fi

echo "✅ Backup process completed!"
echo ""
echo "💡 To restore from this backup:"
echo "   ./restore_from_backup.sh $(basename "$BACKUP_FILE")"
