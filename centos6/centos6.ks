# Centos 6 kickstart
install
url --url=http://mirror.centos.org/centos/6.8/os/x86_64 --noverifyssl
lang en_US.UTF-8
keyboard pt-latin1
network --onboot yes --device eth0 --mtu=1500 --bootproto dhcp --noipv6
rootpw dummy-root-password-to-keep-ks-happy
user --groups=wheel --name=admin --password=dummy-password-to-keep-ks-happy
services --disabled="smartd,autofs,cups,xfs,avahi-daemon" --enabled="ntpd,rsyslogd,sssd"
reboot --eject
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Etc/UTC

zerombr
clearpart --all --drives=sda --initlabel
bootloader --location=mbr --driveorder=sda
part /boot --fstype=ext4 --size=500
part pv.pv --grow --size=1

volgroup vg_root --pesize=4096 pv.pv
logvol /     --fstype=ext4 --name=lv_root --vgname=vg_root --grow --size=1024 --maxsize=16384
logvol /home --fstype=ext4 --name=lv_home --vgname=vg_root --grow --size=1024 --maxsize=1024
logvol /tmp  --fstype=ext4 --name=lv_tmp  --vgname=vg_root --grow --size=1024 --maxsize=1024
logvol /var  --fstype=ext4 --name=lv_var  --vgname=vg_root --grow --size=1024 --maxsize=16384
logvol swap                --name=lv_swap --vgname=vg_root --grow --size=2048 --maxsize=2048

repo --name="CentOS"  --baseurl=http://mirror.centos.org/centos/6.8/os/x86_64 --cost=100 --noverifyssl
repo --name="CentOS"  --baseurl=http://mirrors.nfsi.pt/CentOS/6.8/os/x86_64/ --cost=1000
repo --name="CentOS-updates"  --baseurl=http://mirrors.nfsi.pt/CentOS/6.5/updates/x86_64/ --cost=1000
#repo --name="bf-software-6-x86_64"  --baseurl=http://ie1swp01.inf.betfair/yum/bf-software/6/x86_64 --cost=1000

%packages
@Base
@Core
@base
@client-mgmt-tools
@compat-libraries
@console-internet
@core
@debugging
@directory-client
@large-systems
@legacy-unix
@network-server
@network-tools
@performance
@perl-runtime
@remote-desktop-clients
@server-policy
@system-admin-tools
#bf-ca-cert-bundle
certmonger
dhcp
dos2unix
dtach
hardlink
iptraf
iptstate
kabi-yum-plugins
krb5-workstation
ksh
lslk
lsscsi
mc
mtools
nmap
oddjob
pam_krb5
rpm-build
screen
sdparm
sg3_utils
sgpio
sssd
sssd-tools
tcp_wrappers
telnet
tftp
tftp-server
tunctl
udftools
unix2dos
vim-enhanced
wodim
x86info
yum-plugin-verify
yum-plugin-versionlock
zsh
-avahi-daemon
-cups
-hunspell-en
-smartmontools

%end

%post
# disable ipv6
echo 'options ipv6 disable=1' > /etc/modprobe.d/ipv6.conf
sysctl -w net.ipv6.conf.all.disable_ipv6=1
echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf;

# configure history
echo "export HISTTIMEFORMAT='%F %T ' >/dev/null 2>&1"  >> /etc/profile.d/history-cfg.sh;
echo "export HISTSIZE=5000           >/dev/null 2>&1"  >> /etc/profile.d/history-cfg.sh;
chmod +x /etc/profile.d/history-cfg.sh;

#sudo
sed -i -e '/Defaults[ \t]*requiretty/d ' /etc/sudoers

#echo '%wheel ALL =(ALL) NOPASSWD: ALL' >>/etc/sudoers
cat <<EOF >/etc/sudoers.d/50-wheel-all
%wheel        ALL=(ALL)       NOPASSWD: ALL
EOF

chmod 600 /etc/sudoers.d/{50-wheel-all};

install -d -m 700 /root/.ssh; touch /root/.ssh/authorized_keys;  chmod 600 /root/.ssh/authorized_keys;
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIBg6I6+W9i3q4hrHWN6jqE7ONZMqImw5Op+yAXRL9t8wF+plOI/609DPAUbLF2gkxIFnb05vYWePzuZrl5+zbNXET3TbOBjjskG6itFIvbQmYnCUrn8Oj2VfhdQBGC9s56Kgw8B9WlsCx7ZYcE7YP1v4yei6MylvCvDIWS7VLPKOQ== rsa-key-JoaoFontes@Blip' >>/root/.ssh/authorized_keys;

echo 'set background=dark' >> /etc/vimrc;

#delete passwords
echo 'root:!!'  | chpasswd -e;
echo 'admin:!!' | chpasswd -e;
#### EOT ####
