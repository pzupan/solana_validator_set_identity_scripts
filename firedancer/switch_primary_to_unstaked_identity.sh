#!/bin/bash

# https://docs.firedancer.io/api/cli.html#set-identity

# create reciprical ssh certs so no password required on scp

# set the IP of your backup server
BACKUP_IP="00.00.00.00"

# force sudo password so no password required during swap. Good for 15 minutes
echo "Enter Sudo Password"
sudo /home/sol/firedancer/build/native/gcc/bin/fdctl --version

echo "Staked:"
solana-keygen pubkey /home/sol/keys/mainnet-validator-keypair.json
echo "-- to --"
echo "Unstaked"
# not this is not the same junk key as is used on the backup
solana-keygen pubkey /home/sol/keys/mainnet-validator-unstaked-1-keypair.json

read -p "Are you sure you want to proceed? (y/N): " response

if [[ "$response" =~ ^[Yy]$ ]]; then

    echo "Continuing..."

    sudo /home/sol/firedancer/build/native/gcc/bin/fdctl set-identity --config /home/sol/config/firedancer-validator.toml /home/sol/keys/mainnet-validator-unstaked-1-keypair.json

    status=$?
    if [ $status -eq 0 ]; then
        echo "Identity swap succeeded"

        ln -sf /home/sol/keys/mainnet-validator-unstaked-1-keypair.json /home/sol/keys/mainnet-identity.json
        
        # change destination IP to the IP of the backup
        scp /mnt/ledger/tower-1_9-$(solana-keygen pubkey /home/sol/keys/mainnet-validator-keypair.json).bin sol@$($BACKUP_IP):/mnt/ledger

        echo "Complete"
    else
        echo "Identity swap failed with exit status: $status"
    fi

else
    echo "Aborted"
fi
