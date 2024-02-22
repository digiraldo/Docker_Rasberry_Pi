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
Print_Style "$NORMAL ==== $RED ==== $GREEN ==== $YELLOW ==== $LIME_YELLOW ==== $BLUE ==== $MAGENTA ==== $CYAN ==== $WHITE ==== $BRIGHT ==== $REVERSE ==== $UNDERLINE ==== $BLINK ==== $BLACK ====" "$NORMAL"
Print_Style "$NORMAL 0000 $RED 0000 $GREEN 0000 $YELLOW 0000 $LIME_YELLOW 0000 $BLUE 0000 $MAGENTA 0000 $CYAN 0000 $WHITE 0000 $BRIGHT 0000 $REVERSE 0000 $UNDERLINE 0000 $BLINK 0000 $BLACK 0000" "$NORMAL"
Print_Style "$NORMAL ==== $RED ==== $GREEN ==== $YELLOW ==== $LIME_YELLOW ==== $BLUE ==== $MAGENTA ==== $CYAN ==== $WHITE ==== $BRIGHT ==== $REVERSE ==== $UNDERLINE ==== $BLINK ==== $BLACK ====" "$NORMAL"

cd ~

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
echo "========================================================================="
echo "========================================================================="
sudo timedatectl
echo "========================================================================="
TZ=$(sudo cat /etc/timezone)
Print_Style "Zona Horaria Actual: $CYAN $TZ" "$GREEN"
echo "========================================================================="

read -r -p "Cambiar Zona Horaria? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    # Digitar Zona Horaria
    echo "========================================================================="
    Print_Style "Introduzca la Zona Horaria: " "$MAGENTA"
    Print_Style "Ejemplos:" "$YELLOW"
    Print_Style "America/Mexico_City" "$CYAN"
    Print_Style "America/Bogota" "$CYAN"
    read_with_prompt NewTZ "Introduzca Zona Horaria"
    echo "========================================================================="
    sleep 3s
    sudo timedatectl set-timezone $NewTZ
    TZN=$(sudo cat /etc/timezone)
    sleep 2s
    # ln -sfn /usr/share/zoneinfo/$NewTZ /etc/localtime
    Print_Style "Nueva Zona Horaria: $CYAN $TZN" "$NORMAL"
    sleep 2s
else
    Print_Style "Zona Horaria Actual: $CYAN $TZ" "$NORMAL"
fi


# Obtener la ruta del directorio de inicio el nombre de usuario iNFORMACION Detallada
Print_Style "================================================================================================" "$BLUE"
Print_Style "" "$BLUE"
SistemaOp=$(uname -s)
SisKernel=$(uname -r)
FecKernel=$(uname -v)
ArquiSis=$(uname -m)
InfoProc=$(uname -p)
NameDist=$(uname -o)
ArchOp=$(dpkg --print-architecture)
NameRed=$(uname -n)
InfoDet=$(uname -a)
Print_Style "------------------------------------------------------------------------------------------------" "$NORMAL"
Print_Style "|  Sistema Operativo:       |$MAGENTA $SistemaOp $BLINK$BLUE<==                                 " "$LIME_YELLOW"
Print_Style "------------------------------------------------------------------------------------------------" "$NORMAL"
Print_Style "|  Versión del Kernel:      |$MAGENTA $SisKernel $BLINK$BLUE<==                                 " "$LIME_YELLOW"
Print_Style "------------------------------------------------------------------------------------------------" "$NORMAL"
Print_Style "|  Fecha del Kernel:        |$MAGENTA $FecKernel $BLINK$BLUE<==                                 " "$LIME_YELLOW"
Print_Style "------------------------------------------------------------------------------------------------" "$NORMAL"
Print_Style "|  Arquitectura Procesador: |$MAGENTA $ArquiSis $BLINK$BLUE<==                                  " "$LIME_YELLOW"
Print_Style "------------------------------------------------------------------------------------------------" "$NORMAL"
Print_Style "|  Información Procesador:  |$MAGENTA $InfoProc $BLINK$BLUE<==                                  " "$LIME_YELLOW"
Print_Style "------------------------------------------------------------------------------------------------" "$NORMAL"
Print_Style "|  Nombre de Distribución:  |$MAGENTA $NameDist $BLINK$BLUE<==                                  " "$LIME_YELLOW"
Print_Style "------------------------------------------------------------------------------------------------" "$NORMAL"
Print_Style "|  Arquitectura:            |$MAGENTA $ArchOp $BLINK$BLUE<==                                    " "$LIME_YELLOW"
Print_Style "------------------------------------------------------------------------------------------------" "$NORMAL"
Print_Style "|  Nombre Red /etc/hostname |$MAGENTA $NameRed $BLINK$BLUE<==                                    " "$LIME_YELLOW"
Print_Style "------------------------------------------------------------------------------------------------" "$NORMAL"

