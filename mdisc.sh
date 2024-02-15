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

  if [$DiscoExterno == 'null']; then
    Print_Style "Disco Externo = $DiscoExterno" "$RED"
    Print_Style "No hay punto de montaje - $GREEN Mounpoint = $MAGENTA $DiscoExterno" "$RED"
    sleep 2s

    DIRECTORIO=/mnt/storage
    if [ -d "${DIRECTORIO}" ]; then
      Print_Style "$CYAN El directorio $GREEN ${DIRECTORIO} $MAGENTA existe" "$REVERSE"
      sudo echo UUID="$MiUUID" /mnt/storage ntfs-3g defaults,auto 0 0 | \
      sudo tee -a /etc/fstab
      sudo mount -a
      echo "========================================================================="
      ls -l /mnt/storage
      echo "========================================================================="
    else
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
                    #  sudo apt remove docker.io docker-compose -y
                    #  sudo apt remove docker-ce -y
  fi
  Print_Style "SALTO DEL CODIGO ANTERIOR Disco Externo = $DiscoExterno ..." "$YELLOW"

else # No XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX response
  Print_Style "No se va a montar disxo Externo, configurando en: $GREEN $DirName" "$RED"
  sleep 3s
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
fi # Fin XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX response

Print_Style "SALTO DEL CODIGO ANTERIOR SI O NO ..." "$LIME_YELLOW"
#docker system prune -a
sudo rm -rf mdisc.sh


                      #  sudo umount /dev/sda1  
                      #  sudo nano /etc/fstab
                      #  sudo nano /etc/default/docker
                      #  sudo nano /etc/sudoers


