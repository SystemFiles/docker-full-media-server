# Automated Media Server (Docker-Compose)

This is my configuration for my personal home media server installation using `docker-compose`. If you want to acheive something similar, feel free to fork and modify this repository as required. Also, if you notice anything that could be improved or fixed, please create an issue or contact me so I can be aware of it. Thanks :)

## Features

Includes a number of useful automation services and applications to enhance the media server experience. Below is a list of these services

- [Jellyfin](https://jellyfin.org) as the media consumption front-end for users to watch and download movies and tv shows
- [Sonarr](https://sonarr.tv) helps to manage tv library
- [Radarr](https://radarr.video) helps to manage movies library
- [Deluge](https://deluge-torrent.org) as the torrent download client
- [Ombi](https://ombi.io) as the media request system for users to manage requests for new media to be added to a shared server
- [Jackett](https://github.com/Jackett/Jackett) to manage indexers for tv and movies from within Sonarr and Radarr services
- [Nginx](https://www.nginx.com) Reverse proxy to handle and route incoming requests. Also provides https.
- [Bazarr](https://www.bazarr.media) to help manage and download subtitles for all media content (movies and tv shows)

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

Once you have copied and all your modifications have been made to the [compose file](/docker-compose.yml), you can start the services with the following command.

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

## Networking and Monitoring

I like to use some specific networking and monitoring tools that work well with this stack. Below are the repositories for that configuration

- [Server Tools (network/monitor)](https://github.com/SystemFiles/docker-server-tools)
- [Pihole Standalone Config (deprecated: included in Server Tools)](https://github.com/SystemFiles/pihole-compose)