Print_Style "" "$BLUE"
Print_Style "================================================================================================" "$BLUE"
Print_Style "Información Detallada:$RED $InfoDet                                                             " "$YELLOW"
Print_Style "================================================================================================" "$BLUE"
sleep 4s

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
sleep 2s

echo "========================================================================="
Print_Style "Creando grupo docker..." "$GREEN"
sleep 1s
VerGrupo=$(cut -d : -f 1 /etc/group | grep docker)
if [ $VerGrupo == "docker" ]; then
	echo "Exixte $VerGrupo"
  Print_Style "Agregando Usuario $YELLOW $UserName $CYAN al gruo docker y disk..." "$GREEN"
  sleep 1s
  Print_Style "Presione: $LIME_YELLOW Ctl+D $CYAN para seguir si esta en $MAGENTA root $BLINK Ctl+D" "$NORMAL"
  sudo usermod -aG docker $UserNow
  sudo newgrp docker
else
	echo "No Exixte $VerGrupo"
  sudo groupadd docker
  Print_Style "Agregando Usuario $YELLOW $UserName $CYAN al gruo docker y disk..." "$GREEN"
  sleep 1s
  Print_Style "Presione: $LIME_YELLOW Ctl+D $CYAN para seguir si esta en $MAGENTA root $BLINK Ctl+D" "$NORMAL"
  sudo usermod -aG docker $UserNow
  sudo newgrp docker
fi
#sudo gpasswd -a $UserName docker
# sudo usermod -a -G disk $UserName
# sudo newgrp docker

sleep 2s

Print_Style "================= VERSIONES DE DOCKER Y DOCKER-COMPOSE  =================" "$BLINK"
echo ""
echo "*************************************************************************"
sudo docker --version
echo "*************************************************************************"
sudo docker compose version
echo "*************************************************************************"
sleep 2s


echo "========================================================================="
echo -n "¿Desea Instalar Docker Y Docker Compose? (y/n)"
read answer < /dev/tty
if [ "$answer" != "${answer#[Yy]}" ]; then
  Print_Style "============================================================================" "$NORMAL"
  Print_Style "================== INSTALACIÓN DE DOCKER Y DOCKER-COMPOSE ==================" "$BLINK"
  Print_Style "============================================================================" "$NORMAL"
  cd ~
  sleep 2s

  echo "========================================================================="
  Print_Style "INSTALACIÓN DE DOCKER..." "$MAGENTA"
  echo "========================================================================="
  sleep 2s

  # Add Docker's official GPG key:
  sudo apt-get update
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sleep 3s

  sudo apt-get update

  echo "========================================================================="
  Print_Style "INSTALACIÓN DE DOCKER-COMPOSE..." "$MAGENTA"
  echo "========================================================================="
  sleep 2s

  sleep 2s
  # sudo apt-get update && sudo apt-get install -y --no-install-recommends docker-ce docker-compose
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  # sudo apt-get update
  # sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  echo "*************************************************************************"
  echo "========================================================================="
  sudo docker --version
  echo "========================================================================="
  echo "*************************************************************************"
  sleep 2s
  echo "*************************************************************************"
  echo "========================================================================="
  sudo docker compose version
  echo "========================================================================="
  echo "*************************************************************************"
  sleep 2s
