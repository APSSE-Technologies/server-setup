#!/bin/bash

# Script de configuração segura do SSH no Ubuntu Server
# Autor: André
# Uso: wget https://github.com/APSSE-Technologies/server-setup/raw/main/setup_ssh.sh && bash setup_ssh.sh

echo "🔧 Iniciando configuração segura do SSH..."

# 1. Atualiza pacotes e instala SSH + firewall
sudo apt update && sudo apt install openssh-server ufw -y

# 2. Ativa e inicia o serviço SSH
sudo systemctl enable ssh
sudo systemctl start ssh

# 3. Cria diretório .ssh com permissões corretas
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 4. Baixa chave pública diretamente do GitHub
echo "🌐 Baixando chave pública de André..."
wget -O ~/.ssh/authorized_keys https://raw.githubusercontent.com/APSSE-Technologies/server-ssh-key/main/andre.pub
chmod 600 ~/.ssh/authorized_keys

# 5. Faz backup do arquivo original
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# 6. Aplica configurações seguras
sudo sed -i 's/^#*PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config

# 7. Garante que as diretivas existam
grep -q "^PermitRootLogin no" /etc/ssh/sshd_config || echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config
grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config

# 8. Configura o firewall
sudo ufw allow 22/tcp
sudo ufw --force enable

# 9. Reinicia o serviço SSH
sudo systemctl restart ssh

# 10. Fim
echo ""
echo "✅ SSH configurado com sucesso!"
echo "🔐 Agora você pode conectar com:"
echo "ssh -i ~/.ssh/id_ed25519 -p 22 andre@170.xxx.xxx.xx"

