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

sudo apt install jq -y

#sudo apt-get install -y python python-pip

# Obtener la ruta del directorio de inicio y el nombre de usuario
DirName=$(readlink -e ~)
UserName=$(whoami)
UserNow=$(users)

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

cd ~

DiscoExterno=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r --arg uuid "$MiUUID" \
'.blockdevices[] | .children[] | select(.uuid == $uuid)' \
| jq -r '.mountpoint')

if [ $DiscoExterno == null ]
then
	Print_Style "No hay punto de montaje - $GREEN Mounpoint = $MAGENTA $DiscoExterno" "$RED"
  sleep 2s
  sudo mkdir /mnt/storage
  #   sudo chmod -R 765 /sbin/mount.ntfs-3g /usr/bin/ntfs-3g
  #   sudo chmod +s /bin/ntfs-3g
  sudo chmod -R 765  $NameDisco
  sudo chmod -Rf 765 /mnt/storage
  sudo chmod -R 765 /etc/fstab

  sudo echo UUID="$MiUUID" /mnt/storage ntfs-3g defaults,auto 0 0 | \
    sudo tee -a /etc/fstab
  sudo mount -a
  ls -l /mnt/storage
  sleep 1s

  Print_Style "Detectando Disco montado en: $GREEN $DiscoExterno" "$CYAN"

  sleep 2s
  sudo chmod -Rf 765 /etc/default/docker
  #  sudo echo 'export DOCKER_TMPDIR="$DiscoExterno/docker-tmp"' >> /etc/default/docker
  sudo sed -i 'export DOCKER_TMPDIR="$DiscoExterno/docker-tmp"' /etc/default/docker
  #  sudo nano /etc/default/docker

else
	Print_Style "Punto de Montaje encontrado - $BLUE Mounpoint = $YELLOW $DiscoExterno" "$GREEN"
  sleep 2s

fi

cd ~

DiscoExterno=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r --arg uuid "$MiUUID" \
'.blockdevices[] | .children[] | select(.uuid == $uuid)' \
| jq -r '.mountpoint')
if [ $DiscoExterno == null ]
then
	Print_Style "No hay punto de montaje - $GREEN Mounpoint = $MAGENTA $DiscoExterno" "$RED"
  Print_Style "Saliendo en:" "$CYAN"
  sleep 2s
  Print_Style "5 -----" "$RED"
  sleep 1s
  Print_Style "4 ----:" "$RED"
  sleep 1s
  Print_Style "3 ---:" "$RED"
  sleep 1s
  Print_Style "2 --:" "$RED"
  sleep 1s
  Print_Style "1 -:" "$RED"
  sleep 1s
  exit
else
	Print_Style "Punto de Montaje encontrado - $BLUE Mounpoint = $YELLOW $DiscoExterno" "$GREEN"
  sleep 2s
fi



#docker system prune -a
sudo rm -rf mdisc.sh


# Desmontar disco
#            sudo umount /dev/sda1
# Eliminar ultima linea
#            sudo nano /etc/fstab