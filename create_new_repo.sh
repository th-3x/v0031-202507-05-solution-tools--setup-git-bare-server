#!/bin/bash
# Create New Git Bare Repository Script

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <repository-name>"
    echo ""
    echo "Example: $0 myproject"
    echo "         $0 web-app"
    echo "         $0 mobile-app"
    exit 1
fi

REPO_NAME="$1"
GIT_BARE_DIR="/home/ln5/dev--path/v01--git-server/git-bare"
REPO_PATH="$GIT_BARE_DIR/${REPO_NAME}.git"

echo "📦 Creating New Git Repository"
echo "=============================="
echo "Repository: $REPO_NAME"
echo "Location:   $REPO_PATH"
echo "Date:       $(date)"
echo ""

# Check if repository already exists
if [ -d "$REPO_PATH" ]; then
    echo "❌ Repository '$REPO_NAME' already exists at $REPO_PATH"
    exit 1
fi

# Create the bare repository
echo "🔨 Creating bare repository..."
cd "$GIT_BARE_DIR"
git init --bare --shared=group "${REPO_NAME}.git"

# Set proper permissions
echo "🔐 Setting permissions..."
chmod -R g+rwX "${REPO_NAME}.git"
find "${REPO_NAME}.git" -type d -exec chmod g+s {} \;

echo ""
echo "✅ Repository created successfully!"
echo ""
echo "📋 Repository Information:"
echo "=========================="
echo "Name:     $REPO_NAME"
echo "Path:     $REPO_PATH"
echo "Type:     Bare repository"
echo "Sharing:  Group shared"
echo ""
echo "🔗 Clone URLs:"
echo "=============="
echo "SSH (short):  $(whoami)@localhost:dev--path/v01--git-server/git-bare/${REPO_NAME}.git"
echo "SSH (full):   $(whoami)@localhost:$REPO_PATH"
echo "Local:        $REPO_PATH"
echo ""
echo "📝 Example Usage:"
echo "================="
echo "# Clone repository"
echo "git clone $(whoami)@localhost:dev--path/v01--git-server/git-bare/${REPO_NAME}.git"
echo ""
echo "# Initialize with first commit"
echo "cd $REPO_NAME"
echo "echo '# $REPO_NAME' > README.md"
echo "git add README.md"
echo "git commit -m 'Initial commit'"
echo "git push origin master"
echo ""
echo "🎉 Repository '$REPO_NAME' is ready for use!"
