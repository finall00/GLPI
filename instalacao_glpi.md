# Instalação do GLPI

## 1. Pré-Requisitos

- 1.1 Servidor Linux (Debian ou Ubuntu LTS)

- - - 

## 2. Instalação

- 2.1 Atualizar

```bash
sudo apt update && sudo dist-upgrade -y
```

- 2.2 Reconfigurar timezone

```
sudo dpkg-reconfigure tzdata
```

- 2.3 Reiniciar

```bash
sudo reboot
```

- 2.3 Instalar Apache, PHP e MySQL

```bash
sudo apt install -y \
	apache2 \
	mariadb-server \
	mariadb-client \
	libapache2-mod-php \
	php-dom \
	php-fileinfo   \
	php-json \
	php-simplexml \
	php-xmlreader \
	php-xmlwriter \
	php-curl \
	php-gd \
	php-intl \
	php-mysqli   \
	php-bz2  \
	php-zip \
	php-exif \
	php-ldap  \
	php-opcache \
	php-mbstring
```

- 2.5 Criando e configurando Banco de Dados do GLPI

```bash
sudo mysql -e "CREATE DATABASE glpidb"
sudo mysql -e "GRANT ALL PRIVILEGES ON glpidb.* TO 'glpiuser'@'localhost' IDENTIFIED BY 'glpipassword'"
sudo mysql -e "GRANT SELECT ON mysql.time_zone_name TO 'glpiuser'@'localhost'"
sudo mysql -e "FLUSH PRIVILEGES"
```

- 2.6 Carregar timezones no MySQL 

```bash
mysql_tzinfo_to_sql /usr/share/zoneinfo | sudo mysql -u root mysql
```


- - - 

## Instalando e GLPI


- 3. Desabilitar o site padrão do apache2

```bash 
sudo a2dissite 000-default.conf
```

- 3.2 Habilita session.cookie_httponly

```bash
sudo sed -i 's/^session.cookie_httponly =/session.cookie_httponly = on/' /etc/php/*/apache2/php.ini && \
	sudo sed -i 's/^;date.timezone =/date.timezone = America\/Sao_Paulo/' /etc/php/*/apache2/php.ini
```

- 3.3 Criar o virtualhost do GLPI

```bash
cat << EOF | sudo tee /etc/apache2/sites-available/glpi.conf
<VirtualHost *:80>
    ServerName glpi.finall.space
    DocumentRoot /var/www/glpi/public

    <Directory /var/www/glpi/public>
        Require all granted
        RewriteEngine On

        # Redireciona todas as requisições para o roteador do GLPI, a menos que o arquivo exista
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^(.*)$ index.php [QSA,L]
    </Directory>
</VirtualHost>EOF
```
- 3.4 Habilita o virtualhost

```bash
sudo a2ensite glpi.conf
```
- 3.5 Habilitar módulos do Apache necessários

```bash
sudo a2enmod rewrite
```

- 3.6 Reiniciando o apache 

```bash
sudo systemctl restart apache2
```


- 3.7 Download do glpi

```bash
wget -q https://github.com/glpi-project/glpi/releases/download/10.0.18/glpi-10.0.18.tgz
```

- 3.8 Descompactando GLPI 

```bash
tar -zxf glpi-*
```

- 3.9 Movendo a pasta para htdocs

```bash
sudo mv glpi /var/www/glpi
```

- 3.10 Comfigurando permissoes do glpi 

```bash
sudo chown -R www-data:www-data /var/www/glpi/
```


- 3.11 Finalizando o setup do glpi pela linha de comando 

```bash
sudo php /var/www/html/glpi/bin/console db:install  \
    --default-language=pt_BR \
    --db-host=localhost \
    --db-port=3306 \ 
    --db-name=glpi \
    --db-user=glpiuser \
    --db-password=glpipassword


```

## 4 Configurações de segurança 

- 4.1 Remove o arquivo  de instalação 

```bash
sudo rm /var/www/glpi/install/install.php
```

- 4.2 Mover pastas do GLPI de forma segura 

```bash
sudo mv /var/www/glpi/files /var/lib/glpi
sudo mv /var/www/glpi/config /etc/glpi
sudo mkdir /var/log/glpi && sudo chown -R www-data:www-data /var/log/glpi
```

- 4.3 Mover pastas do GLPI de forma segura | conf-dir


```bash
cat << EOF | sudo tee /var/www/glpi/inc/downstream.php
<?php
define('GLPI_CONFIG_DIR', '/etc/glpi/');
if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
   require_once GLPI_CONFIG_DIR . '/local_define.php';
}
EOF
```

- 4.3 Mover pastas do GLPI de forma segura | data dir

```bash 
cat << EOF | sudo tee /etc/glpi/local_define.php
<?php
define('GLPI_VAR_DIR', '/var/lib/glpi');
define('GLPI_LOG_DIR', '/var/log/glpi');
EOF
```

- - - 

## 5 Primeiros Passos

- 4.1. Acessar o GLPI via web browser
- 4.2. Criar um novo usuário com perfil super-admin
- 4.3. Remover os usuários glpi, normal, post-only, tech.
- 4.3.1. Enviar os usuários para a lixeira
- 4.3.2. Remover permanentemente
- 4.3.4. Configurar a url de acesso ao sistema em: Configurar -> Geral -> Configuração Geral -> URL da aplicação.




