#!/bin/bash

GRUB_FILE="/etc/default/grub"

# Ensure the file exists before proceeding
if [[ -f "$GRUB_FILE" ]]; then
    echo "Updating GRUB timeout to 0..."
    
    # Replace or add the GRUB_TIMEOUT line
    if grep -q "^GRUB_TIMEOUT=" "$GRUB_FILE"; then
        # Modify existing line
        sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' "$GRUB_FILE"
    else
        # Add it if missing
        echo "GRUB_TIMEOUT=0" >> "$GRUB_FILE"
    fi

    grub-mkconfig -o /boot/grub/grub.cfg

    echo "GRUB timeout set to 0 and configuration updated."
else
    echo "❌ $GRUB_FILE not found!"
fi
