#!/usr/bin/bash

# -----------------------------------------------------------------------------------------
# Useage notes
# -----------------------------------------------------------------------------------------
# Dry Run >>> ./file-backup.sh --dry-run
# Hot Run >>> ./file-backup.sh

# Set script to exit on fatal error.
set -euo pipefail
IFS=$'\n\t'

# -----------------------------------------------------------------------------------------
# Variable Definitions
# -----------------------------------------------------------------------------------------
ALPHAPATH="/media/ryansibert/AlphaVault/"
BETAPATH="/media/ryansibert/BetaVault/"
GAMMAPATH="/media/ryansibert/GammaVault/GammaVault"
MOUNTPOINT="/media/veracrypt1"
KEYFILE=''
LOGDIR="/home/ryansibert/Documents/Logs/"
TIMESTAMP=$(date +%F_%H-%M-%S)
LOGFILE1="$LOGDIR/beta-vault-$TIMESTAMP.log"
LOGFILE2="$LOGDIR/gamma-vault-$TIMESTAMP.log"

# -----------------------------------------------------------------------------------------
# Optional: enable dry-run mode for testing backups
# -----------------------------------------------------------------------------------------
RSYNC_OPTS=(
-rtvh
--delete
--info=progress2,stats
--exclude='.cache/'
--exclude='node_modules/'
--exclude='__pycache__/'
--exclude='*.tmp'
--exclude='.Trash-*/'
--exclude='$Recycle.Bin'
--exclude='System Volume Information'
)



if [ "${1:-}" = "--dry-run" ]; then
    RSYNC_OPTS+=(--dry-run)
    echo "⚠️  Running in DRY RUN mode — no files will be changed."
fi

# -----------------------------------------------------------------------------------------
# Prompt user to check drives
# -----------------------------------------------------------------------------------------
echo "Please make sure that AlphaVault (blue 1 Tb Samsung T7), BetaVault (4Tb Lacie),"
echo "and GammaVault (1TB Lacie) are wired and mounted."
read -n 1 -s -r -p "Then press any key to continue..."
echo
echo "Nice."

# -----------------------------------------------------------------------------------------
# Check for drives
# -----------------------------------------------------------------------------------------
for DRIVE in "$ALPHAPATH" "$BETAPATH"; do
    if ! mountpoint -q "$DRIVE"; then
        echo "Error: $DRIVE is not mounted. Exiting."
        exit 1
    fi
done

# -----------------------------------------------------------------------------------------
# Mount and unlock container
# -----------------------------------------------------------------------------------------
echo "Mounting GammaVault..."
sudo mkdir -p "$MOUNTPOINT"
veracrypt --text --pim=0 --protect-hidden=no --keyfiles="$KEYFILE" --mount "$GAMMAPATH" "$MOUNTPOINT"
if ! mountpoint -q "$MOUNTPOINT"; then
    echo "Error: GammaVault not mounted properly."
    exit 1
fi
echo "Done"

# -----------------------------------------------------------------------------------
# Back up email folder
# -----------------------------------------------------------------------------------
# Fetch new email and copy to Alpha
#echo "Fetching email (30 seconds)"
#timeout 30s thunderbird --headless -P "default-release"

# Check for email folder
#DIR="/media/ryansibert/AlphaVault/Backups/ThunderbirdBackup"
#if [ ! -d "$DIR" ]; then
#    mkdir -p "$DIR"
#    echo "Created $DIR"
#fi

#echo "Copying email from AlphaVault >>> BetaVault >>> GammaVault..."
#PROFILE_DIR=$(find ~/.thunderbird -maxdepth 1 -type d -name "*.default*" | head -n 1)
#rsync -rtvh --delete "$DIR"/ "$DIR"
#echo "Done"

# -----------------------------------------------------------------------------------------
# Mirror folder structure of alpha to beta and gamma
# -----------------------------------------------------------------------------------------
echo "Mirroring Alpha folder structure to Beta and Gamma..."
rsync -a --include='*/' --exclude='*' "$ALPHAPATH" "$BETAPATH"
rsync -a --include='*/' --exclude='*' "$ALPHAPATH" "$MOUNTPOINT/GammaVault/GammaVault/"
echo "Done."
# -----------------------------------------------------------------------------------
# Zim Mirrors
# -----------------------------------------------------------------------------------

# Mirror local Wikipedia ZIM to Alpha
echo "Copy Wikipedia to Alpha..."
rsync "${RSYNC_OPTS[@]}" --log-file="$LOGFILE1" \
"$HOME/Documents/Zims/wikipedia_en_all_maxi_2024-01.zim" \
"$ALPHAPATH/Zims"

# Mirror local Project Guttenberg ZIM to Alpha
echo "Copy Project Guttenberg to Alpha..."
rsync "${RSYNC_OPTS[@]}" --log-file="$LOGFILE1" \
"$HOME/Documents/Zims/gutenberg_mul_all_2023-08.zim" \
"$ALPHAPATH/Zims"

# -----------------------------------------------------------------------------------
# Disk Mirrors
# -----------------------------------------------------------------------------------
# Mirror Alpha to Beta, exit loud on fail
echo "Mirror Alpha to Beta..."
if ! rsync "${RSYNC_OPTS[@]}" --log-file="$LOGFILE1" "$ALPHAPATH"/ "$BETAPATH" 2>&1 | tee -a "$LOGFILE1"; then
    echo "❌ Backup to BetaVault failed."
    exit 1
fi
echo "✅ BetaVault sync complete."

# Mirror Alpha to Gamma, exit loud on fail
echo "Mirror Alpha to Gamma..."
# Exit loud on fail
if ! rsync "${RSYNC_OPTS[@]}" --log-file="$LOGFILE2" "$ALPHAPATH"/ "$MOUNTPOINT/GammaVault/GammaVault" 2>&1 | tee -a "$LOGFILE2"; then
    echo "❌ Backup to GammaVault failed."
    exit 1
fi
echo "✅ GammaVault sync complete."

echo "Done"

echo "Unmounting Gammavault..."
veracrypt -d "$MOUNTPOINT" || {
    echo "Failed to unmount GammaVault!"
    exit 1
}

echo "All backups completed successfully at $TIMESTAMP"
