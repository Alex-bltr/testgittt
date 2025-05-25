#!/bin/bash
set -e
echo "--- Starting configuration ----------"
sudo apt update && sudo apt upgrade -y
# Animation/Spinner (optional, aber richtig)
spin='-\|/'
i=0
value=0
maingroup='www-data'
mainusr='wpusr'



#while [ $value -ne 1 ]; do
#  printf "\r[%c] Processing..." "${spin:i++%4:1}"
#  sleep 0.2
#  value=1  # Dummy end
#done
#printf "\rDone!\n"

# Redirect stdout/stderr to /dev/null (from here on)
#exec > /dev/null 2>&1

# Function to replace line containing keyword
file_line_check() {
  keyword="$1"
  file="$2"
  new_line="$3"

  if grep -q "$keyword" "$file"; then
    sed -i "/$keyword/c\\$new_line" "$file"
  fi
}

# Files
file=(
  "/etc/php/8.3/fpm/pool.d/www.conf"
  "/etc/php/8.3/fpm/php.ini"
)

# Keywords and new lines
keywords=(
  "user ="
  "group ="
  "listen.owner ="
  "listen.group ="
  "upload_max_filesize ="
  "post_max_size ="
)

new_lines=(
  "user = www-data"
  "group = www-data"
  "listen.owner = www-data"
  "listen.group = www-data"
  "upload_max_filesize = 20M"
  "post_max_size = 80M"
)

# Apply changes
for ((f=0; f<2; f++)); do
  filename="${file[$f]}"
  if [[ "$filename" == *php.ini ]]; then
    for ((k=0; k<2; k++)); do
    file_line_check "${keywords[5+$k]}" "$filename" "${new_lines[5+$k]}"
  done
  else 
    for ((k=0; k<4; k++)); do
    file_line_check "${keywords[$k]}" "$filename" "${new_lines[$k]}"
    done
  fi
done

# Firewall setup
sudo apt update
sudo apt install -y openssh-server ufw

# UFW zurücksetzen und Grundregeln setzen
sudo ufw reset
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Erlaubte Dienste freigeben
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'

# UFW aktivieren (Bestätigung wird automatisch mit "y" beantwortet)
echo "y" | sudo ufw enable

# Benutzer anlegen und in Gruppe einfügen
sudo adduser --disabled-password --gecos "" "$mainusr"
sudo usermod -aG "$maingroup" "$mainusr"
sudo chown -R www-data:www-data /var/www/html

# PHP/NGINX installieren
echo "Installing dependencies ----------------------------------------------"
sudo apt install -y nginx
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php8.3-fpm php8.3-common php8.3-mysql \
php8.3-xml php8.3-intl php8.3-curl php8.3-gd \
php8.3-imagick php8.3-cli php8.3-dev php8.3-imap \
php8.3-mbstring php8.3-opcache php8.3-redis \
php8.3-soap php8.3-zip

# Restart PHP-FPM for changes to take effect
sudo systemctl restart php8.3-fpm

sudo rm -rf /etc/nginx/nginx.conf

cd /etc/nginx
curl -O https://raw.githubusercontent.com/Alex-bltr/testgittt/refs/heads/main/Programmierzeug3.0/nginx.conf 
sudo systemctl restart nginx
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -s reload

#wp-cli installation
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

#mysql installation
sudo apt install mysql-server -y
sudo mysql_secure_installation 


#mysql db erstellung
sudo mysql -e "CREATE DATABASE globex CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;"
read -s -p "Datenbank-Passwort für $mainusr: " dbpass
echo
sudo mysql -e "CREATE USER '$mainusr'@'localhost' IDENTIFIED BY '$dbpass';"
sudo mysql -e "GRANT ALL PRIVILEGES ON globex.* TO '$mainusr'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

cd /var/www/html
wp core download
sudo chown -R www-data:www-data /var/www/html

echo Server config sucsessfull

