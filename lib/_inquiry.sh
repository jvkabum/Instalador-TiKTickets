#!/bin/bash

software_update() {
  whatsappweb_update
}

instancia_instalar() {  # Renamed function
  system_unzip_tiktickets
  criar_banco_dados
  backend_set_env
  backend_node_dependencies
  backend_node_build
  backend_db_migrate
  backend_db_seed
  backend_start_pm2
  backend_nginx_setup
  frontend_set_env
  frontend_node_dependencies
  frontend_node_build
  frontend_serverjs
  frontend_start_pm2
  frontend_nginx_setup
  system_nginx_restart
  system_certbot_setup
  system_success
}

tiktickets_atualizar() {
  system_pm2_stop
  git_update
  backend_node_dependencies
  backend_node_build
  backend_db_migrate
  backend_db_seed
  restart_pm2
  frontend_node_dependencies
  frontend_node_build
}

tiktickets_atualizar1() {
  system_pm2_stop
  arruma_permissao
  apagar_distsrc
  git_update
  backend_node_dependencies
  backend_node_build
  backend_db_migrate
  system_pm2_start
  frontend_node_dependencies
  frontend_node_build
}

ativar_firewall () {
  iniciar_firewall
}

desativar_firewall () {
  parar_firewall
}

inquiry_options() {
  print_banner
  printf "${WHITE} 💻 O que você precisa fazer?${GRAY_LIGHT}\n\n"

  printf "   [1] 🛠️ Instalar\n"
  printf "   [2] 🔄 Atualizar TikTickets (⚠️ Recomenda-se criar um Snapshot da VPS antes)\n"
  printf "   [3] 🔄 Atualizar Conector WWebJS (whatsapp.js)\n"
  printf "   [4] 🔒 Ativar Firewall\n"
  printf "   [5] 🔓 Desativar Firewall\n"

  printf "\n"
  read -p "🔎 Escolha uma opção: " option

  case "${option}" in
    1) get_user_inputs ;;
    2) 
      get_user_inputs2
      tiktickets_atualizar1 
      exit

      ;;
    3) 
      software_update
      exit
      ;;

    6) 
      ativar_firewall 
      exit
      ;;
    7) 
      desativar_firewall 
      exit
      ;;
    *) exit ;;
  esac
}

get_user_inputs() {
  clear
  print_banner
  read -p "📧 Digite seu email para deploy: " deploy_email

  clear
  print_banner
  read -p "🔗 Digite o repositório: ( https://github.com/jvkabum/Instalador-TiKTickets.git ) " repositorio

  clear
  print_banner
  read -p "🏷️ Digite o nome da instância (Somente minusculo sem espaços e caracteres): " nome_instancia

  clear
  print_banner
  read -p "🐘 Digite a porta do PostgreSQL (Ex: 5400 a 5500): " porta_postgre_instancia

  clear
  print_banner
  read -p "🌍 Digite a URL do frontend: " frontend_url

  clear
  print_banner
  read -p "🚪 Digite a porta do frontend (Ex: 4000 á 4100): " frontend_porta

  clear
  print_banner
  read -p "🔗 Digite a URL do backend: " backend_url

  clear
  print_banner
  read -p "🚪 Digite a porta do backend (Ex: 5000 á 5100): " backend_porta

  clear
  print_banner
}

get_user_inputs2() {
  clear
  print_banner
  read -p "🏷️ Digite o nome da instância já instalada (Somente minusculo sem espaços e caracteres): " nome_instancia
}
