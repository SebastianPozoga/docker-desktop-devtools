# docker-desktop-devtools

## Introduction
It is based on [docker-ubuntu-vnc-desktop](https://github.com/fcwu/docker-ubuntu-vnc-desktop). There is description how to use vnc and novnc (webbrowser terminal).

## Run devtools
Recomended way to run devtools:
`docker run -it --rm -p 6080:80 -p 5900:5900 -e VNC_SCREEN=1600x900x24 -v homedir:/root devtools`

## Docker image
Use official docker hub to pull pre-build image:
https://hub.docker.com/r/spozoga/dev-tools/
