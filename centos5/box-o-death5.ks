#---------------------------------------------------------------------------------------------------------------------
# kickstart file for devops test box
#---------------------------------------------------------------------------------------------------------------------

install
text
#url --url http://mirror.centos.org/centos/5.9/os/x86_64
url --url http://mirrors.nfsi.pt/CentOS/5.9/os/x86_64/
lang en_US.UTF-8
keyboard pt-latin1
rootpw cenasmaradas
user --name=joao.fontes   --groups=wheel --password=CEN@Sm@r@d@s --uid=1000
user --name=administrator --groups=wheel --password=CENAS        --uid=1001
reboot --eject

network --device eth0 --bootproto dhcp --hostname production.uk.betfair.local
firewall --disabled --port=22:tcp
authconfig --enableshadow --enablemd5
selinux --disabled
timezone --utc Europe/Lisbon
firstboot --disable
logging --level=info
### with autostep --autoscreenshot 
###    - no consoles are available
###    - text install fails
#autostep --autoscreenshot

zerombr
clearpart --all --initlabel --drives=sda
bootloader --location=mbr --driveorder=sda
part /boot --fstype ext3 --size=512 --ondisk=sda
part pv.2 --size=0 --grow --ondisk=sda
volgroup vgroot --pesize=32768 pv.2
logvol swap           --fstype swap --name=lvswap  --vgname=vgroot --size=512
logvol /              --fstype ext4 --name=lvroot  --vgname=vgroot --size=4096
logvol /usr           --fstype ext4 --name=lvusr   --vgname=vgroot --size=4096
logvol /opt           --fstype ext4 --name=lvopt   --vgname=vgroot --size=512
logvol /tmp           --fstype ext4 --name=lvtmp   --vgname=vgroot --size=1024
logvol /var           --fstype ext4 --name=lvvar   --vgname=vgroot --size=4096
logvol /home          --fstype ext4 --name=lvhome  --vgname=vgroot --size=512
logvol /var/lib/mysql --fstype ext4 --name=lvmysql --vgname=vgroot --size=512

services --enabled  ntpd,httpd,mysqld,rsyslog
services --disabled smartd,autofs,cups,xfs,avahi-daemon

#repo	--name=install-updates         --mirrorlist=http://mirrorlist.centos.org/?release=5&arch=x86_64&repo=updates
 repo	--name=install-updates         --baseurl=http://mirrors.nfsi.pt/CentOS/5.9/updates/x86_64/
#repo	--name=vmware-tools-collection --baseurl=http://packages.vmware.com/tools/esx/5.0/rhel5/i386
#repo 	--name=vmware-tools-collection --baseurl=http://packages.vmware.com/tools/esx/5.0/rhel5/x86_64
 repo 	--name=vmware-tools-collection --baseurl=http://packages.vmware.com/tools/esx/latest/rhel5/x86_64/
###                                              http://packages.vmware.com/tools/esx/latest/rhel5/x86_64/
###                                              http://packages.vmware.com/tools/esx/4.1latest/rhel5/x86_64/

#---------------------------------------------------------------------------------------------------------------------

%packages
@base
@core
@development-libs
@development-tools
@legacy-software-support
@editors
@system-tools
@text-internet
keyutils
hardlink
x86info
device-mapper-multipath
fuse-libs
fuse
fuse-devel
imake
lsscsi
dtach
lslk
audit
net-snmp-utils
mc
iptraf
dstat
tftp
lynx
rsyslog
apr
apr-util
OpenIPMI-python
OpenIPMI-perl
OpenIPMI-tools
perl-XML-LibXML
perl-URI
compat-libstdc++-33
compat-gcc-34
compat-gcc-34-c++
util-linux
ksh
postgresql-libs
strace
procps
module-init-tools
ethtool
initscripts
bc
binutils
gcc
gcc-c++
glibc-common
glibc-headers
gdb
kernel-headers
libaio
libaio-devel
make
sysstat
elfutils-libelf-devel
unixODBC
unixODBC-devel
xorg-x11-xinit
xorg-x11-utils
gdbm
libXp
libgnome
libXtst
libgcc
libstdc++
libstdc++-devel
setarch
compat-db
sg3_utils
e4fsprogs
e4fsprogs-libs
-trousers
-fipscheck
-numactl
-NetworkManager
-rp-pppoe
-irda-utils
-ypbind
-bluez-utils
-valgrind
-subversion
-gcc-gfortran
-bluez-hcidump
-bluez-gnome
-slrn
-fetchmail
-mutt
-sysklogd
dvd+rw-tools 
mkisofs
yum-utils
yum-verify
yum-changelog
yum-kmod
yum-kernel-module
anaconda-runtime
libhbalinux
libnl
httpd
mysql
mysql-server

mod_auth_kerb
mod_perl
newt-perl
perl-BSD-Resource-1.28
perl-Compress-Zlib
perl-Convert-ASN1
perl-DBD-MySQL
perl-DBI
perl-IO-Socket-SSL
perl-LDAP
perl-libwww-perl
perl-libxml-perl
perl-Net-SSLeay
perl-Net-Telnet
perl-String-CRC32
perl-TimeDate
perl-URI
perl-XML-LibXML
perl-XML-Parser
perl-XML-SAX
perl-XML-Simple
### EPEL ###
#perl-Curses #fedora
#perl-HTML   #fedora
#perl-XML-XPathEngine

