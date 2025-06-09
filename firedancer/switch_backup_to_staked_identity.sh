#!/bin/bash

# https://docs.firedancer.io/api/cli.html#set-identity

# force sudo before swap; good for 15 minutes
echo "Enter Sudo Password"
sudo /home/sol/firedancer/build/native/gcc/bin/fdctl --version

echo "Unstaked: "
solana-keygen pubkey /home/sol/keys/mainnet-validator-unstaked-2-keypair.json 
echo "-- to --"
echo "Staked: "
solana-keygen pubkey /home/sol/keys/mainnet-validator-keypair.json

read -p "Are you sure you want to proceed? (y/N): " response

if [[ "$response" =~ ^[Yy]$ ]]; then

    echo "Continuing..."

    sudo /home/sol/firedancer/build/native/gcc/bin/fdctl set-identity --config /home/sol/config/firedancer-validator.toml /home/sol/keys/mainnet-validator-keypair.json

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
