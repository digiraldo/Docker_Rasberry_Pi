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


echo "========================================================================="
echo -n "¿Configurar flexget moviendo archivos? (y/n)"
read answer < /dev/tty
if [ "$answer" != "${answer#[Yy]}" ]; then  # Configuracion Transmision y Flexget =================================
  echo "================================================================================="
  echo "====================== Configurando Flexget ======================"
  echo "================================================================================="
  sleep 2s
  cd ~
  Print_Style "Deteniendo $RED Flexget" "$YELLOW"
  sleep 2s
  sudo docker stop flexget
  cd ~
  cd compose
  echo "================================================================================="
  ls -l
  echo "================================================================================="

  echo "========================================================================="
  echo -n "¿Crear Directorio flexget? (y/n)"
  read answer < /dev/tty
  if [ "$answer" != "${answer#[Yy]}" ]; then
    Print_Style "Creando Directorio $YELLOW flexget $GREEN del Sistema" "$GREEN"
    cd ~
    cd compose
    sudo mkdir flexget
    sudo chmod -Rf 765 flexget
    sleep 2s
    sudo ls -l
  else
  echo "================================== FLEXGET ======================================"
  sudo chmod -Rf 765 flexget
  ls flexget
  echo "================================================================================="
  sleep 3s
  fi

  cd ~
  cd compose/flexget
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
  cd compose/flexget
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

fi

echo "================================================================================="
echo "====================== Configurando Transmission ======================"
echo "================================================================================="
sleep 2s
cd ~
Print_Style "Deteniendo $RED Transmission" "$YELLOW"
sleep 2s
sudo docker stop transmission
cd ~
cd compose
echo "================================================================================="
ls -l
echo "================================================================================="

echo "========================================================================="
echo -n "¿Crear Directorio transmission? (y/n)"
read answer < /dev/tty
if [ "$answer" != "${answer#[Yy]}" ]; then
Print_Style "Creando Directorio $YELLOW transmission $GREEN del Sistema" "$GREEN"
cd ~
cd compose
sudo mkdir transmission
sudo chmod -Rf 765 transmission
sleep 2s
sudo ls -l
else
cd ~
cd compose
echo "============================== TRANSMISSION ====================================="
sudo chmod -Rf 765 transmission
ls transmission
echo "================================================================================="
sleep 3s
fi

cd ~
cd compose/transmission
# Buscar archivo don de se instal el json ================================================================================================================== OJO
cd ~
cd compose/transmission
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
Print_Style "Iniciando $GREEN transmission y flexget" "$YELLOW"
sleep 2s
sudo docker start transmission
