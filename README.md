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

## IMPORTANTE

Las raspberry son computadoras excelentes pero no muy potentes, y plex por defecto intenta transcodear los videos para ahorrar ancho de banda (en mi opinión, una HORRIBLE idea), y la chiquita raspberry no se aguanta este transcodeo "al vuelo", entonces hay que configurar los CLIENTES de plex (si, hay que hacerlo en cada cliente) para que intente reproducir el video en la máxima calidad posible, evitando transcodear y pasando el video derecho a tu tele o Chromecast sin procesar nada, de esta forma, yo he tenido 3 reproducciones concurrentes sin ningún problema. En android y iphone las opciones son muy similares, dejo un screenshot de Android acá:

<img src="https://i.imgur.com/F3kZ9Vh.png" alt="plex" width="400"/>
