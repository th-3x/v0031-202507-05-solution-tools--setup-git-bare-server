#!/bin/bash
# Quick Start Script for Git Bare Server

echo "🚀 Git Bare Server - Quick Start"
echo "================================="
echo ""

TOOLS_DIR="/home/ln5/dev--path/v01--git-server/tools-setup-local-git-bare"
cd "$TOOLS_DIR"

echo "Available commands:"
echo "==================="
echo ""
echo "🔧 Setup & Management:"
echo "  1. setup_git_server.sh     - Complete initial setup"
echo "  2. create_new_repo.sh      - Create new repository"
echo "  3. add_user_key.sh         - Add user SSH access"
echo ""
echo "💾 Backup & Restore:"
echo "  4. backup_git_repos.sh     - Backup all repositories"
echo "  5. restore_from_backup.sh  - Restore from backup"
echo ""
echo "📖 Documentation:"
echo "  6. View README.md          - Complete documentation"
echo "  7. Show current status     - Repository and user info"
echo ""

read -p "Select option (1-7) or press Enter to exit: " choice

case $choice in
    1)
        echo ""
        echo "🔧 Running initial setup..."
        ./setup_git_server.sh
        ;;
    2)
        echo ""
        read -p "Enter repository name: " repo_name
        if [ -n "$repo_name" ]; then
            ./create_new_repo.sh "$repo_name"
        else
            echo "❌ Repository name required"
        fi
        ;;
    3)
        echo ""
        ./add_user_key.sh
        ;;
    4)
        echo ""
        ./backup_git_repos.sh
        ;;
    5)
        echo ""
        ./restore_from_backup.sh
        ;;
    6)
        echo ""
        if command -v less >/dev/null 2>&1; then
            less README.md
        else
            cat README.md
        fi
        ;;
    7)
        echo ""
        echo "📊 Current Status"
        echo "================="
        echo ""
        
        # SSH Service
        echo "🔐 SSH Service:"
        if systemctl is-active --quiet ssh || systemctl is-active --quiet sshd; then
            echo "   ✅ Running"
        else
            echo "   ❌ Not running"
        fi
        
        # SSH Keys
        echo ""
        echo "🔑 SSH Keys:"
        if [ -f ~/.ssh/authorized_keys ] && [ -s ~/.ssh/authorized_keys ]; then
            key_count=$(wc -l < ~/.ssh/authorized_keys)
            echo "   ✅ $key_count authorized key(s)"
        else
            echo "   ⚠️  No authorized keys"
        fi
        
        # Repositories
        echo ""
        echo "📦 Repositories:"
        GIT_BARE_DIR="/home/ln5/dev--path/v01--git-server/git-bare"
        if [ -d "$GIT_BARE_DIR" ]; then
            repo_count=$(find "$GIT_BARE_DIR" -name "*.git" -type d | wc -l)
            if [ $repo_count -gt 0 ]; then
                echo "   ✅ $repo_count repository(ies):"
                find "$GIT_BARE_DIR" -name "*.git" -type d | while read repo; do
                    repo_name=$(basename "$repo")
                    repo_size=$(du -sh "$repo" | cut -f1)
                    echo "      - $repo_name ($repo_size)"
                done
            else
                echo "   ⚠️  No repositories found"
            fi
        else
            echo "   ❌ git-bare directory not found"
        fi
        
        # Backups
        echo ""
        echo "💾 Backups:"
        BACKUP_DIR="/home/ln5/dev--path/v01--git-server/backups"
        if [ -d "$BACKUP_DIR" ]; then
            backup_count=$(ls "$BACKUP_DIR"/git-repos-backup-*.tar.gz 2>/dev/null | wc -l)
            if [ $backup_count -gt 0 ]; then
                echo "   ✅ $backup_count backup(s) available"
                echo "   Latest: $(ls -t "$BACKUP_DIR"/git-repos-backup-*.tar.gz 2>/dev/null | head -1 | xargs basename)"
            else
                echo "   ⚠️  No backups found"
            fi
        else
            echo "   ❌ Backup directory not found"
        fi
        
        echo ""
        echo "🔗 Connection Info:"
        echo "   SSH: $(whoami)@localhost"
        echo "   Clone: $(whoami)@localhost:dev--path/v01--git-server/git-bare/REPO_NAME.git"
        ;;
    *)
        echo ""
        echo "👋 Goodbye! Run ./quick_start.sh anytime for quick access."
        ;;
esac
