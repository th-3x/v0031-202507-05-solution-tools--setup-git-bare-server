# Local Git Bare Server Setup

Complete setup and management tools for a local Git bare repository server with SSH access.

## 📁 Directory Structure

```
/home/ln5/dev--path/v01--git-server/
├── git-bare/                           # Git repositories storage
│   └── myproject.git/                  # Example bare repository
├── backups/                            # Backup storage
│   └── git-repos-backup-*.tar.gz      # Timestamped backups
└── tools-setup-local-git-bare/        # Setup and management tools
    ├── README.md                       # This documentation
    ├── setup_git_server.sh             # Complete server setup script
    ├── create_new_repo.sh               # Create new bare repository
    ├── add_user_key.sh                  # Add SSH user access
    ├── backup_git_repos.sh              # Backup repositories
    └── restore_from_backup.sh           # Restore from backup
```

## 🚀 Quick Setup

### 1. Initial Server Setup
```bash
cd /home/ln5/dev--path/v01--git-server/tools-setup-local-git-bare
./setup_git_server.sh
```

### 2. Create New Repository
```bash
./create_new_repo.sh <repository-name>
```

### 3. Add User Access
```bash
./add_user_key.sh
```

## 📖 Detailed Setup Instructions

### Prerequisites
- SSH server running (`systemctl status ssh`)
- Git installed
- User account with home directory

### Step-by-Step Setup

#### 1. SSH Configuration
```bash
# Ensure SSH is running
sudo systemctl enable ssh
sudo systemctl start ssh

# Create SSH directory with proper permissions
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

#### 2. Git Server Setup
```bash
# Create directory structure
mkdir -p /home/ln5/dev--path/v01--git-server/{git-bare,backups}
mkdir -p v01--git-server/{git-bare,backups}

```
cd v01--git-server/git-bare/
git init --bare --shared=group myproject.git
chmod -R g+rwX myproject.git
cd myproject.git/
git branch -m main
```

# Initialize first repository
cd /home/ln5/dev--path/v01--git-server/git-bare
git init --bare --shared=group myproject.git
chmod -R g+rwX myproject.git
```

#### 3. SSH Key Authentication
```bash
# Generate SSH key (if not exists)
ssh-keygen -t rsa -b 4096 -C "git-server-key"

# Add own key for testing
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

## 👥 Multi-User Access

### Adding New Users

1. **User generates SSH key:**
   ```bash
   ssh-keygen -t rsa -b 4096 -C "username@localhost"
   ```

2. **User shares public key:**
   ```bash
   cat ~/.ssh/id_rsa.pub
   ```

3. **Admin adds user's key:**
   ```bash
   echo "user_public_key_here" >> ~/.ssh/authorized_keys
   ```

### User Connection Examples

#### Clone Repository
```bash
# SSH method (recommended)
git clone ln5@localhost:dev--path/v01--git-server/git-bare/myproject.git

# Full path method
git clone ln5@localhost:/home/ln5/dev--path/v01--git-server/git-bare/myproject.git

# Local method (same machine)
git clone /home/ln5/dev--path/v01--git-server/git-bare/myproject.git
```

#### Test Connection
```bash
ssh -T ln5@localhost
```

#### Normal Git Operations
```bash
cd myproject
git add .
git commit -m "Your changes"
git push origin master
git pull origin master
```

## 🔧 Management Scripts

### setup_git_server.sh
Complete initial setup of Git server with SSH access.

### create_new_repo.sh
Create new bare repositories with proper permissions.
```bash
./create_new_repo.sh my-new-project
```

### add_user_key.sh
Interactive script to help add user SSH keys.

### backup_git_repos.sh
Backup all repositories with timestamp.
```bash
./backup_git_repos.sh
```

### restore_from_backup.sh
Restore repositories from backup file.
```bash
./restore_from_backup.sh backup-file.tar.gz
```

## 💾 Backup & Restore

### Manual Backup
```bash
cd /home/ln5/dev--path/v01--git-server/tools-setup-local-git-bare
./backup_git_repos.sh
```

### Automatic Backup (Cron)
```bash
# Add to crontab for daily backup at 2 AM
crontab -e
# Add line: 0 2 * * * /home/ln5/dev--path/v01--git-server/tools-setup-local-git-bare/backup_git_repos.sh
```

### Restore from Backup
```bash
./restore_from_backup.sh /path/to/backup/git-repos-backup-20250705_131402.tar.gz
```

## 🔍 Troubleshooting

### Common Issues

#### SSH Connection Refused
```bash
# Check SSH service
systemctl status ssh

# Check SSH configuration
sudo nano /etc/ssh/sshd_config
# Ensure: PubkeyAuthentication yes

# Restart SSH service
sudo systemctl restart ssh
```

#### Permission Denied
```bash
# Check file permissions
ls -la ~/.ssh/
# authorized_keys should be 600
# .ssh directory should be 700

# Fix permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

#### Git Push/Pull Issues
```bash
# Check repository permissions
ls -la /home/ln5/dev--path/v01--git-server/git-bare/

# Fix repository permissions
chmod -R g+rwX /home/ln5/dev--path/v01--git-server/git-bare/
```

### Logs and Debugging
```bash
# SSH connection logs
sudo tail -f /var/log/auth.log

# Test SSH connection with verbose output
ssh -vvv -T ln5@localhost
```

## 🔒 Security Considerations

### Best Practices
- Use SSH key authentication (no passwords)
- Regularly rotate SSH keys
- Monitor SSH access logs
- Use dedicated Git user account (optional)
- Backup regularly
- Set proper file permissions

### Optional: Dedicated Git User
```bash
# Create dedicated git user
sudo useradd -m -s /bin/bash git
sudo su - git

# Setup SSH for git user
mkdir ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Users would then connect as: git@localhost
```

## 📊 Repository Statistics

### Check Repository Size
```bash
du -sh /home/ln5/dev--path/v01--git-server/git-bare/*
```

### List All Repositories
```bash
ls -la /home/ln5/dev--path/v01--git-server/git-bare/
```

### Repository Information
```bash
cd /home/ln5/dev--path/v01--git-server/git-bare/myproject.git
git log --oneline
git branch -a
```

## 🆘 Support

For issues or questions:
1. Check this documentation
2. Review troubleshooting section
3. Check system logs
4. Test with verbose SSH connection

---

**Created:** $(date)  
**Location:** /home/ln5/dev--path/v01--git-server/tools-setup-local-git-bare/  
**Version:** 1.0
