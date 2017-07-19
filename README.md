# docker-desktop-devtools
The project contains pre-instaled developer tools and the most popular programming languages.

A Dockerfile / docker image created for developers environment. It contains pre-instaled the most popular programming languages like php, ruby, sass, nodejs, gulp, bower, yarn, golang. Web tools like apache2. The project contains [atom](https://atom.io/) with file-icons, go-debug, go-plus, language-docker, atom-beautify, git-plus plugins. Provide access by [VNC](https://pl.wikipedia.org/wiki/Virtual_Network_Computing) and [noVNC](https://github.com/novnc/noVNC).

## Introduction
It is based on [docker-ubuntu-vnc-desktop](https://github.com/fcwu/docker-ubuntu-vnc-desktop). There is description how to use vnc and novnc (webbrowser terminal).

## Run devtools
Recomended way to run devtools:
`docker run -it --rm -p 5900:5900 -e VNC_SCREEN=1600x900x24 -e VNC_PASSWORD=pass123 -v myhome:/root -v mywww:/var/www -v myapache2:/etc/apache2 devtools`

## VNC client
Recomended open source client is [TigerVNC](http://tigervnc.org/). Make Windows and Linux working together.
![Windows and linux on one laptop](https://raw.github.com/SebastianPozoga/docker-desktop-devtools/master/screenshots/desktop.jpg)

## Help
* [Port list](image/root/Desktop/DevToolsHelp/ports.md)

## Docker image
Use official docker hub to pull pre-build image:
https://hub.docker.com/r/spozoga/devtools/
