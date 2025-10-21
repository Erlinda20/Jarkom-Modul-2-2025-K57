#!/bin/bash

# in Lindon
# Menghidupkan Lindon sebagai server web statis, konfigurasi agar bisa diakses melalui nama static.K57.com
# buat satu folder khusus isinya bisa dilihat langsung oleh pengunjung (directory listening/autoindex)

# install Nginx
apt-get update
apt-get install -y nginx

mkdir -p /var/www/static.K57.com/html/annals
echo "<h1>Selamat Datang di Pelabuhan Statis Lindon</h1>" > /var/www/static.K57.com/html/index.html
touch /var/www/static.K57.com/html/annals/catatan_perjalanan.txt
touch /var/www/static.K57.com/html/annals/peta_beleriand.jpg

# Konfigurasi Nginx server block
# Setiap website di Nginx memiliki file konfigurasinya sendiri di dalam /etc/nginx/sites-available/

cat <<'EOF' > /etc/nginx/sites-available/static.K57.com
server {
    listen 80;
    server_name static.K57.com;

    root /var/www/static.K57.com/html;
    index index.html;

    location / {
        index index.html;
        try_files $uri $uri/ /index.html;
    }

    # Blok khusus untuk folder /annals/
    location /annals/ {
        autoindex on; # <-- INI YANG MENGAKTIFKAN DIRECTORY LISTING
    }
}

EOF

# aktifkan konfigurasi
ln -s /etc/nginx/sites-available/static.K57.com /etc/nginx/sites-enabled/
# (Opsional tapi direkomendasikan) Hapus link default agar tidak bentrok
rm /etc/nginx/sites-enabled/default

# verifikasi
# Cek konfigurasi, pastikan outputnya "syntax is ok" dan "test is successful"
nginx -t

# Jika sudah OK, restart Nginx
service nginx restart

# in client (earendil atau cirdan)
# halaman utama
curl http://static.K57.com
# directory listening
curl http://static.K57.com/annals/ 
