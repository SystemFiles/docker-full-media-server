# Automated Media Server (Docker-Compose)

This is my configuration for my personal home media server installation using `docker-compose`.

## Features

Includes a number of useful automation services and applications to enhance the media server experience. Below is a list of these services

- [Jellyfin](https://jellyfin.org) as the media consumption front-end for users to watch and download movies and tv shows
- [Sonarr](https://sonarr.tv) helps to manage tv library
- [Radarr](https://radarr.video) helps to manage movies library
- [Bazarr](https://docs.linuxserver.io/images/docker-bazarr) helps to find subtitles for movies and tv shows
- [Deluge](https://deluge-torrent.org) as the torrent download client
- [Prowlarr](https://docs.linuxserver.io/images/docker-prowlarr) to manage indexers for tv and movies from within Sonarr and Radarr (meant as a replacement for Jackett)
- [FlareSolverr](https://www.github.com/FlareSolverr/FlareSolverr) Supports some Jackett indexers that are behind cloudflare firewall

## Requirements

This project has a small number of requirements to run successfully

- Docker ([More Info](https://www.docker.com/get-started))
- Docker-Compose ([More Info](https://docs.docker.com/compose/)) - v3.8+

## Start the services

Once you have copied and all your modifications have been made to the [compose file](/docker-compose.yml), you can start the services with the following command.

```bash

docker-compose up -d

```
