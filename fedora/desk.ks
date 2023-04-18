lang en_US.UTF-8
keyboard pt-latin1
keyboard --vckeymap=pt --xlayouts='pt'
reboot --eject
firewall --service=ssh
firewall --disabled
firstboot --disable
#authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Etc/UTC

network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network  --hostname=desk

url                   --url=https://mirrors.ptisp.pt/fedora/linux/releases/37/Everything/x86_64/os/
repo --name="upd" --baseurl=https://mirrors.ptisp.pt/fedora/linux/updates/37/Everything/x86_64/

rootpw --iscrypted $1$00000000$ipUcSfN7NBVa7pqgFxjEi1
user --groups=wheel --name=fedora --password=$1$00000000$ipUcSfN7NBVa7pqgFxjEi1 --iscrypted --gecos="fedora"

sshkey --username=root   "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAzVXNSpI79JqVyqliWbeg3Qvvvz00NwnvzZQprsxNvw/nyDT1UoJNsaRNJ7zLU34Mdk8ZanvPY0UwrwmpB1o0Uuhf8erTLxBGA9HSqwo+BEOGJ1hLYXiFoRniTC4td0G53qsHkcladra/JEd8DzmZ5ynYjrgTYZ9SjWvrmE/IRm8= rsa-key-home"
sshkey --username=fedora "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAzVXNSpI79JqVyqliWbeg3Qvvvz00NwnvzZQprsxNvw/nyDT1UoJNsaRNJ7zLU34Mdk8ZanvPY0UwrwmpB1o0Uuhf8erTLxBGA9HSqwo+BEOGJ1hLYXiFoRniTC4td0G53qsHkcladra/JEd8DzmZ5ynYjrgTYZ9SjWvrmE/IRm8= rsa-key-home"

ignoredisk --only-use=sda
#clearpart  --drives=sda --all --initlabel
clearpart --none --initlabel
bootloader --boot-drive=sda --location=mbr --append="psi=on mitigations=off ipv6.disable=1 selinux=0 transparent_hugepage=never"

part /boot/efi --fstype=efi   --ondisk=sda --size=600 --fsoptions="defaults,uid=0,gid=0,umask=077,shortname=winnt"
part /boot     --fstype=ext4  --size=1024  --ondisk=sda
part pv.001    --fstype=lvmpv --size=65536 --ondisk=sda --grow
volgroup sysvg --pesize=65536 pv.001
logvol /      --fstype=xfs --size=32768 --name=root --vgname=sysvg
#logvol /home  --fstype=xfs --size=4096  --name=home --vgname=sysvg
logvol /tmp   --fstype=xfs --size=1024  --name=tmp  --vgname=sysvg


%packages
@^server-product-environment
podman
buildah
openconnect
vpnc-script
@c-development
@development-tools
@rpm-development-tools

genisoimage

qemu-user
qemu-user-binfmt
qemu-user-static
systemd-container

ntfs-3g
ntfs-3g-system-compression
ntfsprogs

xfsprogs

nvme-cli
nvmetcli

mc
vim-enhanced

%end

%post

#nvme-stas
#hostnamectl set-hostname iron.home.lan
echo "export HISTTIMEFORMAT='%F %T '">/etc/profile.d/history.sh
chmod 0755 /etc/profile.d/history.sh

%end
