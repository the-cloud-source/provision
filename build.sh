#!/bin/bash

IPXE_REPO=${IPXE_REPO:-/svn/ipxe}
EMBEDED=$(dirname $(readlink -f "$0"))


cd $IPXE_REPO/src &&
make clean && \\
make bin/undionly.kpxe EMBED=${EMBEDED}/embed.github.ipxe && \\ 
scp bin/undionly.kpxe root@10.100.100.2:/mnt/usb/tftp/undionly.github.com.kpxe

cd $IPXE_REPO/src &&
make clean && \\
make bin/undionly.kpxe EMBED=${EMBEDED}/embed.gitlab.ipxe && \\
scp bin/undionly.kpxe root@10.100.100.2:/mnt/usb/tftp/undionly.gitlab.com.kpxe
