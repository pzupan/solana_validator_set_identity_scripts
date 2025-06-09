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

## Edit the scripts to include your keypairs and server IPs

Make sure you review the scripts and change the file names of the keypairs and the relevant IP addresses.

## Copy the relevant scripts to your servers

Set up the relevant scripts on each server. Each server will have two scripts: one to stake and one to unstack. For example, on the primary server, you will have:
```
switch_primary_to_unstaked_identity.sh
switch_primary_to_staked_identity.sh
```
## Switch Identities

To switch the identity key on the server that currently contains the staked identity, run:

bash switch_primary_to_unstaked_identity.sh

When you are prompted with "Are you sure you want to proceed?", wait and run the opposite script on the backup server.

bash switch_backup_to_staked_identity.sh

When you are prompted with "Are you sure you want to proceed?", return to the primary server and enter "Y".  When it completes, enter "Y" on the backup server.

Done with very few votes missed....

## Note
These could be consolidated down to one script, but I have created seperate scripts so that, once installed, they can be used with fewer opportunity for error.
