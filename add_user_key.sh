#!/bin/bash
# Add User SSH Key for Git Access

BASE_PATH="/home/ln5/dev--path"

echo "👥 Add User SSH Access to Git Server"
echo "===================================="
echo "Date: $(date)"
echo "Git Server: $(whoami)@localhost"
echo ""

echo "📋 Current authorized users:"
if [ -f ~/.ssh/authorized_keys ] && [ -s ~/.ssh/authorized_keys ]; then
    echo "Number of keys: $(wc -l < ~/.ssh/authorized_keys)"
    echo ""
    # Show key comments (usually contain user info)
    grep -o ' [^[:space:]]*$' ~/.ssh/authorized_keys | sed 's/^ /- /' || echo "- (no comments found)"
else
    echo "- No authorized keys found"
fi

echo ""
echo "🔧 To add a new user (e.g., 'aga'):"
echo "=================================="
echo ""
echo "1️⃣  User 'aga' generates SSH key:"
echo "   ssh-keygen -t rsa -b 4096 -C 'aga@localhost'"
echo ""
echo "2️⃣  User 'aga' shares public key:"
echo "   cat ~/.ssh/id_rsa.pub"
echo ""
echo "3️⃣  Admin (you) adds the key:"
echo "   echo 'PASTE_USER_PUBLIC_KEY_HERE' >> ~/.ssh/authorized_keys"
echo ""
echo "📝 Example for user 'aga':"
echo "=========================="
echo ""
echo "# User 'aga' runs these commands:"
echo "ssh-keygen -t rsa -b 4096 -C 'aga@localhost'"
echo "cat ~/.ssh/id_rsa.pub"
echo ""
echo "# Then 'aga' shares the output with you to add here:"
echo "echo 'ssh-rsa AAAAB3NzaC1yc2E... aga@localhost' >> ~/.ssh/authorized_keys"
echo ""
echo "🧪 Testing access:"
echo "=================="
echo "# User tests SSH connection:"
echo "ssh -T $(whoami)@localhost"
echo ""
echo "# User clones repository:"
echo "git clone $(whoami)@localhost:dev--path/v01--git-server/git-bare/myproject.git"
echo ""
echo "🔗 Available repositories:"
echo "========================="
if [ -d "$BASE_PATH/v01--git-server/git-bare" ]; then
    for repo in $BASE_PATH/v01--git-server/git-bare/*.git; do
        if [ -d "$repo" ]; then
            repo_name=$(basename "$repo")
            echo "- $repo_name"
            echo "  Clone: $(whoami)@localhost:dev--path/v01--git-server/git-bare/$repo_name"
        fi
    done
else
    echo "- No repositories found"
    echo "  Create one with: ./create_new_repo.sh myproject"
fi

echo ""
echo "💡 Interactive key addition:"
echo "============================"
read -p "Do you want to add a user's SSH key now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter username: " username
    echo ""
    echo "Please paste the user's SSH public key (entire line):"
    read -r ssh_key
    
    if [ -n "$ssh_key" ] && [[ "$ssh_key" == ssh-* ]]; then
        echo "$ssh_key" >> ~/.ssh/authorized_keys
        echo "✅ SSH key added for user '$username'"
        echo ""
        echo "🧪 User '$username' can now test with:"
        echo "ssh -T $(whoami)@localhost"
    else
        echo "❌ Invalid SSH key format. Key should start with 'ssh-rsa', 'ssh-ed25519', etc."
    fi
fi

echo ""
echo "📖 For more information, see README.md"