fi




cd ~
# Contraseña del usuario que inicio seccion
echo "========================================================================="
Print_Style "Introduzca la contraseña del usuario: $CYAN $UserNow " "$MAGENTA"
read_with_prompt PasUsrNow "Password de usuario $UserNow"
echo "========================================================================="
sleep 3s
echo "========================================================================="
echo "========================================================================="

# Contraseña del usuario que inicio seccion
echo "========================================================================="
Print_Style "Introduzca la contraseña del usuario: $CYAN flexget " "$MAGENTA"
Print_Style "Contraseña predeterminada: $BLUE $PasUsrNow $YELLOW Presionando: Enter" "$RED"
read_with_prompt PassFlexget "Password de usuario flexget" $PasUsrNow
echo "========================================================================="
sleep 3s
echo "========================================================================="
echo "========================================================================="

Print_Style "Buscando discos y mostrando su UUID..." "$YELLOW"
sleep 1s
lsblk -o NAME,UUID,SIZE,FSTYPE,LABEL,MOUNTPOINT

echo "========================================================================="
read -r -p "Montar en Disco Externo? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then # Si XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX response
  Print_Style "Vamos a montar el disco Externo" "$GREEN"
  sleep 2s
  cd ~
  echo "========================================================================="
  Print_Style "MONTANDO DISCO EXTERNO..." "$RED"
  sleep 1s
  #   sudo mkdir -p externo
  #   sudo mount $Disco externo
  echo "========================================================================="
  echo "========================================================================="
  Print_Style "Buscando discos y mostrando su UUID..." "$YELLOW"
  sleep 1s
  lsblk -o NAME,UUID,SIZE,FSTYPE,LABEL,MOUNTPOINT
  echo "========================================================================="

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

  if [[ $DiscoExterno == null ]]; then # DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD Discoexterno null
    Print_Style "Disco Externo = $DiscoExterno" "$RED"
    Print_Style "No hay punto de montaje - $GREEN Mounpoint = $MAGENTA $DiscoExterno" "$RED"
    sleep 2s

    DIRECTORIO=/mnt/storage
    if [ -d "${DIRECTORIO}" ]; then  #  CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC Directorio Mountpoint
      Print_Style "$CYAN El directorio $GREEN ${DIRECTORIO} $MAGENTA existe" "$REVERSE"
      sudo echo UUID="$MiUUID" /mnt/storage ntfs-3g defaults,auto 0 0 | \
      sudo tee -a /etc/fstab
      sudo mount -a
      echo "========================================================================="
      ls -l /mnt/storage
      echo "========================================================================="
    else  # CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC Directorio Mountpoint
      echo "El directorio ${DIRECTORIO} no existe"
      Print_Style "$CYAN El directorio $GREEN ${DIRECTORIO} $YELLOW no existe" "$REVERSE"
      sudo mkdir /mnt/storage
      sudo chmod -R 765  $NameDisco
      sudo chmod -Rf 765 /mnt/storage
      sudo chmod -R 765 /etc/fstab

      sudo echo UUID="$MiUUID" /mnt/storage ntfs-3g defaults,auto 0 0 | \
      sudo tee -a /etc/fstab
      sudo mount -a
      echo "========================================================================="
      ls -l /mnt/storage
      echo "========================================================================="
    fi  # CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC Directorio Mountpoint

    SeeMountPoint=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r --arg uuid "$MiUUID" \
      '.blockdevices[] | .children[] | select(.uuid == $uuid)' \
      | jq -r '.mountpoint')
    
    # if [  -z "$SeeMountPoint" ]; then
    if [[ $SeeMountPoint == null ]]; then  #  MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM MountPoint Null
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
      sudo rm -rf docker-compose.yaml
      exit 0
    else  # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM MountPoint Null
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

      echo "Tomando .env del repositorio..."
      curl -H "Accept-Encoding: identity" -L -o .env https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/.env
      sudo chmod +x .env
      
      echo "=================================================================================="
      sleep 1s
      Print_Style "Configurando Id de Usuario        | $GREEN PUID=$PUID ..." "$CYAN"
      echo "=================================================================================="
      sudo sed -i "s:usuarioid:$PUID:g" .env

      sleep 1s
      Print_Style "Configurando Id de Grupo          | $GREEN PGID=$PGID ..." "$CYAN"
      echo "=================================================================================="
      sudo sed -i "s:grupoid:$PGID:g" .env

      sleep 1s
      Print_Style "Configurando Zona Horaria         | $GREEN TZ=$TZ ..." "$CYAN"
      echo "=================================================================================="
      sudo sed -i "s:timezona:$TZ:g" .env

      sleep 1s
      Print_Style "Configurando Nombre de Usuario a: | $GREEN $UserName ..." "$CYAN"
      echo "=================================================================================="
      sudo sed -i "s:usernaa:$UserName:g" .env

      sleep 1s
      Print_Style "Configurando Disco Externo        | $GREEN ${DIRECTORIO} ..." "$CYAN"
      echo "=================================================================================="
      #sudo sed -i "s:discc:$Disco:g" .env
      sudo sed -i "s:discomontadoext:${DIRECTORIO}:g" .env

      sleep 1s
      Print_Style "Configurando Password:            | $GREEN $PasUsrNow ..." "$CYAN"
      echo "=================================================================================="
      sudo sed -i "s:passwuser:$PasUsrNow:g" .env
      
      sleep 1s
      Print_Style "Configurando Password:            | $GREEN flexget ..." "$CYAN"
      echo "=================================================================================="
      sudo sed -i "s:passfleget:$PassFlexget:g" .env
      sleep 3s
      echo ""

  Print_Style "mostrando cambios en .env" "$BLUE"
  echo "========================================================================="
  echo ""
  sudo cat .env
  echo ""
  echo "========================================================================="  
  sleep 3s
    fi  # MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM MountPoint Null
  else # DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD Discoexterno null
    Print_Style "Disco Externo = $DiscoExterno" "$GREEN"
    Print_Style "Punto de Montaje encontrado - $CYAN Mounpoint = $YELLOW $SeeMountPoint" "$GREEN"
    sleep 2s
    sudo chmod -Rf 765 /etc/default/docker
    #  sudo echo 'export DOCKER_TMPDIR="$SeeMountPoint/docker-tmp"' >> /etc/default/docker
    #  sudo tee -a /etc/default/docker > "Texto a añadir al final del fichero"
    #  sudo sed -i 'export DOCKER_TMPDIR="$SeeMountPoint/docker-tmp"' /etc/default/docker
    echo "export DOCKER_TMPDIR=\"$DiscoExterno/docker-tmp\"" | sudo tee -a /etc/default/docker
    #  echo "export DOCKER_TMPDIR=\"\$SeeMountPoint/docker-tmp\"" >> -a fichero.txt
    Print_Style "=========================================================================" "$REVERSE"
    echo "========================================================================="
    sudo tail -n 1 /etc/default/docker
    echo "========================================================================="
    Print_Style "=========================================================================" "$REVERSE"
                    #  sudo umount /dev/sda1  
                    #  sudo nano /etc/fstab
                    #  sudo nano /etc/default/docker
                    #  sudo nano /etc/sudoers
                    #  sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
                    #  sudo rm -rf /var/lib/containerd                    
                    #  sudo rm -rf /var/lib/docker


  fi # DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD Discoexterno null
  # Print_Style "SALTO DEL CODIGO ANTERIOR Disco Externo = $DiscoExterno ..." "$YELLOW"

