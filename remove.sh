#!/bin/bash
# Este Script es realizado por digiraldo

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

cd ~

Print_Style "Detectando Los Colores del Texto:" "$NORMAL"
Print_Style "$NORMAL 0000 $RED 0000 $GREEN 0000 $YELLOW 0000 $LIME_YELLOW 0000 $BLUE 0000 $MAGENTA 0000 $CYAN 0000 $WHITE 0000 $BRIGHT 0000 $REVERSE 0000 $UNDERLINE 0000 $BLINK 0000 $BLACK 0000" "$NORMAL"
Print_Style "$NORMAL ==== $RED ==== $GREEN ==== $YELLOW ==== $LIME_YELLOW ==== $BLUE ==== $MAGENTA ==== $CYAN ==== $WHITE ==== $BRIGHT ==== $REVERSE ==== $UNDERLINE ==== $BLINK ==== $BLACK ====" "$NORMAL"

cd ~
echo "========================================================================="
echo "Deteniendo Docker"
echo "========================================================================="
sudo service docker restart

FicheroDocker=docker-compose.yaml
echo "Buscando Fichero: $FicheroDocker"
sleep 2s

if [ -f $FicheroDocker ]
then
  echo "========================================================================="
  echo "El fichero $FicheroDocker existe"
  echo "========================================================================="
  sleep 2s
  sudo cp docker-compose.yaml docker-compose.bak
  sudo rm -rf docker-compose.yaml
  Print_Style "Se ha eliminado el fichero: $YELLOW $FicheroDocker" "$NORMAL"
else
  echo "========================================================================="
  echo "El fichero $FicheroDocker no existe"
  echo "========================================================================="
  sleep 2s
fi

Print_Style "Desmontando MointPoint $YELLOW /dev/sda1 $CYAN como disco externo" "$GREEN"
sudo umount /dev/sda1  
sleep 2s

Print_Style "Eliminando Linea $YELLOW /mnt/storage $GREEN de: $CYAN /etc/fstab" "$GREEN"
sudo sed -n "/\/mnt\/storage/p" /etc/fstab
sudo sed -i '/\/mnt\/storage/d' /etc/fstab
sleep 2s

Print_Style "Eliminando Linea $YELLOW mnt/storage/docker-tmp $GREEN de: $CYAN /etc/default/docker" "$GREEN"
sudo sed -n "/\/mnt\/storage\/docker-tmp/p" /etc/default/docker
sudo sed -i '/\/mnt\/storage\/docker-tmp/d' /etc/default/docker
sleep 2s

Print_Style "Eliminando Linea $YELLOW cem ALL=(ALL) NOPASSWD: ALL $GREEN de: $CYAN /etc/sudoers" "$GREEN"
sudo sed -n "/cem ALL=(ALL) NOPASSWD: ALL/p" /etc/sudoers
sudo sed -i '/cem ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
sleep 2s

Print_Style "Eliminando Linea $YELLOW sudo ALL=(ALL) NOPASSWD: ALL $GREEN de: $CYAN /etc/sudoers" "$GREEN"
sudo sed -n "/sudo ALL=(ALL) NOPASSWD: ALL/p" /etc/sudoers
sudo sed -i '/sudo ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers
sleep 2s


echo "========================================================================="
echo -n "¿Desea Desinstalar Docker? (y/n)"
read answer < /dev/tty
if [ "$answer" != "${answer#[Yy]}" ]; then
    echo "========================================================================="
    Print_Style "Removiendo Docker" "$YELLOW"
    echo "========================================================================="
    sleep 3s
    cd ~
    Print_Style "Desinstalando o purgando $YELLOW docker $GREEN del Sistema" "$GREEN"
    sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y
    sleep 2s
    # sudo rm -rf remove.sh
fi

sudo rm -rf dockerpi.sh  dockerpi.sh.1  dockerpi.sh.2 get-docker.sh docker-compose.bak flexget settings.json transmission  

echo "========================================================================="
echo -n "¿Desea Remover las librerias? (y/n)"
read answer < /dev/tty
if [ "$answer" != "${answer#[Yy]}" ]; then
    echo "========================================================================="
    Print_Style "Removiendo Librerias" "$YELLOW"
    echo "========================================================================="
    sleep 3s
    cd ~
    Print_Style "Eliminando Librerias de: $YELLOW /var/lib/containerd $GREEN y $CYAN $YELLOW /var/lib/docker" "$GREEN"
    sudo rm -rf /var/lib/containerd                    
    sudo rm -rf /var/lib/docker
    sleep 2s
    # sudo rm -rf remove.sh
fi

echo "========================================================================="
echo -n "¿Desea Instalar de Nuevo Docker Compose y archivos de configuración? (y/n)"
read answer < /dev/tty
if [ "$answer" != "${answer#[Yy]}" ]; then
    echo "========================================================================="
    Print_Style "Iniciando instalacion con dockerpi.sh" "$YELLOW"
    echo "========================================================================="
    sleep 3s
    cd ~
    echo "Tomando dockerpi.sh del repositorio..."
    curl -H "Accept-Encoding: identity" -L -o dockerpi.sh https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/dockerpi.sh
    sudo chmod +x dockerpi.sh
    /bin/bash ./dockerpi.sh
    # sudo rm -rf remove.sh
fi

sudo rm -rf remove.sh