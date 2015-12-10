# Centos 7 kickstart
install
url --url=http://mirror.centos.org/centos/7/os/x86_64 --noverifyssl
lang en_US.UTF-8
keyboard pt-latin1
network --onboot yes --device eth0 --bootproto dhcp --noipv6
rootpw dummy-root-password-to-keep-ks-happy
reboot --eject
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Etc/UTC

repo --name="CentOS"  --baseurl=http://mirror.centos.org/centos/7/os/x86_64 --cost=100 --noverifyssl
repo --name="CentOS-updates"  --baseurl=http://mirrors.centos.org/7/updates/x86_64/ --cost=1000

