#!/bin/bash

# Script de configuração segura do SSH no Ubuntu Server
# Autor: André
# Uso: wget https://github.com/SEU_USUARIO/SEU_REPO/raw/main/setup_ssh_seguro.sh && bash setup_ssh_seguro.sh

echo "🔧 Iniciando configuração segura do SSH..."

# 1. Atualiza pacotes e instala o servidor SSH e firewall
sudo apt update && sudo apt install openssh-server ufw -y

# 2. Ativa o serviço SSH
sudo systemctl enable ssh
sudo systemctl start ssh

# 3. Cria diretório para chaves
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 4. Solicita colagem da chave pública
echo "🔑 Por favor, cole agora a CHAVE PÚBLICA (do tipo id_ed25519.pub) neste terminal:"
echo "(Depois pressione Ctrl+O, Enter e Ctrl+X para salvar)"
sleep 2
nano ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# 5. Faz backup da configuração original
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# 6. Aplica configurações seguras
sudo sed -i 's/^#*Port .*/Port 2222/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config

# 7. Garante que as configurações existam no arquivo (se não estavam presentes)
grep -q "^Port 2222" /etc/ssh/sshd_config || echo "Port 2222" | sudo tee -a /etc/ssh/sshd_config
grep -q "^PermitRootLogin no" /etc/ssh/sshd_config || echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config
grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config || echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config

# 8. Configura o firewall para permitir a nova porta
sudo ufw allow 2222/tcp
sudo ufw --force enable

# 9. Reinicia o SSH
sudo systemctl restart ssh

# 10. Fim
echo ""
echo "✅ SSH configurado com sucesso!"
echo "🔐 Agora você pode conectar com:"
echo "ssh -i ~/.ssh/id_ed25519 -p 2222 USUARIO@IP_DO_SERVIDOR"