else # No XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX response

  Print_Style "No se va a montar disxo Externo, configurando en: $GREEN $DirName" "$RED"
  sleep 3s
  echo "Tomando docker-compose.yaml del repositorio..."
  curl -H "Accept-Encoding: identity" -L -o docker-compose.yaml https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/docker-compose.yaml
  sudo chmod +x docker-compose.yaml

  echo "Tomando .env del repositorio..."
  curl -H "Accept-Encoding: identity" -L -o .env https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/.env
  sudo chmod +x .env
  echo "=================================================================================="
  sleep 1s
  Print_Style "Configurando Id de Usuario        | $GREEN PUID=$PUID" "$CYAN"
  echo "=================================================================================="
  sudo sed -i "s:usuarioid:$PUID:g" .env

  sleep 1s
  Print_Style "Configurando Id de Grupo          | $GREEN PGID=$PGID" "$CYAN"
  echo "=================================================================================="
  sudo sed -i "s:grupoid:$PGID:g" .env

  sleep 1s
  Print_Style "Configurando Zona Horaria         | $GREEN TZ=$TZ" "$CYAN"
  echo "=================================================================================="
  sudo sed -i "s:timezona:$TZ:g" .env

  sleep 1s
  Print_Style "Configurando Nombre de Usuario a: | $GREEN $UserName" "$CYAN"
  echo "=================================================================================="
  sudo sed -i "s:usernaa:$UserName:g" .env

  sleep 1s
  Print_Style "Configurando Disco Externo        | $GREEN $DirName" "$CYAN"
  echo "=================================================================================="
  #sudo sed -i "s:discc:$Disco:g" .env
  sudo sed -i "s:discomontadoext:$DirName:g" .env

  sleep 1s
  Print_Style "Configurando Password:            | $GREEN $PasUsrNow" "$CYAN"
  echo "=================================================================================="
  sudo sed -i "s:passwuser:$PasUsrNow:g" .env

  sleep 1s
  Print_Style "Configurando Password:            | $GREEN flexget" "$CYAN"
  echo "=================================================================================="
  sudo sed -i "s:passfleget:$PassFlexget:g" .env
  sleep 3s
  echo ""

  Print_Style "mostrando cambios en .env" "$BLUE"
  echo "========================================================================="
  echo ""
  sudo cat .env
  echo ""
  echo "========================================================================="  
  sleep 3s
