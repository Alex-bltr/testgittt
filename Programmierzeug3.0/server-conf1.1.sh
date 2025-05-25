#!/bin/bash
set -e
echo "--- Starting configuration ----------"

sudo apt update && sudo apt upgrade -y

# Firewall und OpenSSH
sudo apt install -y openssh-server ufw
sudo ufw reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw --force enable


# Benutzer anlegen
sudo adduser --disabled-password --gecos "" "$mainusr"
sudo usermod -aG "$maingroup" "$mainusr"
sudo chown -R www-data:www-data /var/www/html

# Nginx installieren & Firewall anpassen
sudo apt install -y nginx
sudo ufw allow 'Nginx Full'

# PHP PPA hinzufügen & installieren
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php8.3-fpm php8.3-common php8.3-mysql \
php8.3-xml php8.3-intl php8.3-curl php8.3-gd \
php8.3-imagick php8.3-cli php8.3-dev php8.3-imap \
php8.3-mbstring php8.3-opcache php8.3-redis \
php8.3-soap php8.3-zip

# Jetzt PHP-Konfig anpassen (erst jetzt sind die Dateien da)
file_line_check() {
  keyword="$1"
  file="$2"
  new_line="$3"

  if grep -q "$keyword" "$file"; then
    sed -i "/$keyword/c\\$new_line" "$file"
  fi
}

file=( "/etc/php/8.3/fpm/pool.d/www.conf" "/etc/php/8.3/fpm/php.ini" )

keywords=( "user =" "group =" "listen.owner =" "listen.group =" "upload_max_filesize =" "post_max_size =" )

new_lines=( "user = www-data" "group = www-data" "listen.owner = www-data" "listen.group = www-data" "upload_max_filesize = 20M" "post_max_size = 80M" )

for ((f=0; f<2; f++)); do
  filename="${file[$f]}"
  if [[ "$filename" == *php.ini ]]; then
    for ((k=0; k<2; k++)); do
      file_line_check "${keywords[4+$k]}" "$filename" "${new_lines[4+$k]}"
    done
  else
    for ((k=0; k<4; k++)); do
      file_line_check "${keywords[$k]}" "$filename" "${new_lines[$k]}"
    done
  fi
done

sudo systemctl restart php8.3-fpm

# Nginx config neu laden
sudo rm -rf /etc/nginx/nginx.conf
cd /etc/nginx

curl -f -O https://raw.githubusercontent.com/Alex-bltr/testgittt/main/Programmierzeug3.0/nginx.conf || { echo "nginx.conf Download failed"; exit 1; }

sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default

sudo systemctl restart nginx
sudo nginx -s reload

# WP-CLI installieren
curl -f -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar || { echo "WP-CLI Download failed"; exit 1; }
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# MySQL Server installieren
sudo apt install -y mysql-server

# mysql_secure_installation ist interaktiv! Falls automatisieren, extra Script nötig
sudo mysql_secure_installation

# MySQL Datenbank und Benutzer anlegen
sudo mysql -e "CREATE DATABASE globex CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;"

read -s -p "Datenbank-Passwort für $mainusr: " dbpass
echo

sudo mysql -e "CREATE USER '$mainusr'@'localhost' IDENTIFIED BY '$dbpass';"
sudo mysql -e "GRANT ALL PRIVILEGES ON globex.* TO '$mainusr'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

cd /var/www/html
wp core download
sudo chown -R www-data:www-data /var/www/html

echo "Server config successful"
