# In Vingilot

# Install nginx dan php
apt-get update
apt-get install -y nginx php8.4-fpm

mkdir -p /var/www/app.K57.com/html

cat <<EOF > /var/www/app.K57.com/html/index.php
<?php
echo "<h1>Selamat Datang di Beranda Vingilot</h1>";
?>
EOF

cat <<EOF > /var/www/app.K57.com/html/about.php
<?php
echo "<h1>About Vingilot</h1><p>Ini halaman About.</p>";
?>
EOF

chown -R www-data:www-data /var/www/app.K57.com/html
chmod -R 755 /var/www/app.K57.com/html

#nano /etc/nginx/sites-available/app.K57.com
server {
    listen 80;
    server_name app.K57.com;

    root /var/www/app.K57.com/html;
    index index.php index.html;

    # Rewrite /about tanpa .php
    location / {
        try_files $uri $uri/ $uri.php?$args;
    }

    # PHP-FPM
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}

ln -sf /etc/nginx/sites-available/app.K57.com /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

nginx -t
nginx -s reload
# misal gabisa reload 
service nginx restart
# baru dijalanin lagi reloadnya

service php8.4-fpm start

#Di Client (Elrond atau Tirion)
curl http://app.K57.com/
curl http://app.K57.com/about 