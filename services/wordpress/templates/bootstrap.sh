#!/usr/bin/env bash

set +ex

[[ -d /sites ]] && sudo mv /sites /sites.bak   
# Create Sites Volume
sudo mkfs -t xfs /dev/nvme1n1
sudo mkdir /sites
sudo chown 755 /sites
sitesuuid=$(blkid /dev/nvme1n1 -o full | awk '{print $2}')
sudo echo "$sitesuuid   /sites  xfs defaults,nofail  0 2" >> /etc/fstab

[[ -d /cache ]] && sudo mv /cache /cache.bak   
# Create Cache Volume
sudo mkfs -t xfs /dev/nvme2n1
sudo mkdir /cache
sudo chown 755 /cache
cacheuuid=$(blkid /dev/nvme2n1 -o full | awk '{print $2}')
sudo echo "$cacheuuid   /cache  xfs defaults,nofail  0 2" >> /etc/fstab

# Mount all the volumes
sudo mount -a

error=0

for mnt in /data /cache;
do
    mounted=$(sudo findmnt $mnt | tail -1 | awk '{print $1}')    
    if [[ $mounted -ne "$mnt" ]];
    then
    echo "Failed to mount $mnt";
    error=1;
    fi
done

if [[ $error == 1 ]];
then
    echo "Errors found when checking mounts";
    exit 1;
fi
