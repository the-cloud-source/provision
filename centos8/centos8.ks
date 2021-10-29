install
lang en_US.UTF-8
keyboard pt-latin1
reboot --eject
firewall --disabled
firstboot --disable
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Etc/UTC
