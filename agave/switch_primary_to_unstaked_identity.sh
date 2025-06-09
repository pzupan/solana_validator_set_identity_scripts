#!/bin/bash

# create reciprical ssh certs so no password required on scp

# set the IP of your backup server
BACKUP_IP="00.00.00.00"

# change the names to your keypair files
echo "Staked: "
solana-keygen pubkey /home/sol/keys/mainnet-validator-keypair.json
echo "-- to --"
echo "Unstaked: "
# Note this is not the same junk key as is used on the backup server
solana-keygen pubkey /home/sol/keys/mainnet-validator-unstaked-1-keypair.json

read -p "Are you sure you want to proceed? (y/N): " response

if [[ "$response" =~ ^[Yy]$ ]]; then

    echo "Continuing..."

    agave-validator -l /mnt/ledger wait-for-restart-window --min-idle-time 2 --skip-new-snapshot-check

    status_1=$?

    if [ $status_1 -eq 0 ]; then

        agave-validator -l /mnt/ledger set-identity /home/sol/keys/mainnet-validator-unstaked-2-keypair.json

        status_2=$?

        if [ $status_2 -eq 0 ]; then
            echo "Identity swap succeeded"

            ln -sf /home/sol/keys/mainnet-validator-unstaked-2-keypair.json /home/sol/keys/mainnet-identity.json

            # change destination IP
            scp /mnt/ledger/tower-1_9-$(solana-keygen pubkey /home/sol/keys/mainnet-validator-keypair.json).bin sol@$($BACKUP_IP):/mnt/ledger

            echo "Complete"
        else

            echo "Identity swap failed with exit status: $status_2"
        fi

    else

        echo "Wait for restart window failed with exit status: $status_1"
    fi


else
    echo "Aborted"
fi
