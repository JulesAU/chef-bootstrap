#!/bin/sh

# Use it like this:
# curl -L -s -o bootstrap.sh https://raw.github.com/JulesAU/chef-bootstrap/master/bootstrap.sh;  sudo bash bootstrap.sh

echo "Enter a URL from which we can fetch the authorized public SSH keys:"
read -e sshKeyUrl

test -f ~ec2-user/.ssh/authorized_keys && cat ~ec2-user/.ssh/authorized_keys  > /root/.ssh/authorized_keys && rm -f ~ec2-user/.ssh/authorized_keys

mkdir -p /root/.ssh
curl -s -L $sshKeyUrl > /root/.ssh/authorized_keys
chmod -R 700 /root/.ssh
restorecon -r -vv /root/.ssh

echo 'Protocol 2
SyslogFacility AUTHPRIV
PermitRootLogin yes
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes

AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS

X11Forwarding yes
PrintLastLog yes

Subsystem sftp /usr/libexec/openssh/sftp-server
' > /etc/ssh/sshd_config

service sshd reload
update-motd  --disable

yum install -y gcc gcc-c++ automake autoconf make curl dmidecode authconfig policycoreutils rsync libffi-devel

curl -L https://www.opscode.com/chef/install.sh | bash
