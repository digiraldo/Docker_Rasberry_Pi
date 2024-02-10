#!/bin/bash
# Este Script es realizado por digiraldo
# Instalar: https://github.com/pablokbs/plex-rpi/tree/master

# Colores del terminal
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

# Imprime una línea con color usando códigos de terminal
Print_Style() {
  printf "%s\n" "${2}$1${NORMAL}"
}

# Función para leer la entrada del usuario con un mensaje
function read_with_prompt {
  variable_name="$1"
  prompt="$2"
  default="${3-}"
  unset $variable_name
  while [[ ! -n ${!variable_name} ]]; do
    read -p "$prompt: " $variable_name < /dev/tty
    if [ ! -n "`which xargs`" ]; then
      declare -g $variable_name=$(echo "${!variable_name}" | xargs)
    fi
    declare -g $variable_name=$(echo "${!variable_name}" | head -n1 | awk '{print $1;}')
    if [[ -z ${!variable_name} ]] && [[ -n "$default" ]] ; then
      declare -g $variable_name=$default
    fi
    echo -n "$prompt : ${!variable_name} -- aceptar? (y/n)"
    read answer < /dev/tty
    if [ "$answer" == "${answer#[Yy]}" ]; then
      unset $variable_name
    else
      echo "$prompt: ${!variable_name}"
    fi
  done
}
Print_Style "Detectando Los Colores del Texto:" "$NORMAL"
Print_Style "$NORMAL |||||| \
$BLACK |||||| \
$RED |||||| \
$GREEN |||||| \
$YELLOW |||||| \
$LIME_YELLOW |||||| \
$BLUE |||||| \
$MAGENTA |||||| \
$CYAN |||||| \
$WHITE |||||| \
$BRIGHT |||||| \
$BLINK |||||| \
$REVERSE |||||| \
$UNDERLINE |||||| \
" "$NORMAL"

Print_Style "$NORMAL |||||| \
$BLACK |||||| \
$RED |||||| \
$GREEN |||||| \
$YELLOW |||||| \
$LIME_YELLOW |||||| \
$BLUE |||||| \
$MAGENTA |||||| \
$CYAN |||||| \
$WHITE |||||| \
$BRIGHT |||||| \
$BLINK |||||| \
$REVERSE |||||| \
$UNDERLINE |||||| \
" "$NORMAL"

sleep 1s

# Obtener la ruta del directorio de inicio y el nombre de usuario
Print_Style "==================================================================================" "$YELLOW"
DirName=$(readlink -e ~)
UserName=$(whoami)
UserNow=$(users)
Print_Style "Nombre del Directorio: $GREEN $DirName" "$NORMAL"
Print_Style "Nombre de Usuario: $GREEN $UserName" "$NORMAL"
Print_Style "Nombre Usuario Actual: $GREEN $UserNow" "$NORMAL"
Print_Style "==================================================================================" "$YELLOW"
sleep 2s

echo "========================================================================="
Print_Style "Configurando Permisos..." "$YELLOW"
cd ~

echo "$UserNow"

sudo useradd $UserNow -G sudo

sudo sed -i '/$UserNow ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
sudo sed -i '$a $UserNow ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
sudo sed -n "/$UserNow ALL=(ALL) NOPASSWD: ALL/p" /etc/sudoers


sleep 2s

cd ~


curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
echo "deb [arch=armhf] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update && sudo apt-get install -y --no-install-recommends docker-ce docker-compose
sleep 2s

sudo docker --version
sudo docker-composer --version