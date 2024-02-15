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
Print_Style "$NORMAL ==== $BLACK ==== $RED ==== $GREEN ==== $YELLOW ==== $LIME_YELLOW ==== $BLUE ==== $MAGENTA ==== $CYAN ==== $WHITE ==== $BRIGHT ==== $BLINK ==== $REVERSE ==== $UNDERLINE ==== " "$NORMAL"
Print_Style "$NORMAL 0000 $BLACK 0000 $RED 0000 $GREEN 0000 $YELLOW 0000 $LIME_YELLOW 0000 $BLUE 0000 $MAGENTA 0000 $CYAN 0000 $WHITE 0000 $BRIGHT 0000 $BLINK 0000 $REVERSE 0000 $UNDERLINE 0000 " "$NORMAL"
Print_Style "$NORMAL ==== $BLACK ==== $RED ==== $GREEN ==== $YELLOW ==== $LIME_YELLOW ==== $BLUE ==== $MAGENTA ==== $CYAN ==== $WHITE ==== $BRIGHT ==== $BLINK ==== $REVERSE ==== $UNDERLINE ==== " "$NORMAL"

cd ~


FicheroDocker=docker-compose.yaml)

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

#echo=$TZ
#echo=$PUID
#echo=$PGID

# Instale las dependencias necesarias para ejecutar el servidor de Minecraft en segundo plano
#   sudo apt update && sudo apt full-upgrade
Print_Style "Instalando dependencias..." "$CYAN"
if [ ! -n "`which sudo`" ]; then
  sudo apt update && sudo apt install sudo -y
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
  wget \
  lsb-release \
  uidmap \
  libffi-dev \
  libssl-dev \
  python3-pip \
  ntfs-3g
  
#   sudo apt install ffmpeg -y
#   sudo add-apt-repository universe -y
#   sudo apt install git -y
#   sudo apt install jq -y
#   sudo apt-get install ntfs-3g -y
#   sudo apt install exfat-fusey -y
#   sudo apt-get install libfuse2 -y

TZ=$(sudo cat /etc/timezone)
Print_Style "Zona Horaria Actual: $CYAN $TZ" "$GREEN"


read -r -p "Cambiar Zona Horaria? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    # Digitar Zona Horaria
    echo "========================================================================="
    Print_Style "Introduzca la Zona Horaria: " "$MAGENTA"
    Print_Style "Ejemplos:" "$YELLOW"
    Print_Style "America/Mexico_City" "$NORMAL"
    Print_Style "America/Bogota" "$NORMAL"
    read_with_prompt NewTZ "Introduzca Zona Horaria"
    echo "========================================================================="
    sleep 3s
    sudo timedatectl set -timezone $NewTZ
    Print_Style "Zona Horaria: $CYAN $TZ" "$NORMAL"
    sleep 2s
else
    Print_Style "Zona Horaria: $CYAN $TZ" "$NORMAL"
fi



# Obtener la ruta del directorio de inicio y el nombre de usuario
Print_Style "==================================================================================" "$YELLOW"
SistemaOp=$(uname -s)
ArquiSis=$(uname -m)
Print_Style "Sistema Operativo: $BLUE $SistemaOp" "$NORMAL"
Print_Style "Arquitectura: $BLUE $ArquiSis" "$NORMAL"
Print_Style "==================================================================================" "$YELLOW"

Print_Style "==================================================================================" "$YELLOW"
DirName=$(readlink -e ~)
UserName=$(whoami)
UserNow=$(users)
Print_Style "Nombre del Directorio: $GREEN $DirName" "$NORMAL"
Print_Style "Nombre de Usuario: $GREEN $UserName" "$NORMAL"
Print_Style "Nombre Usuario Actual: $GREEN $UserNow" "$NORMAL"
Print_Style "==================================================================================" "$YELLOW"