fi # Fin XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX response


echo "========================================================================="
Print_Style "Validando y Mostrando Configuracion del archivo yaml" "$CYAN"
sudo docker compose config
sleep 4s
echo "========================================================================="


Print_Style "================================ PROBANDO DOCKER COMPOSE ================================" "$RED"
sleep 1s
# crear
Print_Style "======================================= CREAR ===========================================" "$YELLOW"
sudo docker compose build


Print_Style "desplegar la aplicación docker-compose.yaml..." "$BLUE"
sleep 1s
sudo service docker start
sudo service docker compose start
Print_Style "===================================== DESCARGAR =========================================" "$YELLOW"
sudo docker compose pull

Print_Style "==================================================================================" "$YELLOW"
Print_Style "Construye, crea e inicia los servicios definidos en un archivo Docker Compose" "$CYAN"
sudo docker compose up -d
#     sudo docker compose up -d --force-recreate
Print_Style "==================================================================================" "$YELLOW"



echo "========================================================================="
echo -n "¿Configurar transmision y flexget moviendo archivos? (y/n)"
read answer < /dev/tty
if [ "$answer" != "${answer#[Yy]}" ]; then  # Configuracion Transmision y Flexget =================================
  echo "================================================================================="
  echo "====================== Configurando transmission y flexget ======================"
  echo "================================================================================="
  sleep 2s
  cd ~
  Print_Style "Deteniendo $RED transmission y flexget" "$YELLOW"
  sleep 2s
  sudo docker stop transmission
  sudo docker stop flexget
  echo "================================================================================="
  ls -l
  echo "================================================================================="

  echo "========================================================================="
  echo -n "¿Crear Directorio transmission? (y/n)"
  read answer < /dev/tty
  if [ "$answer" != "${answer#[Yy]}" ]; then
          Print_Style "Creando Directorio $YELLOW transmission $GREEN del Sistema" "$GREEN"
      cd ~
      sudo mkdir transmission
      sudo chmod -Rf 765 transmission
      sleep 2s
      sudo ls -l
  else
  echo "============================== TRANSMISSION ====================================="
  ls transmission
  echo "================================================================================="
  sleep 3s
  fi

  echo "========================================================================="
  echo -n "¿Crear Directorio flexget? (y/n)"
  read answer < /dev/tty
  if [ "$answer" != "${answer#[Yy]}" ]; then
          Print_Style "Creando Directorio $YELLOW flexget $GREEN del Sistema" "$GREEN"
      cd ~
      sudo mkdir flexget
      sudo chmod -Rf 765 flexget
      sleep 2s
      sudo ls -l
  else
  echo "================================== FLEXGET ======================================"
  ls flexget
  echo "================================================================================="
  sleep 3s
  fi

  cd ~
  cd transmission
  cd ~/transmission
  echo "================================================================================="
  pwd
  echo "================================================================================="
  sleep 2s
  Print_Style "Configurando settings.json de transmission" "$YELLOW"
  sleep 2s
  sudo cp settings.json settings.bak
  sudo rm -rf settings.json
  Print_Style "Se ha eliminado el fichero: $YELLOW settings.json" "$NORMAL"

  echo "Tomando settings.json del repositorio..."
  sudo curl -H "Accept-Encoding: identity" -L -o settings.json https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/transmission/settings.json
  sudo chmod +x settings.json

  cd ~
  cd flexget
  cd ~/flexget
  echo "================================================================================="
  pwd
  echo "================================================================================="
  sleep 2s
  Print_Style "Configurando config-trakt.yml de flexget" "$YELLOW"
  sleep 2s
  sudo cp config-trakt.yml config-trakt.bak
  sudo rm -rf config-trakt.yml
  Print_Style "Se ha eliminado el fichero: $YELLOW config-trakt.yml" "$NORMAL"

  echo "Tomando config-trakt.yml del repositorio..."
  sudo curl -H "Accept-Encoding: identity" -L -o config-trakt.yml https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/flexget/config-trakt.yml
  sudo chmod +x config-trakt.yml

  Print_Style "Configurando config.yml de flexget" "$YELLOW"
  sleep 2s
  sudo cp config.yml config.bak
  sudo rm -rf config.yml
  Print_Style "Se ha eliminado el fichero: $YELLOW config.yml" "$NORMAL"

  echo "Tomando config.yml del repositorio..."
  sudo curl -H "Accept-Encoding: identity" -L -o config.yml https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/flexget/config.yml
  sudo chmod +x config.yml

  cd ~
  cd flexget
  cd ~/flexget
  sudo mkdir custom-cont-init.d
  sudo chmod -Rf 765 custom-cont-init.d
  cd custom-cont-init.d
  echo "================================================================================="
  pwd
  echo "================================================================================="
  sleep 2s
  Print_Style "Configurando mediainfo.sh de flexget/custom-cont-init.d" "$YELLOW"
  sleep 2s
  sudo cp mediainfo.sh mediainfo.bak
  sudo rm -rf mediainfo.sh
  Print_Style "Se ha eliminado el fichero: $YELLOW mediainfo.sh" "$NORMAL"

  echo "Tomando mediainfo.sh del repositorio..."
  sudo curl -H "Accept-Encoding: identity" -L -o mediainfo.sh https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/flexget/custom-cont-init.d/mediainfo.sh
  sudo chmod +x mediainfo.sh

  Print_Style "Password de flexget: $YELLOW $PassFlexget" "$NORMAL"
  Print_Style "Password de transmission: $YELLOW 123456" "$NORMAL"
  sleep 2s

  cd ~
  Print_Style "Iniciando $GREEN transmission y flexget" "$YELLOW"
  sleep 2s
  sudo docker start transmission
  sudo docker start flexget

  Print_Style "Configurando Contraseña de flexger: $PassFlexget para interfaz web" "$YELLOW"
  sleep 2s
  docker exec flexget flexget web passwd $PassFlexget
  cd ~

  Print_Style "Reiniciando Docker" "$YELLOW"
  sleep 2s
  sudo service docker compose restart
  sudo service docker restart
