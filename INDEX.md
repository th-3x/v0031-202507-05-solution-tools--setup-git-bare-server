# Git Bare Server Tools - Quick Reference

## 🚀 Quick Start
```bash
cd /home/ln5/dev--path/v01--git-server/tools-setup-local-git-bare
./quick_start.sh
```

## 📁 Files Overview

| File | Purpose | Usage |
|------|---------|-------|
| `README.md` | Complete documentation | `cat README.md` |
| `INDEX.md` | This quick reference | `cat INDEX.md` |
| `quick_start.sh` | Interactive menu | `./quick_start.sh` |
| `setup_git_server.sh` | Initial server setup | `./setup_git_server.sh` |
| `create_new_repo.sh` | Create new repository | `./create_new_repo.sh myproject` |
| `add_user_key.sh` | Add user SSH access | `./add_user_key.sh` |
| `backup_git_repos.sh` | Backup repositories | `./backup_git_repos.sh` |
| `restore_from_backup.sh` | Restore from backup | `./restore_from_backup.sh backup.tar.gz` |

## ⚡ Common Commands

### First Time Setup
```bash
./setup_git_server.sh
./create_new_repo.sh myproject
```

### Add User Access
```bash
./add_user_key.sh
# Follow the interactive prompts
```

### Daily Operations
```bash
# Backup
./backup_git_repos.sh

# Check status
./quick_start.sh
# Select option 7
```

### User Connection
```bash
# Test SSH
ssh -T ln5@localhost

# Clone repository
git clone ln5@localhost:dev--path/v01--git-server/git-bare/myproject.git
```

## 📍 Directory Structure
```
/home/ln5/dev--path/v01--git-server/
├── git-bare/                    # Git repositories
│   └── *.git/                   # Bare repositories
├── backups/                     # Backup files
│   └── git-repos-backup-*.tar.gz
└── tools-setup-local-git-bare/  # Management tools
    ├── README.md                # Full documentation
    ├── INDEX.md                 # This file
    └── *.sh                     # Management scripts
```

## 🔗 Connection URLs
- **SSH**: `ln5@localhost:dev--path/v01--git-server/git-bare/REPO.git`
- **Local**: `/home/ln5/dev--path/v01--git-server/git-bare/REPO.git`

---
*For detailed information, see README.md*