PUID=$(sudo id -u $UserName)
PGID=$(sudo id -g $UserName)
TZ=$(sudo cat /etc/timezone)
Print_Style "Id de Usuario: $CYAN $PUID" "$NORMAL"
Print_Style "Id del Grupo: $CYAN $PGID" "$NORMAL"
Print_Style "Zona Horaria: $CYAN $TZ" "$NORMAL"
#DiscoExterno=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[0] | .children[] | .mountpoint')
Print_Style "==================================================================================" "$YELLOW"

# Disco=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | .name')
#LosUUID=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | .name, .uuid')
LosUUID=$(sudo lsblk -p -o NAME,UUID -J | jq -c '.blockdevices[] | .children[]')
# Print_Style "Nombre de los Discos" "$NORMAL"
# Print_Style "$Disco" "$BLUE"
Print_Style "Nobre y UUID de los Discos" "$NORMAL"
Print_Style "$LosUUID" "$BLUE"
Print_Style "==================================================================================" "$YELLOW"
sleep 2s

echo "========================================================================="
Print_Style "Configurando Permisos..." "$YELLOW"
cd ~
# UserName=$(whoami)
sudo useradd $UserName -G sudo
echo "$UserName ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
echo "sudo ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
sleep 1s


sleep 2s


Print_Style "INSTALACIÓN DE DOCKER Y DOCKER-COMPOSE..." "$NORMAL"
sleep 2s

Print_Style "INSTALACIÓN DE DOCKER..." "$MAGENTA"
sleep 2s

# curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
# sudo apt-key fingerprint 0EBFCD88
# echo "deb [arch=armhf] https://download.docker.com/linux/debian \
#     $(lsb_release -cs) stable" | \
#     sudo tee /etc/apt/sources.list.d/docker.list
# sleep 2s


sudo apt-get update

echo "========================================================================="
Print_Style "Creando grupo docker..." "$GREEN"
sleep 1s
VerGrupo=$(cut -d : -f 1 /etc/group | grep docker)
if [ $VerGrupo == "docker" ]; then
	echo "Exixte $VerGrupo"
  Print_Style "Agregando Usuario $YELLOW $UserName $CYAN al gruo docker y disk..." "$GREEN"
  sleep 1s
  Print_Style "Presione: $LIME_YELLOW Ctl+D $CYAN para seguir si esta en $MAGENTA root" "$NORMAL"
  sudo usermod -aG docker $UserNow
  sudo newgrp docker
else
	echo "No Exixte $VerGrupo"
  sudo groupadd docker
  Print_Style "Agregando Usuario $YELLOW $UserName $CYAN al gruo docker y disk..." "$GREEN"
  sleep 1s
  Print_Style "Presione: $LIME_YELLOW Ctl+D $CYAN para seguir si esta en $MAGENTA root" "$NORMAL"
  sudo usermod -aG docker $UserNow
  sudo newgrp docker
fi
#sudo gpasswd -a $UserName docker
# sudo usermod -a -G disk $UserName
# sudo newgrp docker
echo "========================================================================="

Print_Style "INSTALACIÓN DE DOCKER-COMPOSE..." "$MAGENTA"
sleep 2s

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
Executing docker install script, commit: 7cae5f8b0decc17d6571f9f52eb840fbc13b2737

# sudo apt-get update && sudo apt-get install -y --no-install-recommends docker-ce docker-compose

echo "========================================================================="
sudo docker --version
echo "========================================================================="
sleep 2s
echo "========================================================================="
sudo docker compose --version
echo "========================================================================="
sleep 2s

Print_Style "Buscando discos y mostrando su UUID..." "$YELLOW"
sleep 1s
lsblk -o NAME,UUID,SIZE,FSTYPE,LABEL,MOUNTPOINT

