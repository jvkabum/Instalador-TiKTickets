#!/bin/bash
# 
# system management

#######################################
# creates user
# Arguments:
#   None
#######################################
system_create_user() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos criar o usuário para deploy...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  useradd -m -p $(openssl passwd $deploy_password) -s /bin/bash -G sudo deploy
  usermod -aG sudo deploy
  
EOF

  sleep 2
}

instalacao_firewall() {
  print_banner
  printf "${WHITE} 💻 Agora, vamos instalar e ativar firewall UFW...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 22
ufw allow 5432
ufw allow 80
ufw allow 443
ufw allow 9000
ufw --force enable
echo "{\"iptables\": false}" > /etc/docker/daemon.json
systemctl restart docker
sed -i -e 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/g' /etc/default/ufw
ufw reload
wget -q -O /usr/local/bin/ufw-docker https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
chmod +x /usr/local/bin/ufw-docker
ufw-docker install
systemctl restart ufw
EOF

  sleep 2
}

iniciar_firewall() {
  print_banner
  printf "${WHITE} 💻 Iniciando Firewall...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  service ufw start
  
EOF

  sleep 2
}

parar_firewall() {
  print_banner
  printf "${WHITE} 💻 Parando Firewall(atenção seu servidor ficara desprotegido)...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  service ufw stop
  
EOF

  sleep 2
}

#######################################
# set timezone
# Arguments:
#   None
#######################################
system_set_timezone() {
  print_banner
  printf "${WHITE} 💻 Setando timezone...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  timedatectl set-timezone America/Sao_Paulo
EOF

  sleep 2
}

#######################################
# unzip tiktickets
# Arguments:
#   None
#######################################
system_unzip_tiktickets() {
  print_banner
  printf "${WHITE} 💻 Baixando tiktickets...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  git clone ${repositorio} /home/deploy/${nome_instancia}
EOF

  sleep 2
}

#######################################
# updates system
# Arguments:
#   None
#######################################
system_update() {
  print_banner
  printf "${WHITE} 💻 Vamos atualizar o sistema...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt -y update && apt -y upgrade
  apt autoremove -y
  sudo ufw allow 443/tcp
  sudo ufw allow 80/tcp
EOF

  sleep 2
}

#######################################
# installs node
# Arguments:
#   None
#######################################
system_node_install() {
  print_banner
  printf "${WHITE} 💻 Instalando nodejs...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  apt-get install -y nodejs
EOF

  sleep 2
}

criar_banco_dados() {
  print_banner
  printf "${WHITE} 💻 Criano nova instancia do PostgreSQL...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
docker run --name postgresql-${nome_instancia} -e POSTGRES_USER=tiktickets -e POSTGRES_PASSWORD=${pg_pass} -e TZ="America/Sao_Paulo" -p ${porta_postgre_intancia}:5432 --restart=always -v /data:/var/lib/postgresql/data -d postgres

EOF

  sleep 2
}

#######################################
# installs docker
# Arguments:
#   None
#######################################
system_docker_install() {
  print_banner
  printf "${WHITE} 💻 Instalando docker...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
 sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
 apt install -y docker-ce
EOF

  sleep 2
}

#######################################
# Ask for file location containing
# multiple URL for streaming.
# Globals:
#   WHITE
#   GRAY_LIGHT
#   BATCH_DIR
#   PROJECT_ROOT
# Arguments:
#   None
#######################################
system_puppeteer_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando puppeteer dependencies...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
apt install -y ufw apt-transport-https ffmpeg fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 ca-certificates software-properties-common curl libgbm-dev wget unzip fontconfig locales gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils python2-minimal build-essential libxshmfence-dev nginx
EOF

  sleep 2
}

system_pm2_stop() {
  print_banner
  printf "${WHITE} 💻 Parando o tiktickets...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  pm2 stop all
EOF

  sleep 2
}

system_pm2_start() {
  print_banner
  printf "${WHITE} 💻 Iniciando o tiktickets...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - deploy <<EOF
  pm2 start all
EOF

  sleep 2
}

#######################################
# installs pm2
# Arguments:
#   None
#######################################
system_pm2_install() {
  print_banner
  printf "${WHITE} 💻 Instalando pm2...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  npm install -g pm2
  pm2 startup ubuntu -u deploy
  env PATH=\$PATH:/usr/bin pm2 startup ubuntu -u deploy --hp /home/deploy
EOF

  sleep 2
}

#######################################
# installs snapd
# Arguments:
#   None
#######################################
system_snapd_install() {
  print_banner
  printf "${WHITE} 💻 Instalando snapd...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt install -y snapd
  snap install core
  snap refresh core
EOF

  sleep 2
}

