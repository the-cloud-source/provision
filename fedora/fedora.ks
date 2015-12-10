# Fedora 23 kickstart
install
url --url=https://dl.fedoraproject.org/pub/fedora/linux/releases/23/Server/x86_64 --noverifyssl
lang en_US.UTF-8
keyboard pt-latin1
network --onboot yes --device eth0 --bootproto dhcp --noipv6
rootpw dummy-root-password-to-keep-ks-happy
reboot --eject
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Etc/UTC

repo --name="os"          --baseurl=https://dl.fedoraproject.org/pub/fedora/linux/releases/23/Server/x86_64/os/ --cost=100 --noverifyssl
repo --name="os-updates"  --baseurl=https://dl.fedoraproject.org/pub/fedora/linux/updates/23/x86_64 --cost=1000

