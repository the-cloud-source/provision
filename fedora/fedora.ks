lang en_US.UTF-8
keyboard pt-latin1
keyboard --vckeymap=pt --xlayouts='pt'
reboot --eject
firewall --service=ssh
firewall --disabled
firstboot --disable
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Etc/UTC

rootpw --iscrypted $1$00000000$ipUcSfN7NBVa7pqgFxjEi1
user --groups=wheel --name=fedora --password=$1$00000000$ipUcSfN7NBVa7pqgFxjEi1 --iscrypted --gecos="fedora"

sshkey --username=root   "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAzVXNSpI79JqVyqliWbeg3Qvvvz00NwnvzZQprsxNvw/nyDT1UoJNsaRNJ7zLU34Mdk8ZanvPY0UwrwmpB1o0Uuhf8erTLxBGA9HSqwo+BEOGJ1hLYXiFoRniTC4td0G53qsHkcladra/JEd8DzmZ5ynYjrgTYZ9SjWvrmE/IRm8= rsa-key-home"
sshkey --username=fedora "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAzVXNSpI79JqVyqliWbeg3Qvvvz00NwnvzZQprsxNvw/nyDT1UoJNsaRNJ7zLU34Mdk8ZanvPY0UwrwmpB1o0Uuhf8erTLxBGA9HSqwo+BEOGJ1hLYXiFoRniTC4td0G53qsHkcladra/JEd8DzmZ5ynYjrgTYZ9SjWvrmE/IRm8= rsa-key-home"


%packages
@^server-product-environment
podman
buildah
openconnect
vpnc-script

%end

