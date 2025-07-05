#!/bin/bash
# Complete Git Bare Server Setup Script
# Sets up SSH-based Git server with proper permissions and directory structure

set -e  # Exit on any error

echo "🚀 Git Bare Server Setup"
echo "========================"
echo "Date: $(date)"
echo "User: $(whoami)"
echo "Home: $HOME"
echo ""

# Configuration
GIT_SERVER_BASE="$HOME/dev--path/v01--git-server"
GIT_BARE_DIR="$GIT_SERVER_BASE/git-bare"
BACKUP_DIR="$GIT_SERVER_BASE/backups"
TOOLS_DIR="$GIT_SERVER_BASE/tools-setup-local-git-bare"

echo "📁 Setting up directory structure..."
mkdir -p "$GIT_BARE_DIR"
mkdir -p "$BACKUP_DIR"
mkdir -p "$TOOLS_DIR"
echo "✅ Directories created"

echo ""
echo "🔐 Setting up SSH configuration..."

# Setup SSH directory and permissions
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo "✅ SSH directory configured"

# Generate SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "🔑 Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" -C "git-server-$(whoami)@$(hostname)"
    echo "✅ SSH key generated"
else
    echo "✅ SSH key already exists"
fi

# Add own key to authorized_keys if not already there
if ! grep -q "$(cat ~/.ssh/id_rsa.pub)" ~/.ssh/authorized_keys 2>/dev/null; then
    echo "🔑 Adding own SSH key to authorized_keys..."
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    echo "✅ SSH key added"
else
    echo "✅ SSH key already in authorized_keys"
fi

echo ""
echo "🔍 Checking SSH service..."
if systemctl is-active --quiet ssh || systemctl is-active --quiet sshd; then
    echo "✅ SSH service is running"
else
    echo "⚠️  SSH service is not running"
    echo "   Please start SSH service: sudo systemctl start ssh"
fi

echo ""
echo "🧪 Testing SSH connection..."
if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -T $(whoami)@localhost echo "SSH test successful" 2>/dev/null; then
    echo "✅ SSH connection working"
else
    echo "⚠️  SSH connection failed - please check SSH service and keys"
fi

echo ""
echo "📋 Setup Summary:"
echo "=================="
echo "Git repositories: $GIT_BARE_DIR"
echo "Backups:         $BACKUP_DIR"
echo "Tools:           $TOOLS_DIR"
echo "SSH keys:        ~/.ssh/"
echo ""
echo "🎉 Git server setup completed!"
echo ""
echo "Next steps:"
echo "1. Create your first repository: ./create_new_repo.sh myproject"
echo "2. Add user access: ./add_user_key.sh"
echo "3. Test cloning: git clone $(whoami)@localhost:dev--path/v01--git-server/git-bare/myproject.git"
echo ""
echo "📖 See README.md for detailed documentation"
