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

Print_Style "Detectando Los Colores del $GREEN Texto" "$MAGENTA"

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

Print_Style "Instalar paquetes necesarios" "$CYAN"
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common \
  vim \
  fail2ban \
  jq \
  ntfs-3g
#   sudo apt install ffmpeg -y
#   sudo add-apt-repository universe -y
#   sudo apt install git -y
#   sudo apt install jq -y
#   sudo apt-get install ntfs-3g -y
#   sudo apt install exfat-fusey -y
#   sudo apt-get install libfuse2 -y


# Obtener la ruta del directorio de inicio y el nombre de usuario
DirName=$(readlink -e ~)
UserName=$(whoami)
UserNow=$(users)

Print_Style "INSTALACIÓN DE DOCKER Y DOCKER-COMPOSE..." "$MAGENTA"
sleep 2s
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
echo "deb [arch=armhf] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update && sudo apt-get install -y --no-install-recommends docker-ce docker-compose
echo "========================================================================="

Print_Style "Creando grupo docker..." "$GREEN"
sleep 1s
sudo groupadd docker
echo "========================================================================="

Print_Style "Agregando Usuario $UserName al gruo docker..." "$GREEN"
sleep 1s
#sudo gpasswd -a $UserName docker
sudo usermod -a -G docker $UserName
echo "========================================================================="

sudo apt-get update


Print_Style "==================================================================================" "$YELLOW"
Disco=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[0] | .children[] | .name')
LosUUID=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | .name, .uuid')
Print_Style "==================================================================================" "$YELLOW"

sleep 1s
Print_Style "==================================================================================" "$YELLOW"
TZ=$(sudo cat /etc/timezone)
PUID=$(sudo id -u $UserName)
PGID=$(sudo id -g $UserName)
#DiscoExterno=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[0] | .children[] | .mountpoint')
Print_Style "==================================================================================" "$YELLOW"



Print_Style "MONTANDO DISCO EXTERNO..." "$RED"
sleep 1s
#   sudo mkdir -p externo
#   sudo mount $Disco externo
Print_Style "Buscando discos y mostrando su UUID..." "$YELLOW"
sleep 1s
lsblk -o NAME,UUID,SIZE,FSTYPE,LABEL,MOUNTPOINT

# Digitar el UUID del disco
echo "========================================================================="
Print_Style "Introduzca el UUID de la unidad a montar: " "$MAGENTA"
read_with_prompt MiUUID "UUID de disco a montar"
echo "=============================$MiUUID============================================"

NameDisco=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | select(.uuid == "$MiUUID")' | jq -r '.name')
#echo "$NameDisco"
sudo mkdir /mnt/storage
sudo chmod -R 765 /sbin/mount.ntfs-3g /usr/bin/ntfs-3g
sudo chmod +s /bin/ntfs-3g
sudo chmod -R 765  $NameDisco
sudo chmod -R 765 /mnt/storage
sudo chmod -R 765 /etc/fstab
sudo chmod -R 765 `which ntfs-3g`
sudo chown root $(which ntfs-3g)
sudo chmod 4755 $(which ntfs-3g)
sudo echo UUID="$MiUUID" /mnt/storage ntfs-3g defaults,auto 0 0 | \
  sudo tee -a /etc/fstab
mount -a
ls -l /mnt/storage
sleep 1s

cd ~

DiscoExterno=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r --arg uuid "$MiUUID" \
'.blockdevices[] | .children[] | select(.uuid == $uuid)' \
| jq -r '.mountpoint')
if [ $DiscoExterno == null ]
then
	Print_Style "No hay punto de montaje - $GREEN Mounpoint = $DiscoExterno" "$RED"
  sleep 2s
else
	Print_Style "Punto de Montaje encontrado - $BLUE Mounpoint = $DiscoExterno" "$GREEN"
  sleep 2s

Print_Style "Detectando Disco montado en: $GREEN $DiscoExterno" "$CYAN"

sleep 2s
echo 'export DOCKER_TMPDIR="$DiscoExterno/docker-tmp"' >> /etc/default/docker
#  sed -i '$a Aqui el texto que ira en la ultima linea' archivo.txt
#  sudo nano /etc/default/docker

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
Print_Style "==================================================================================" "$YELLOW"
sudo docker-compose up -d
Print_Style "==================================================================================" "$YELLOW"
sudo docker ps -a
Print_Style "==================================================================================" "$YELLOW"
sudo docker-compose ps
Print_Style "==================================================================================" "$YELLOW"
sudo docker images -a
Print_Style "==================================================================================" "$YELLOW"
sudo docker volume ls
Print_Style "==================================================================================" "$YELLOW"

fi
#docker system prune -a
sudo rm -rf dockerpi.sh



# sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r --arg uuid "E0FE6879FE684A3C" \
# '.blockdevices[] | .children[] | select(.uuid == $uuid)'

# sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | select(.uuid == "E0FE6879FE684A3C")'



