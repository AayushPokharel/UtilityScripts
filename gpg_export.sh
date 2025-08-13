#!/bin/bash
# Export all GPG keys into a given directory

EXPORT_DIR="$HOME/gpg_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$EXPORT_DIR"

echo "[+] Exporting GPG keys to $EXPORT_DIR"

# List all secret keys (private) and extract key IDs
for key in $(gpg --list-secret-keys --keyid-format LONG | grep sec | awk '{print $2}' | cut -d'/' -f2); do
    echo "[*] Exporting key ID: $key"

    # Export public key
    gpg --export --armor "$key" > "$EXPORT_DIR/${key}_public.asc"

    # Export private key
    gpg --export-secret-keys --armor "$key" > "$EXPORT_DIR/${key}_private.asc"

    # Export secret subkeys (optional)
    gpg --export-secret-subkeys --armor "$key" > "$EXPORT_DIR/${key}_subkeys.asc"
done

echo "[+] All keys exported."
echo "[!] Remember: PRIVATE keys are sensitive. Keep them secure!"
