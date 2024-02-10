#dockerfile estudado linha por linha

#selecionei a imagem php-fpm
FROM php:8.3.3RC1-fpm

# trocando o sh por bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#trazendo os argumentos do compose
ARG user
ARG uid

# atualizando os repositorios e instalando libs (coloquei o fix missing pra evitar erro caso algum up tenha corrompido a dependencia)
RUN apt-get update && apt-get install -y --fix-missing \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    sqlite3  \
    libsqlite3-dev \
    supervisor;

#se eu não me engano aqui a gente ta lipando o cache do container
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# definindo as vareaveis de ambiente para instalação do node e path do nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 20.11.0

#instalando nvm
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

RUN source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# desativei esssas libs porque não sei o que seria bom daqui, ela demoram cerca de 1min pra baixar (peguei do stockee v1)
# ative caso seja importante e eu não sei ( o mais interessante pra mim ai é o socket)
# RUN docker-php-ext-install mbstring exif pcntl bcmath gd sockets

#instalando o composer mais recente
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

#adicionando o user ao um grupo de permissão
RUN useradd -G www-data,root -u $uid -d /home/$user $user

#adicionando o adicionando o composer ao user com permissões
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

#copiando o projeto para o container
WORKDIR /var/www

COPY  . /var/www


# sequencia de comandos nos diretorios bootstrap/ storage/ e em suas heranças  para aplicar as permissões necessarias para escrita
# sem diminuir a seguraça (sem usar chmod 777 ou 775)

RUN chgrp -Rf www-data bootstrap/ storage/ storage/logs/
RUN chmod -Rf g+w bootstrap/ storage/ storage/logs/

WORKDIR /var/www/bootstrap/

RUN find -type d -exec chmod g+s {} +

WORKDIR /var/www/storage/

RUN find -type d -exec chmod g+s {} +

WORKDIR  /var/www/storage/logs/

RUN find -type d -exec chmod g+s {} +

#voltando para o path principal
WORKDIR /var/www

# #instalando modulos composer
RUN composer install

# #instalando modulos node
RUN npm install

#colocando o supervisord.conf dentro da pasta padrão
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#iniciando o container com o script do supervisor (usei o ENTRYPOINT para ser o padrão caso não mande qualquer comando no up)
ENTRYPOINT ["/usr/bin/supervisord"]
