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


sudo rm -rf docker-compose.yaml

#echo=$TZ
#echo=$PUID
#echo=$PGID

# Instale las dependencias necesarias para ejecutar el servidor de Minecraft en segundo plano
Print_Style "Instalando dependencias..." "$CYAN"
if [ ! -n "`which sudo`" ]; then
  apt update && apt install sudo -y
fi
sudo apt update
sudo apt install ffmpeg -y
sudo add-apt-repository universe -y
sudo apt install git -y
sudo apt install jq -y
sudo apt-get install ntfs-3g -y
sudo apt install exfat-fusey -y
sudo apt-get install libfuse2 -y
#sudo apt-get install -y python python-pip

# Obtener la ruta del directorio de inicio y el nombre de usuario
DirName=$(readlink -e ~)
UserName=$(whoami)
UserNow=$(users)

Print_Style "INSTALACIÓN DE DOCKER..." "$MAGENTA"
sleep 2s
sudo curl -fsSL get.docker.com -o get-docker.sh && sh get-docker.sh

Print_Style "Creando grupo docker..." "$GREEN"
sleep 1s
sudo groupadd docker

Print_Style "Agregando Usuario $UserName al gruo docker..." "$GREEN"
sleep 1s
sudo gpasswd -a $UserName docker

sudo apt-get update

Print_Style "INSTALACIÓN DE DOCKER-COMPOSE..." "$MAGENTA"
sleep 2s
#sudo pip install docker-compose
sudo apt-get update && sudo apt-get install -y docker-ce docker-compose

Print_Style "==================================================================================" "$YELLOW"
Disco=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[0] | .children[] | .name')
Print_Style "==================================================================================" "$YELLOW"

Print_Style "MONTANDO DISCO EXTERNO..." "$RED"
sleep 2s
sudo mkdir -p externo
sudo mount $Disco externo
#sudo mount /dev/sda1 /mnt/sda1
sleep 1s
Print_Style "==================================================================================" "$YELLOW"
TZ=$(sudo cat /etc/timezone)
PUID=$(sudo id -u $UserName)
PGID=$(sudo id -g $UserName)
DiscoExterno=$(sudo lsblk -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[0] | .children[] | .mountpoint')
Print_Style "==================================================================================" "$YELLOW"

cd ~
# Buscando UID
# Descargar prop.sh desde el repositorio
echo "Tomando docker-compose.yaml del repositorio..."
curl -H "Accept-Encoding: identity" -L -o docker-compose.yaml https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/docker-compose.yaml
chmod +x docker-compose.yaml

sleep 1s
Print_Style "Configurando Id de Usuario PUID=$PUID ..." "$CYAN"
sudo sed -i "s:usuarioid:$PUID:g" docker-compose.yaml

sleep 1s
Print_Style "Configurando Id de Grupo PGID=$PGID ..." "$CYAN"
sudo sed -i "s:grupoid:$PGID:g" docker-compose.yaml

sleep 1s
Print_Style "Configurando Zona Horaria TZ=$TZ ..." "$CYAN"
sudo sed -i "s:timezona:$TZ:g" docker-compose.yaml

sleep 1s
Print_Style "Configurando Nombre de Usuario a: $UserName ..." "$CYAN"
sudo sed -i "s:usernaa:$UserName:g" docker-compose.yaml

sleep 1s
Print_Style "Configurando Disco Externo $DiscoExterno ..." "$CYAN"
#sudo sed -i "s:discc:$Disco:g" docker-compose.yaml
sudo sed -i "s:discomontadoext:$DiscoExterno:g" docker-compose.yaml
sleep 1s

Print_Style "mostrando cambios en docker-compose.yaml..." "$BLUE"
sudo cat docker-compose.yaml
sleep 3s

Print_Style "probando docker-compose..." "$BLUE"
sleep 1s
sudo docker-compose build

Print_Style "desplegar la aplicación docker-compose.yaml..." "$BLUE"
sleep 1s
docker-compose up

sudo rm -rf dockerpi.sh


Print_Style "==================================================================================" "$YELLOW"
sudo docker ps -a
Print_Style "==================================================================================" "$YELLOW"
sudo docker inspect
Print_Style "==================================================================================" "$YELLOW"