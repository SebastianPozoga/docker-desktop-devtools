FROM ubuntu:16.04
MAINTAINER Sebastian Pożoga <sebastian@pozoga.eu>
# forked from fcwu/docker-ubuntu-vnc-desktop (Doro Wu <fcwu.tw@gmail.com>)

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's#http://archive.ubuntu.com/#http://tw.archive.ubuntu.com/#' /etc/apt/sources.list

# built-in packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common curl \
    && sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list" \
    && curl -SL http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key | apt-key add - \
    && add-apt-repository ppa:fcwu-tw/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
        supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        libreoffice firefox \
        fonts-wqy-microhei \
        language-pack-zh-hant language-pack-gnome-zh-hant firefox-locale-zh-hant libreoffice-l10n-zh-tw \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta arc-theme \
        dbus-x11 x11-utils \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# tini for subreap
ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

# add repositories
RUN add-apt-repository ppa:webupd8team/atom \
  && apt-get update

# system dependencies
RUN apt-get install -y wget curl git build-essential

# golang
RUN wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.8.linux-amd64.tar.gz

ENV GOROOT="/usr/local/go"
ENV GOPATH="/root/go"
ENV PATH="${PATH}:$GOROOT/bin:$GOPATH/bin"

# golang - popular packages
RUN go get github.com/gorilla/mux \
  && go get github.com/jmoiron/sqlx \
  && go get github.com/goatcms/goatcore \
  && go get github.com/mattn/go-sqlite3 \
  && go install github.com/mattn/go-sqlite3 \
  && go get github.com/lib/pq \
  && go install github.com/lib/pq \
  && go get golang.org/x/crypto/bcrypt \
  && go get github.com/buger/jsonparser

# golang - atom packages
RUN go get -u golang.org/x/tools/cmd/goimports \
  && go get -u golang.org/x/tools/cmd/gorename \
  && go get -u github.com/sqs/goreturns \
  && go get -u github.com/nsf/gocode \
  && go get -u github.com/alecthomas/gometalinter \
  && go get -u github.com/zmb3/gogetdoc \
  && go get -u github.com/rogpeppe/godef \
  && go get -u golang.org/x/tools/cmd/guru

# atom
RUN apt-get install -y atom \
  && apm install file-icons \
  && apm install go-debug \
  && apm install go-plus \
  && apm install language-docker \
  && apm install atom-beautify \
  && apm install git-plus

# git
RUN apt-get install -y git

# nodejs
RUN apt-get install -y nodejs npm
RUN npm install -g n
RUN n stable

# node build tools
RUN npm install -g gulp
RUN npm install -g jshint
RUN npm install -g bower
RUN npm install -g yarn

# ruby
RUN apt-get install -y ruby-dev

# sass
RUN gem install sass

# apache2
RUN apt-get install -y apache2

# php
RUN apt-get install -y php7.0 php7.0-cli php7.0-mysql php7.0-dev libapache2-mod-php7.0 php7.0-mcrypt php7.0-curl php7.0-sqlite php-pear php-imagick php-xdebug

# php - composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');"

# mysql
RUN apt-get install -y mysql-client mysql-server

# console tools
RUN apt-get install -y vim iputils-ping

# remote access tools
RUN apt-get install -y curlftpfs sshfs cifs-utils

# load configs
ADD image /root/image
RUN find /root/image -type f -regextype posix-extended -iregex '^.*\/((\.[A-Za-z0-9_\-\.]+)|([A-Za-z0-9_\-])|([A-Za-z0-9_\-]+[A-Za-z0-9_\-\.]\.(js|html|po|css|sh|conf|md|txt|json|py)))$' -exec sed -i -e 's/\r//' {} \;
RUN cp -r /root/image/* / && rm -rf /root/image

# vnc & novnc dependencies
RUN pip install setuptools wheel && pip install -r /usr/lib/web/requirements.txt

EXPOSE 80 81
WORKDIR /root
ENV HOME=/root \
    SHELL=/bin/bash

ENTRYPOINT ["/bin/bash", "/startup/startup.sh"]