#vmware-tools
vmware-tools-esx-nox
vmware-tools-esx-kmods

#---------------------------------------------------------------------------------------------------------------------
%pre

#---------------------------------------------------------------------------------------------------------------------
%post
### ECHO ### disable IPv6
echo "options ipv6 disable=1"                         >>/etc/modprobe.d/disable-ipv6;
echo "export HISTTIMEFORMAT='%F %T ' >/dev/null 2>&1" >>/etc/profile.d/history-cfg.sh;
echo "export HISTSIZE=5000           >/dev/null 2>&1" >>/etc/profile.d/history-cfg.sh;

#no graphical grub
sed -i '/splashimage/d ' /boot/grub/menu.lst;
#no selinux
sed -i -e 's|^SELINUX=.*$|SELINUX=disabled|' /etc/selinux/config

KEY1='ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIBg6I6+W9i3q4hrHWN6jqE7ONZMqImw5Op+yAXRL9t8wF+plOI/609DPAUbLF2gkxIFnb05vYWePzuZrl5+zbNXET3TbOBjjskG6itFIvbQmYnCUrn8Oj2VfhdQBGC9s56Kgw8B9WlsCx7ZYcE7YP1v4yei6MylvCvDIWS7VLPKOQ== rsa-key-JoaoFontes@Blip'

install -d -m 700 /root/.ssh; touch /root/.ssh/authorized_keys2; chmod 600 /root/.ssh/authorized_keys2;
install -d -m 700 /root/.ssh; touch /root/.ssh/authorized_keys;  chmod 600 /root/.ssh/authorized_keys;
echo "$KEY1" >>/root/.ssh/authorized_keys;  
echo "$KEY1" >>/root/.ssh/authorized_keys2; 
if [ -d /home/joao.fontes ]; then
  install -d -m 700 /home/joao.fontes/.ssh; touch /home/joao.fontes/.ssh/authorized_keys2; chmod 600 /home/joao.fontes/.ssh/authorized_keys2;
  install -d -m 700 /home/joao.fontes/.ssh; touch /home/joao.fontes/.ssh/authorized_keys;  chmod 600 /home/joao.fontes/.ssh/authorized_keys;
  echo "$KEY1" >>/home/joao.fontes/.ssh/authorized_keys;  
  echo "$KEY1" >>/home/joao.fontes/.ssh/authorized_keys2; 
  chown -R joao.fontes /home/joao.fontes/.ssh
fi

echo 'set background=dark' >> /etc/vimrc
touch ~root/.vimrc; sed -i -e '/set background/d' ~root/.vimrc; echo 'set background=dark' >> ~root/.vimrc;

if [ -f /etc/sysconfig/snmpd.options ]; then 
  echo '# snmpd command line options'                               >/etc/sysconfig/snmpd.options;
  echo '# OPTIONS="-Lsd -Lf /dev/null -p /var/run/snmpd.pid -a"'   >>/etc/sysconfig/snmpd.options;
  echo 'OPTIONS="-Lf /var/log/snmpd.log -p /var/run/snmpd.pid -a"' >>/etc/sysconfig/snmpd.options;
fi

#iLO serial ports
echo -e 'ttyS0\nttyS1' >> /etc/securetty;
#echo    's0:2345:respawn:/sbin/agetty -L 38400,9600 ttyS0'>>/etc/inittab;
#echo    's1:2345:respawn:/sbin/agetty -L 38400,9600 ttyS1'>>/etc/inittab;

#sudo
sed -i -e '/Defaults[ \t]*requiretty/d ' /etc/sudoers;
echo '%wheel ALL =(ALL) NOPASSWD: ALL' >>/etc/sudoers;
echo '%admin ALL =(ALL) NOPASSWD: ALL' >>/etc/sudoers;

#echo 'root:!!'        | chpasswd -e;
echo 'joao.fontes:!!' | chpasswd -e;

echo 'PermitRootLogin without-password' >> /etc/ssh/sshd_config;
#sed -i -e 's|^PermitRootLogin.*|PermitRootLogin without-password|' /etc/ssh/sshd_config;

#ntlmssp requires KeepAlive On
[ -f /etc/httpd/conf/httpd.conf ] && sed -i -e 's|KeepAlive Off|KeepAlive On|' /etc/httpd/conf/httpd.conf;

#mysql configurations
#grep -c ^default-storage-engine /etc/my.cnf >/dev/null || \
#sed -i -e '/\[mysqld\]/ adefault-storage-engine=innodb'  /etc/my.cnf;
#grep -c ^default-table-type /etc/my.cnf >/dev/null || \
#sed -i -e '/\[mysqld\]/ atable-type=innodb'  /etc/my.cnf;
grep -c innodb_file_per_table /etc/my.cnf >/dev/null || \
sed -i -e '/\[mysqld\]/ ainnodb_file_per_table'  /etc/my.cnf;
sed -i -e 's|^old_passwords=.*|old_passwords=0|' /etc/my.cnf;

#chkconfig rsyslog on;
#---------------------------------------------------------------------------------------------------------------------

