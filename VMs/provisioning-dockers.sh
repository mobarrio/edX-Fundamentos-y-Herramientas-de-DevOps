#!/usr/bin/bash

# Habilita SSH remoto
echo "[TAREA 01] Habilitar la autenticacion via SSH"
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PrintMotd yes/PrintMotd no/g' /etc/ssh/sshd_config
sed -i 's/PrintLastLog yes/PrintLastLog no/g' /etc/ssh/sshd_config
systemctl restart sshd

# Set Root password
echo "[TAREA 02] Configurar la password de root: mjommc"
echo -e "mjommc\nmjommc" | passwd root >/dev/null 2>&1

# Desactiva SELinux
echo "[TAREA 03] Parando y deshabilitando el firewall"
systemctl stop firewalld && systemctl disable firewalld

# Desactiva SELinux
echo "[TAREA 04] Desactiva SELinux"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

# Limpia el motd
echo "[TAREA 05] Limpiando MOTD"
>/etc/motd 

# Actualiza e instala paqueteria adisional
echo "[TAREA 06] Actualizando el sistema operativo"
dnf update -y

echo "[TAREA 07] Instalando software adisional"
dnf install -y oracle-epel-release-el8
dnf config-manager --set-enabled ol8_developer_EPEL
dnf clean all
dnf install -y git jq curl wget net-tools dnf-utils sysstat tree stress redhat-lsb* lsof dnf-utils zip unzip dos2unix telnet nc
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
dnf install -y /tmp/google-chrome-stable_current_x86_64.rpm

# Instala y configura Postfix
echo "[TAREA 08] Instalando y configurando Postfix para envio de mails"
dnf install -y postfix
dnf remove -y sendmail
alternatives --set mta /usr/sbin/sendmail.postfix
systemctl enable --now postfix
yes|cp /vagrant/postfix/main.cf /etc/postfix/main.cf
chown root:root /etc/postfix/main.cf
chmod 644 /etc/postfix/main.cf
systemctl restart postfix

# Provisiona Dockers en la Infra
echo "[TAREA 09] Instalando Docker y Docker Compose"
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf remove -y runc
dnf install -y docker-ce --nobest
systemctl enable --now docker.service
systemctl status docker.service
curl -s -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Configurando TimeZone Europe/Madrid
echo "[TAREA 10] Configurando TimeZone Europe/Madrid"
timedatectl set-timezone Europe/Madrid

# Actualizando el /etc/hosts
echo "[TAREA 11] Actualizando el /etc/hosts"
cat >>/etc/hosts<<EOF
10.1.100.100   edx01 edx01.smoc.com.es
EOF

# Personalizacion del entorno
echo "[TAREA 12] Personalizacion del entorno"
cp /vagrant/update-motd.sh /etc/update-motd
chmod 755 /etc/update-motd
dos2unix /etc/update-motd
grep -qF 'update-motd' /etc/profile || echo "[ -x /etc/update-motd ] && /etc/update-motd" >>/etc/profile
grep -qxF "alias l='ls -la'" ~/.bashrc || echo "alias l='ls -la'" >>~/.bashrc
grep -qxF 'unalias ls' ~/.bashrc || echo "unalias ls" >>~/.bashrc


#Fresh Reboot
echo "[TAREA 13] Reboot del sistema"
reboot
