# Docker_Rasberry_Pi
Instalar Docker y Docker Compose en Rasberry con disco duro externo

Instalar Docker en Linux Server RPI
```
wget https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/dockerpi.sh
chmod +x dockerpi.sh
./dockerpi.sh
```

Quitar o Desinstalar Docker con Archivos montados anteriormente
```
wget https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/remove.sh
chmod +x remove.sh
./remove.sh
```

Prueba de Configuracion de Archivo docker-compose.yaml
```
wget https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/dock.sh
chmod +x dock.sh
./dock.sh
```

Prueba de Instalación de Docker y Docker-Composer
```
wget https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/dck.sh
chmod +x dck.sh
./dck.sh
```

Montar disco Externo
```
wget https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/mdisc.sh
chmod +x mdisc.sh
./mdisc.sh
```

Configurar FlexGet y Transmision
```
wget https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/transmision.sh
chmod +x transmision.sh
./transmision.sh
```

Configurar FlexGet y Transmision en OMV Debian
```
wget https://raw.githubusercontent.com/digiraldo/Docker_Rasberry_Pi/main/transmissionopv.sh
chmod +x transmissionopv.sh
./transmissionopv.sh
```

## IMPORTANTE

Las raspberry son computadoras excelentes pero no muy potentes, y plex por defecto intenta transcodear los videos para ahorrar ancho de banda (en mi opinión, una HORRIBLE idea), y la chiquita raspberry no se aguanta este transcodeo "al vuelo", entonces hay que configurar los CLIENTES de plex (si, hay que hacerlo en cada cliente) para que intente reproducir el video en la máxima calidad posible, evitando transcodear y pasando el video derecho a tu tele o Chromecast sin procesar nada, de esta forma, yo he tenido 3 reproducciones concurrentes sin ningún problema. En android y iphone las opciones son muy similares, dejo un screenshot de Android acá:

<img src="https://i.imgur.com/F3kZ9Vh.png" alt="plex" width="400"/>



### Utilizar sudo en usuario (ejemplo usuario: di) en Debian 

```
su -
```
```
apt-get install sudo -y
```
```
usermod -aG sudo di
```
```
id di
```

### Como evitar que se suspenda o apague una notebook para poder utilizarla como servidor y aprovechar un equipo en desuso. 

editar archivo sudo nano /etc/systemd/logind.conf
Y modificar las siguientes entradas asegurando que "ignore" se la configuración en cada una de ellas. 
```
sudo nano /etc/systemd/logind.conf
```
```
  HandleLidSwitch:ignore
  HandleLidSwitchExternalPoweroutlet:ignore
  HandleLidSwitchDocked:ignore
```
```
  HandleLidSwitch=ignore
  HandleLidSwitchExternalPoweroutlet=ignore
  HandleLidSwitchDocked=ignore
```

Mensaje
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```
ssh-keygen -R <host>
```
```
ssh-keygen -R diserver
```
