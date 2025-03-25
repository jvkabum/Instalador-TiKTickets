#!/bin/bash
#
# Print banner art.

# As definições de cores ANSI foram removidas, pois já estão definidas em outros arquivos.



# Função para exibir o banner estilizado
print_banner() {
  clear  # Limpa a tela antes de exibir o banner

  printf "\n\n"
  printf "${GREEN}"  # Usando a variável já definida em outro arquivo

  # Exibindo o banner com texto estilizado
  printf "  _____   _   _      _____   _          _             _         \n"
  printf " |_   _| (_) | | __ |_   _| (_)   ___  | | __   ___  | |_   ___ \n"
  printf "   | |   | | | |/ /   | |   | |  / __| | |/ /  / _ \ | __| / __|\n"
  printf "   | |   | | |   <    | |   | | | (__  |   <  |  __/ | |_  \__ \ \n"
  printf "   |_|   |_| |_|\_\   |_|   |_|  \___| |_|\_\  \___|  \__| |___/ \n"
  printf "                                                                \n"

  printf "${NC}\n"  # Usando a variável já definida em outro arquivo
}

# Chamando a função para exibir o banner
print_banner