else  # Configuracion Transmision y Flexget =================================

  sudo docker stop transmission
  echo "================================================================================="
  ls -l
  echo "================================================================================="

  echo "========================================================================="
  echo -n "¿Crear Directorio transmission? (y/n)"
  read answer < /dev/tty
  if [ "$answer" != "${answer#[Yy]}" ]; then
          Print_Style "Creando Directorio $YELLOW transmission $GREEN del Sistema" "$GREEN"
      cd ~
      sudo mkdir transmission
      sudo chmod -Rf 765 transmission
      sleep 2s
      ls
  else
  echo "============================== TRANSMISSION ====================================="
  ls transmission
  echo "================================================================================="
  sleep 3s

  cd ~
  cd transmission
  cd ~/transmission
  echo "================================================================================="
  pwd
  echo "================================================================================="
  sleep 2s
  Print_Style "Configurando settings.json de transmission" "$YELLOW"
  sleep 2s
  sudo cp settings.json settings.bak
  sudo rm -rf settings.json
  Print_Style "Se ha eliminado el fichero: $YELLOW settings.json" "$NORMAL"

  echo "Tomando settings.json del repositorio..."
  sudo curl -H "Accept-Encoding: identity" -L -o settings.json https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/transmission/settings.json
  sudo chmod +x settings.json

  Print_Style "Configurando Contraseña de flexger: $PassFlexget para interfaz web" "$YELLOW"
  sleep 2s
  docker exec flexget flexget web passwd $PassFlexget
  cd ~

  Print_Style "Reiniciando Docker" "$YELLOW"
  sleep 2s
  sudo service docker compose restart
  sudo service docker restart
