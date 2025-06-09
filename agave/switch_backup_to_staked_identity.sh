#!/bin/bash


# change the names to your keypair files
echo "Unstaked: "
solana-keygen pubkey /home/sol/keys/mainnet-validator-unstaked-2-keypair.json
echo "-- to --"
echo "Staked: "
solana-keygen pubkey /home/sol/keys/mainnet-validator-keypair.json

read -p "Are you sure you want to proceed? (y/N): " response

if [[ "$response" =~ ^[Yy]$ ]]; then

    echo "Continuing..."

    agave-validator -l /mnt/ledger set-identity /home/sol/keys/mainnet-validator-keypair.json

    status=$?
    if [ $status -eq 0 ]; then
        echo "Identity swap succeeded"
        ln -sf /home/sol/keys/mainnet-validator-keypair.json /home/sol/keys/mainnet-identity.json

        echo "Complete"
    else
        echo "Identity swap failed with exit status: $status"
    fi

else
    echo "Aborted"
fi
