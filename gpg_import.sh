#!/bin/bash
# Import all GPG keys from a backup directory and set trust

if [ -z "$1" ]; then
    echo "Usage: $0 <backup_directory>"
    exit 1
fi

BACKUP_DIR="$1"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Directory '$BACKUP_DIR' not found."
    exit 1
fi

echo "[+] Importing all GPG keys from $BACKUP_DIR"

# Import all .asc files
for keyfile in "$BACKUP_DIR"/*.asc; do
    if [ -f "$keyfile" ]; then
        echo "[*] Importing $keyfile"
        gpg --import "$keyfile"
    fi
done

# Set trust to ultimate for all imported keys
echo "[+] Setting trust level to ultimate for imported keys"
gpg --list-keys --with-colons | grep ^pub | while IFS=: read -r _ _ _ keyid _ _ _ _ _ _ _; do
    echo "[*] Setting trust for $keyid"
    echo -e "trust\n5\ny\nsave" | gpg --command-fd 0 --edit-key "$keyid"
done

# Reload GPG agent
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent

echo "[+] Import complete. All keys trusted and agent reloaded."

