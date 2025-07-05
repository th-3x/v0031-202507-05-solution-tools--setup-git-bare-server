#!/bin/bash
# Restore Git Repositories from Backup

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <backup-file.tar.gz> [destination-directory]"
    echo ""
    echo "Examples:"
    echo "  $0 git-repos-backup-20250705_131402.tar.gz"
    echo "  $0 /path/to/backup.tar.gz /custom/restore/location"
    echo ""
    echo "Available backups:"
    BACKUP_DIR="/home/ln5/dev--path/v01--git-server/backups"
    if [ -d "$BACKUP_DIR" ]; then
        ls -lt "$BACKUP_DIR"/git-repos-backup-*.tar.gz 2>/dev/null | head -5 || echo "  No backups found"
    fi
    exit 1
fi

BACKUP_FILE="$1"
DEFAULT_RESTORE_DIR="/home/ln5/dev--path/v01--git-server"
RESTORE_DIR="${2:-$DEFAULT_RESTORE_DIR}"

echo "🔄 Git Repository Restore"
echo "========================="
echo "Date:        $(date)"
echo "Backup file: $BACKUP_FILE"
echo "Restore to:  $RESTORE_DIR"
echo ""

# Check if backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    # Try to find it in the backups directory
    BACKUP_DIR="/home/ln5/dev--path/v01--git-server/backups"
    FULL_PATH="$BACKUP_DIR/$BACKUP_FILE"
    if [ -f "$FULL_PATH" ]; then
        BACKUP_FILE="$FULL_PATH"
        echo "📁 Found backup file: $BACKUP_FILE"
    else
        echo "❌ Backup file not found: $BACKUP_FILE"
        echo ""
        echo "Available backups:"
        ls -lt "$BACKUP_DIR"/git-repos-backup-*.tar.gz 2>/dev/null || echo "  No backups found"
        exit 1
    fi
fi

# Show backup information if available
INFO_FILE="${BACKUP_FILE}.info"
if [ -f "$INFO_FILE" ]; then
    echo "📋 Backup Information:"
    echo "======================"
    cat "$INFO_FILE"
    echo ""
fi

# Check backup file integrity
echo "🔍 Checking backup file integrity..."
if tar -tzf "$BACKUP_FILE" >/dev/null 2>&1; then
    echo "✅ Backup file is valid"
else
    echo "❌ Backup file is corrupted or invalid"
    exit 1
fi

# Show what will be restored
echo ""
echo "📦 Contents to be restored:"
tar -tzf "$BACKUP_FILE" | head -10
TOTAL_FILES=$(tar -tzf "$BACKUP_FILE" | wc -l)
if [ $TOTAL_FILES -gt 10 ]; then
    echo "... and $((TOTAL_FILES - 10)) more files"
fi

echo ""
echo "⚠️  WARNING: This will restore to $RESTORE_DIR"
if [ -d "$RESTORE_DIR/git-bare" ]; then
    echo "   Existing git-bare directory will be backed up first"
fi

read -p "Continue with restore? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Restore cancelled"
    exit 1
fi

# Create restore directory
mkdir -p "$RESTORE_DIR"

# Backup existing git-bare if it exists
if [ -d "$RESTORE_DIR/git-bare" ]; then
    BACKUP_EXISTING="$RESTORE_DIR/git-bare.backup.$(date +%Y%m%d_%H%M%S)"
    echo "💾 Backing up existing git-bare to: $(basename "$BACKUP_EXISTING")"
    mv "$RESTORE_DIR/git-bare" "$BACKUP_EXISTING"
fi

# Restore from backup
echo ""
echo "🔄 Restoring repositories..."
cd "$RESTORE_DIR"
tar -xzf "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Restore completed successfully!"
    
    # Show restored repositories
    echo ""
    echo "📦 Restored repositories:"
    if [ -d "$RESTORE_DIR/git-bare" ]; then
        find "$RESTORE_DIR/git-bare" -name "*.git" -type d | while read repo; do
            repo_name=$(basename "$repo")
            repo_size=$(du -sh "$repo" | cut -f1)
            echo "  - $repo_name ($repo_size)"
        done
    fi
    
    # Set proper permissions
    echo ""
    echo "🔐 Setting proper permissions..."
    if [ -d "$RESTORE_DIR/git-bare" ]; then
        chmod -R g+rwX "$RESTORE_DIR/git-bare"
        find "$RESTORE_DIR/git-bare" -name "*.git" -type d -exec chmod g+s {} \;
        echo "✅ Permissions set"
    fi
    
    echo ""
    echo "🎉 Restore process completed!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Verify repositories: ls -la $RESTORE_DIR/git-bare/"
    echo "2. Test SSH access: ssh -T $(whoami)@localhost"
    echo "3. Test clone: git clone $(whoami)@localhost:dev--path/v01--git-server/git-bare/REPO_NAME.git"
    
else
    echo "❌ Restore failed!"
    exit 1
fi
