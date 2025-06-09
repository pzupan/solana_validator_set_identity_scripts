# Validator Set Identity Scripts
These scripts demonstrate how to transition a staked identity from one machine to another without a restart. Using these scripts, a validator software update can be accomplished with virtually no downtime.

This technique requires that you set up reciprical ssh certificates on the two servers where you intend to swap identities.

## Set up SSH certificates

Make sure you are signed in using the user that you will use to run the scripts.
```
### create a key
ssh-keygen -t rsa -b 4096
### copy it to the other server using its IP address
ssh-copy-id sol@__.__.__.__ 
### test
ssh sol@__.__.__.__
```
Now do the same on the other server.

## Create two junk keys
Create two junk keys that will be used on the servers when they are unstaked.  Each server needs a seperate junk key as even though the switch happens quickly, you can't have two validators with the same identity running at the same time.  This will cause both nodes to restart if the junk key is the same.
```
solana-keygen new -s --no-bip39-passphrase -o mainnet-validator-unstaked-1-keypair.json
solana-keygen new -s --no-bip39-passphrase -o mainnet-validator-unstaked-2-keypair.json
```
Create the first on the primary server and the second on the backup.


## Create Identity Symlinks
An important part of how these scripts function is the identity.json symbolic link. This link allows a soft link to the desired identity so that the validator can restart or stop/start after we have switched identities.

On your actively voting validator, link this to your staked identity
```
ln -sf /home/sol/keys/mainnet-validator-identity.json /home/sol/keys/mainnet-identity.json
```
On your inactive, non-voting validator, link this to your unstaked "junk" identity
```
ln -sf /home/sol/keys/mainnet-validator-unstaked-2-keypair.json /home/sol/keys/mainnet-identity.json
```

## Edit the scripts to include your keypairs and server IPs
Make sure you review the scripts and change the file names of the keypairs, provide the relevant IP addresses, and confirm the name of your config file.

## Copy the relevant scripts to your servers

Set up the relevant scripts on each server. Each server will have two scripts: one to stake and one to unstack. For example, on the primary server, you will have:
```
switch_primary_to_unstaked_identity.sh
switch_primary_to_staked_identity.sh
```
## Switch Identities

To switch the identity key on the server that currently contains the staked identity, run:
```
bash switch_primary_to_unstaked_identity.sh
```
When you are prompted with "Are you sure you want to proceed?", wait and run the opposite script on the backup server.
```
bash switch_backup_to_staked_identity.sh
```
When you are prompted with "Are you sure you want to proceed?", return to the primary server and enter "Y".  When it completes, enter "Y" on the backup server.

Done with very few votes missed....

## Note
These could be consolidated down to one script, but I have created seperate scripts so that, once installed, they can be used with less opportunity for error.
