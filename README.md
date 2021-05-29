# Automated Media Server (Docker-Compose)

This is my configuration for my personal home media server installation using `docker-compose`. If you want to acheive something similar, feel free to fork and modify this repository as required. Also, if you notice anything that could be improved or fixed, please create an issue or contact me so I can be aware of it. Thanks :)

## Requirements

This project has a small number of requirements to run successfully

- Docker ([More Info](https://www.docker.com/get-started))
- Docker-Compose ([More Info](https://docs.docker.com/compose/))
- Availability of self-signed or publicly trusted SSL certificates from a CA.
- `root` or `sudo` access on your machine

> Note: If you do not wish to use SSL/TLS with your instance, you may simply, delete `HTTPS Settings` from `./nginx/conf.d/nginx.conf`. and remove port `443` from `./docker-compose.yml`. This will prevent the unwanted use of HTTPS on your instance.

## HTTPS Setup Instructions

Setting up your instance to use HTTPS requires a few extra steps to get started.

Start by creating your SSL certificates on your machine. You may store them whereever you wish, but this may require you to modify the volume mounts to point to such locations in the `webserver` portion of your `docker-compose` file. As a `sudoer` you can do this with the following command

```bash

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

```

> This command will ask you for some input. It is important that you enter valid information and particularly when it asks you for your **FQDN** or **Common Name** you must enter your public IP address (local IP address if on LAN) or your Domain name (such as **sykeshome.io** for me)

Once you have your SSL certificates created, it is best practice to also create a strong Diffie-Hellman group. You can do so with the following command

```bash

sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

```

> Note: This may take a few moments...

Once this is done, you are ready to specify the locations in your `docker-compose` file in `volumes` (volume mounts) to point to the locations of your certs and private keys. If you used the commands provided in this document, you **shouldn't** have to change anything.

## Start the services

After you have completed the setup steps above, you are ready to go. Copy this compose file or use the compose that comes with this repository. 

> Remember to note some changes that are possible or required as stated in the `HTTPS Setup Instructions` if you are using HTTPS in your setup.

``` yml

version: "3.4"

# Include all required services configuration
# Ensure a few things are modified:
# 1. ENV vars
# 2. Volume mounts (for where you would like volumes mounted on your host)
# 3. Decide if you would like to mount /config on each service so you can keep a copy on your host of the config and make changes manually if necessary (outside of container)

services:
  # Front-end jellyfin (reverse-proxy)
  webserver:
    container_name: webserver
    image: nginx:mainline-alpine
    volumes:
      - web-root:/var/www/html # Volume mount for web-root (optional)
      - ./nginx/conf.d:/etc/nginx/conf.d # Volume mount for nginx config folder (required)
      - ./nginx/snippets:/snippets # Volume mount for some nginx config snippets (required)
      - /etc/ssl/certs:/ssl/certs # Volume mount for SSL certificates, including dhparam (required)
      - /etc/ssl/private/:/ssl/private # Volume mount for private keys (required)
    depends_on:
      - jellyfin
      - ombi
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped
    networks:
      - media-server-network
  # NOTE: There are no ports specified for this service since it is accessible using provided nginx configuration
  ombi:
    image: linuxserver/ombi
    container_name: ombi
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New York
    volumes:
      - /home/ben/mediaserver/ombi:/config # Change volume mount for config files
    networks:
      - media-server-network
    restart: unless-stopped
  # NOTE: Make sure that libraries are set to /tv and /movies in configuration
  jellyfin:
    image: linuxserver/jellyfin
    container_name: jellyfin
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New York
      - UMASK_SET=<022> #optional
    volumes:
      - /home/ben/mediaserver/jellyfin:/config # Jellyfin config / settings
      - /media/jellyfin/tv:/data/tvshows # TV Shows location
      - /media/jellyfin/movies:/data/movies # Movies location
    ports:
      - 7359:7359/udp # Discovery on network
      - 1900:1900/udp # Discover on network by DNLA and clients
    # devices:
    #   - /dev/dri:/dev/dri # Remove this if you do not want to use INTEL GPU for hardware excellerated transcoding
    networks:
      - media-server-network
    restart: unless-stopped
  # NOTE: Make sure to set download directory to /downloads
  deluge:
    image: linuxserver/deluge
    container_name: deluge
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New York
      - UMASK_SET=022 #optional
      - DELUGE_LOGLEVEL=error #optional
    volumes:
      - /home/ben/mediaserver/deluge:/config # Change path for volume mount
      - /media/jellyfin/downloads:/downloads # Change path for volume mount
    ports:
      - 127.0.0.1:8112:8112
    networks:
      - media-server-network
    restart: unless-stopped
  # NOTE: With Sonarr, when setting up downloader, make sure ip address is "deluge:8112"
  sonarr:
    image: linuxserver/sonarr
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New York
      - UMASK_SET=022 #optional
    volumes:
      - /home/ben/mediaserver/sonarr:/config # Change path for volume mount
      - /media/jellyfin/tv:/tv # Change path for volume mount
      - /media/jellyfin/downloads:/downloads # Change path for volume mount
    ports:
      - 127.0.0.1:8989:8989
    networks:
      - media-server-network
    restart: unless-stopped
  # NOTE: Similar to Sonarr, when setting up downloader make sure to enter "deluge:8112" for the host and port respectively
  radarr:
    image: linuxserver/radarr
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New York
      - UMASK_SET=022 #optional
    volumes:
      - /home/ben/mediaserver/radarr:/config # Change path for volume mount
      - /media/jellyfin/movies:/movies # Change path for volume mount
      - /media/jellyfin/downloads:/downloads # Change path for volume mount
    ports:
      - 127.0.0.1:7878:7878
    networks:
      - media-server-network
    restart: unless-stopped
  # NOTE: With Jackett, ensure blackhole directory is setup at /downloads
  # Also: Ensure trackers are setup from config
  jackett:
    image: linuxserver/jackett
    container_name: jackett
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New York
      - AUTO_UPDATE=true #optional
    volumes:
      - /home/ben/mediaserver/jackett:/config # Change path for volume mount
      - /media/jellyfin/downloads:/downloads # Change path for volume mount
    ports:
      - 127.0.0.1:9117:9117
    networks:
      - media-server-network
    restart: unless-stopped

volumes:
  web-root:
    driver: local

# NOTE: It is very important that if you are also running a OpenVPN service on the host, that you include the EXACT subnet address for the network interface to use.
# The reason for this is to avoid overlapping of IPv4 addresses. This way as long as your openVPN service is not using the 172.16.57.0/24 subnet, you should not have any overlap.
networks:
  media-server-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.16.57.0/24

```

Once you have copied and all your modifications have been made to the `compose` file, you can start the services with the following command.

```bash

docker-compose up -d

```

## Additional Instructions

If you are on Ubuntu 20.04 and cannot access your server, you may be getting blocked by a firewall policy. If you use `UFW`, you can fix this using the following commands

```bash

ufw allow 443

```

```bash

ufw allow 80

```

```bash

ufw allow OpenSSH

```

> To continue allowing SSH connection through your firewall. This is to ensure this policy is set.

```bash

ufw enable

```

> Start and enable on startup, your firewall using `UFW`.
