# Automated Media Server (Docker-Compose)

This is my configuration for my personal home media server installation using `docker-compose`.

## Features

Includes a number of useful automation services and applications to enhance the media server experience. Below is a list of these services

- [Jellyfin](https://jellyfin.org) as the media consumption front-end for users to watch and download movies and tv shows
- [Sonarr](https://sonarr.tv) helps to manage tv library
- [Radarr](https://radarr.video) helps to manage movies library
- [Deluge](https://deluge-torrent.org) as the torrent download client
- [Ombi](https://ombi.io) as the media request system for users to manage requests for new media to be added to a shared server
- [Jackett](https://github.com/Jackett/Jackett) to manage indexers for tv and movies from within Sonarr and Radarr services
- [Bazarr](https://www.bazarr.media) to help manage and download subtitles for all media content (movies and tv shows) (**Future App** - May not be required ... Jellyfin subtitles are pretty good sofar)
- [Nginx](https://www.nginx.com) Reverse proxy to handle and route incoming requests. Also provides https. (**Moved** see [docker-server-tools](https://github.com/SystemFiles/docker-server-tools))

## Requirements

This project has a small number of requirements to run successfully

- Docker ([More Info](https://www.docker.com/get-started))
- Docker-Compose ([More Info](https://docs.docker.com/compose/)) - v3.8+

## Start the services

Once you have copied and all your modifications have been made to the [compose file](/docker-compose.yml), you can start the services with the following command.

```bash

docker-compose up -d

```

## Server Tools

I like to use some specific networking and monitoring tools that work well with this stack. Below are the repositories for that configuration.

- [Server Tools (network/monitor)](https://github.com/SystemFiles/docker-server-tools)

> This includes an Nginx reverse proxy which will help to connect and route traffic to your services set up here

- [Pihole Standalone Config (deprecated: included in Server Tools)](https://github.com/SystemFiles/pihole-compose)