echo "========================================================================="
read -r -p "Montar en Disco Externo? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then # Si XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX response
    cd ~
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
    echo "========================================================================="
    sleep 3s
    NameDisco=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r --arg uuid "$MiUUID" \
    '.blockdevices[] | .children[] | select(.uuid == $uuid)' \
    | jq -r '.name')
    LabelName=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r --arg uuid "$MiUUID" \
    '.blockdevices[] | .children[] | select(.uuid == $uuid)' \
    | jq -r '.label')
    DiscoExterno=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r --arg uuid "$MiUUID" \
    '.blockdevices[] | .children[] | select(.uuid == $uuid)' \
    | jq -r '.mountpoint')
    sleep 1s
    Print_Style "UUID de Disco Seleccionado: $YELLOW $MiUUID" "$NORMAL"
    sleep 1s
    Print_Style "Nombre del Disco Seleccionado: $YELLOW $NameDisco" "$NORMAL"
    sleep 1s
    Print_Style "Etiqueta del Disco Seleccionado: $YELLOW $LabelName" "$NORMAL"
    sleep 1s
    Print_Style "Punto de Montaje: $YELLOW $DiscoExterno" "$NORMAL"
    sleep 1s
    echo "========================================================================="

    if [ $DiscoExterno == 'null' ]; then
      Print_Style "No hay punto de montaje - $GREEN Mounpoint = $MAGENTA $DiscoExterno" "$RED"
      sleep 2s

      DIRECTORIO=/mnt/storage

      if [ -d "${DIRECTORIO}" ]
      then
        Print_Style "$CYAN El directorio $GREEN ${DIRECTORIO} $MAGENTA existe" "$REVERSE"
        sudo echo UUID="$MiUUID" /mnt/storage ntfs-3g defaults,auto 0 0 | \
        sudo tee -a /etc/fstab
        sudo mount -a
        ls -l /mnt/storage
      else
        echo "El directorio ${DIRECTORIO} no existe"
        Print_Style "$CYAN El directorio $GREEN ${DIRECTORIO} $YELLOW no existe" "$REVERSE"
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
      fi

      SeeMountPoint=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r --arg uuid "$MiUUID" \
    '.blockdevices[] | .children[] | select(.uuid == $uuid)' \
    | jq -r '.mountpoint')

      if [ $SeeMountPoint == 'null' ]; then
        sudo lsblk -o NAME,UUID,SIZE,FSTYPE,LABEL,MOUNTPOINT
        sleep 2s
        # LabelName=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | select(.uuid == "$MiUUID")' | jq -r '.label')
        # echo "$LabelName"
        Print_Style "$CYAN MOUNTPOINT en $GREEN $LabelName $RED No Encontrado" "$REVERSE"
        sudo rm -rf dockerpi.sh  dockerpi.sh.1  dockerpi.sh.2
        Print_Style "Saliendo en:" "$CYAN"
        sleep 2s
        Print_Style "5 $MAGENTA ==============================" "$YELLOW"
        sleep 1s
        Print_Style "4 $MAGENTA ========================" "$YELLOW"
        sleep 1s
        Print_Style "3 $MAGENTA ==================" "$YELLOW"
        sleep 1s
        Print_Style "2 $MAGENTA ============" "$YELLOW"
        sleep 1s
        Print_Style "1 $MAGENTA ======" "$YELLOW"
        sleep 1s
        
        exit 0
      else
        Print_Style "Punto de Montaje encontrado - $CYAN Mounpoint = $YELLOW $SeeMountPoint" "$GREEN"
        Print_Style "=========================================================================" "$REVERSE"
        echo "========================================================================="
        sudo tail -n 1 /etc/fstab
        echo "========================================================================="
        Print_Style "=========================================================================" "$REVERSE"
        sleep 2s

        sudo chmod -Rf 765 /etc/default/docker
        #  sudo echo 'export DOCKER_TMPDIR="$SeeMountPoint/docker-tmp"' >> /etc/default/docker
        #  sudo tee -a /etc/default/docker > "Texto a añadir al final del fichero"
        #  sudo sed -i 'export DOCKER_TMPDIR="$SeeMountPoint/docker-tmp"' /etc/default/docker
        echo "export DOCKER_TMPDIR=\"$SeeMountPoint/docker-tmp\"" | sudo tee -a /etc/default/docker
        #  echo "export DOCKER_TMPDIR=\"\$DiscoExterno/docker-tmp\"" >> -a fichero.txt
        Print_Style "=========================================================================" "$REVERSE"
        echo "========================================================================="
        sudo tail -n 1 /etc/default/docker
        echo "========================================================================="
        Print_Style "=========================================================================" "$REVERSE"


        #       sudo service docker start
        echo "========================================================================="

        echo "Tomando docker-compose.yaml del repositorio..."
        curl -H "Accept-Encoding: identity" -L -o docker-compose.yaml https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/docker-compose.yaml
        sudo chmod +x docker-compose.yaml

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
        Print_Style "Configurando Disco Externo $SeeMountPoint ..." "$CYAN"
        #sudo sed -i "s:discc:$Disco:g" docker-compose.yaml
        sudo sed -i "s:discomontadoext:$SeeMountPoint:g" docker-compose.yaml
        sleep 1s

        Print_Style "mostrando cambios en docker-compose.yaml..." "$BLUE"
        sudo cat docker-compose.yaml
        sleep 3s


      fi


    else
      Print_Style "Punto de Montaje encontrado - $CYAN Mounpoint = $YELLOW $SeeMountPoint" "$GREEN"
      sleep 2s
      sudo chmod -Rf 765 /etc/default/docker
      #  sudo echo 'export DOCKER_TMPDIR="$SeeMountPoint/docker-tmp"' >> /etc/default/docker
      #  sudo tee -a /etc/default/docker > "Texto a añadir al final del fichero"
      #  sudo sed -i 'export DOCKER_TMPDIR="$SeeMountPoint/docker-tmp"' /etc/default/docker
      echo "export DOCKER_TMPDIR=\"$SeeMountPoint/docker-tmp\"" | sudo tee -a /etc/default/docker
      #  echo "export DOCKER_TMPDIR=\"\$SeeMountPoint/docker-tmp\"" >> -a fichero.txt
      Print_Style "=========================================================================" "$REVERSE"
      echo "========================================================================="
      sudo tail -n 1 /etc/default/docker
      echo "========================================================================="
      Print_Style "=========================================================================" "$REVERSE"
                      #  sudo umount /dev/sda1  
                      #  sudo nano /etc/fstab
                      #  sudo nano /etc/default/docker
                      #  sudo apt remove docker.io docker-compose -y
                      #  sudo apt remove docker-ce -y
    fi
