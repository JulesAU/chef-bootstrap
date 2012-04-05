#!/bin/sh

# Use it like this:
# curl https://raw.github.com/JulesAU/chef-bootstrap/master/bootstrap.sh | sudo bash

test -f ~ec2-user/.ssh/authorized_keys && cat ~ec2-user/.ssh/authorized_keys  > /root/.ssh/authorized_keys

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

yum install -y ruby ruby-devel ruby-ri ruby-rdoc ruby-shadow gcc gcc-c++ automake autoconf make curl dmidecode

cd /tmp
curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.21.tgz
tar zxf rubygems-1.8.21
cd rubygems-1.8.21
ruby setup.rb --no-format-executable
gem install chef --no-ri --no-rdoc
rm -rf /tmp/rubygems*