#######################################
# installs certbot
# Arguments:
#   None
#######################################
system_certbot_install() {
  print_banner
  printf "${WHITE} 💻 Instalando certbot...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt-get remove certbot
  snap install --classic certbot
  ln -s /snap/bin/certbot /usr/bin/certbot
EOF

  sleep 2
}

#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_nginx_install() {
  print_banner
  printf "${WHITE} 💻 Instalando nginx...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  rm /etc/nginx/sites-enabled/default
EOF

  sleep 2
}

#######################################
# install_chrome
# Arguments:
#   None
#######################################
system_set_user_mod() {
  print_banner
  printf "${WHITE} 💻 Vamos permisoes docker...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  sudo usermod -aG docker deploy
  su - deploy
EOF

  sleep 2
}

#######################################
# restarts nginx
# Arguments:
#   None
#######################################
system_nginx_restart() {
  print_banner
  printf "${WHITE} 💻 reiniciando nginx...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  service nginx restart
EOF

  sleep 2
}

#######################################
# setup for nginx.conf
# Arguments:
#   None
#######################################
system_nginx_conf() {
  print_banner
  printf "${WHITE} 💻 configurando nginx...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

sudo su - root << EOF

cat > /etc/nginx/conf.d/tikticketsio.conf << 'END'
client_max_body_size 100M;
large_client_header_buffers 16 5120k;
END

EOF

  sleep 2
}

#######################################
# installs nginx
# Arguments:
#   None
#######################################
system_certbot_setup() {
  print_banner
  printf "${WHITE} 💻 Configurando certbot...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  backend_domain=$(echo "${backend_url/https:\/\/}")
  frontend_domain=$(echo "${frontend_url/https:\/\/}")
  admin_domain=$(echo "${admin_url/https:\/\/}")

  sudo su - root <<EOF
  certbot -m $deploy_email \
          --nginx \
          --agree-tos \
          --non-interactive \
          --domains $backend_domain,$frontend_domain
EOF

  sleep 60
}

#######################################
# reboot
# Arguments:
#   None
#######################################
system_reboot() {
  print_banner
  printf "${WHITE} 💻 Reboot...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  reboot
EOF

  sleep 2
}

#######################################
# creates docker db
# Arguments:
#   None
#######################################
system_docker_start() {
  print_banner
  printf "${WHITE} 💻 Iniciando container docker...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  docker stop $(docker ps -q)
  docker container start postgresql
  docker container start redis-tiktickets
  docker container start rabbitmq
EOF

  sleep 2
}

#######################################
# creates docker db
# Arguments:
#   None
#######################################
system_docker_restart() {
  print_banner
  printf "${WHITE} 💻 Iniciando container docker...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  docker container restart portainer
  docker container restart postgresql
  docker exec -u root postgresql bash -c "chown -R postgres:postgres /var/lib/postgresql/data"
EOF

  sleep 10
}


arruma_permissao() {
  print_banner
  printf "${WHITE} 💻 Garantindo permissões usuario deploy...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  chown deploy.deploy /home/deploy/$(nome_instancia) -Rf
  
EOF

  sleep 2
}

apagar_distsrc() {
  print_banner
  printf "${WHITE} 💻 Apagando arquivos versao anterior${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/deploy/$(nome_instancia)/backend
  rm dist/ -Rf
  rm node_modules/ -Rf
  rm package.json -Rf
  rm package-lock.json -Rf
  cd /home/deploy/$(nome_instancia)/frontend  
  rm dist/ -Rf
  rm src/ -Rf
EOF

  sleep 2
}



#######################################
# creates final message
# Arguments:
#   None
#######################################
system_success() {
  print_banner
  printf "${GREEN} 💻 Instalação concluída com sucesso!${NC}\n\n"
  printf "${CYAN_LIGHT}"

  printf "✅ Usuário painel SaaS: super@tiktickets.io\n"
  printf "🔑 Senha: 123456\n\n"

  printf "✅ Usuário admin: admin@tiktickets.io\n"
  printf "🔑 Senha: 123456\n\n"

  printf "🌍 URL Frontend: https://$frontend_domain\n"
  printf "🔗 URL Backend: https://$backend_domain\n\n"

  printf "🖥️ Acesso ao Portainer: http://$frontend_domain:9000\n\n"

  printf "🔒 Senha Usuário Deploy: $deploy_password\n\n"

  printf "📦 Banco de Dados:\n"
  printf "   🏷️ Usuário: tiktickets\n"
  printf "   🗄️ Nome do Banco: postgres\n"
  printf "   🔑 Senha: $pg_pass\n\n"

  printf "💾 Senha do Redis: $redis_pass\n\n"

  printf "${NC}"
  
  sleep 2
}