else # No XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX response

    echo "Tomando docker-compose.yaml del repositorio..."
    curl -H "Accept-Encoding: identity" -L -o docker-compose.yaml https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/docker-compose.yaml
    sudo chmod +x docker-compose.yaml

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
    Print_Style "Configurando Disco Externo $DirName ..." "$CYAN"
    #sudo sed -i "s:discc:$Disco:g" docker-compose.yaml
    sudo sed -i "s:discomontadoext:$DirName:g" docker-compose.yaml
    sleep 1s

    Print_Style "mostrando cambios en docker-compose.yaml..." "$BLUE"
    sudo cat docker-compose.yaml
    sleep 3s

fi # Fin XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX response


echo "========================================================================="


Print_Style "probando docker-compose..." "$BLUE"
sleep 1s
sudo docker-compose build


Print_Style "desplegar la aplicación docker-compose.yaml..." "$BLUE"
sleep 1s
sudo service docker start
sudo service docker-compose start
Print_Style "==================================================================================" "$YELLOW"
sudo docker-compose pull
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



#docker system prune -a
sudo rm -rf dockerpi.sh  dockerpi.sh.1  dockerpi.sh.2 get-docker.sh


# Desmontar disco
#            sudo umount /dev/sda1

# sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r --arg uuid "E0FE6879FE684A3C" \
# '.blockdevices[] | .children[] | select(.uuid == $uuid)'

# sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | select(.uuid == "E0FE6879FE684A3C")'
# Disco=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | select(.uuid == "E0FE6879FE684A3C")' | jq -r '.label')

# LabelName=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | select(.uuid == "E0FE6879FE684A3C")' | jq -r '.label')
# echo "$LabelName"