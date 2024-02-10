# Redirect

## Ambiente de Desenvolvimento V3

### DevOPS : Pablo Eduardo 

#### Changelog

V1 
- Utiliza Sail
- Iniciado por /vendor/sail/.bin up

V2  
- Removido o Sail
- Ambiente Dockerizado (Implementado o Docker nessa versão)
- Ambiente inicia por 3 comandos: docker compose up, docker exec app bash, npm run dev
- Não pode ser utilizado o docker compose em deamon

V3
- Adicionado Supervisor ao Docker
- Ambiente pode ser utilizado em deamon 
- Removido a execução manual de : docker compose exec app bash , npm run dev
- Ambiente completamente construido somente atraves do: ```docker compose up``` ou  ```docker compose up -d``` (usando em deamon)

## Como configurar o ambiente de desenvolvimento

### 1 Instalação do Docker

****1.1**** Antes de tudo, é necessario que você tenha o docker instalado na sua maquinha, segue os comandos em ordem para instalar

    ```bash

    sudo apt update

    sudo apt install apt-transport-https ca-certificates curl software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

    sudo apt install docker-ce

    ```
**1.2** Para verificar se foi instalado com sucesso

    ```bash

    sudo systemctl status docker

    ```

se no output do comando acima contem :

    ```bash

    ● docker.service - Docker Application Container Engine
        Loaded: loaded ...
        Active: active ...

    ```

então foi instalado com exito

**Para facilitar nosso desenvolvimento, vamos retirar a necessidade de usar sudo junto com o comando docker.**

**1.3** Adicione seu usuario atual no grupo docker

    ```bash

    sudo usermod -aG docker ${USER}

    ```

**1.4** Para aplicar o novo mebro do grupo execute o seguinte comando

    ```bash

    su - ${USER}

    ```

**1.5** Confirme que seu usuario já está no grupo docker, ao executar o seguinte comando, no seu output procure por "docker"

    ```bash

    groups

    ```

ao identificar, então seu usuario ja pode executar o comando **docker** diratamente 

### 2 Executando a aplicação

**2.1** Clone o Repositorio:

    ```bash

    git clone git@github.com:De-v-0ps/redirect.git 

    ```
**2.2** Crie o .env a partir do .env.example

    ```bash

    cp .env.example .env 

    ```

**2.3** Vá no .env e insira o seu USER linux da sua maquina (linha 64)

    ```bash

    USER = NOME DO SEU USUARIO LINUX AQUI

    ```
**2.4** Execute o ambiente

    ```bash

    docker compose up -d 

    #ou  

    docker compose up

    ```
    
**Aplicação disponivel em http://localhost:80**


- Descontinuado na V3

    ~**2.5** Com os containers criados entre no container app executando o comando

    ```bash

    docker compose exec app bash

    ```
    **2.6**  Dentro do conatiner execute o Vite com o seguinte comando 

    (o terminal que executa esse comando tem que ficar aberto para aplicação ficar disponivel)

    ```bash

    npm run dev

    ```
    ~ 