fi  # Configuracion Transmision y Flexget =================================


Print_Style "==================================================================================" "$YELLOW"
sudo docker ps -a
Print_Style "==================================================================================" "$YELLOW"
Print_Style "Muestra el estado de los servicios definidos en un archivo Docker Compose" "$CYAN"
sudo docker compose ps
Print_Style "==================================================================================" "$YELLOW"
sudo docker images -a
Print_Style "========================================= VOLÚMENES =========================================" "$YELLOW"
sudo docker volume ls
Print_Style "==================================================================================" "$YELLOW"

# docker-compose down && docker-compose build --pull && docker-compose up -d
# sudo service transmission-daemon stop
# sudo service transmission-daemon start



#       sudo docker stop transmission
#       sudo docker start transmission

#docker system prune -a
sudo rm -rf dockerpi.sh  dockerpi.sh.1  dockerpi.sh.2 get-docker.sh settings.json


#   sudo find /mnt -name "Big Buck Bunny (2008).mp4"
#   sudo find . -name "Big Buck Bunny (2008).mp4"

# Desmontar disco
#            sudo umount /dev/sda1

# sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r --arg uuid "E0FE6879FE684A3C" \
# '.blockdevices[] | .children[] | select(.uuid == $uuid)'

# sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | select(.uuid == "E0FE6879FE684A3C")'
# Disco=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | select(.uuid == "E0FE6879FE684A3C")' | jq -r '.label')

# LabelName=$(sudo lsblk -p -o NAME,SIZE,FSTYPE,LABEL,UUID,MOUNTPOINT -J | jq -r '.blockdevices[] | .children[] | select(.uuid == "E0FE6879FE684A3C")' | jq -r '.label')
# echo "$LabelName"

# magnet:?xt=urn:btih:88594AAACBDE40EF3E2510C47374EC0AA396C08E&dn=bbb_sunflower_1080p_30fps_normal.mp4&tr=udp%3a%2f%2ftracker.openbittorrent.com%3a80%2fannounce&tr=udp%3a%2f%2ftracker.publicbt.com%3a80%2fannounce&ws=http%3a%2f%2fdistribution.bbb3d.renderfarming.net%2fvideo%2fmp4%2fbbb_sunflower_1080p_30fps_normal.mp4