# Jarkom-Modul-1-2025-K57

### Member
1. Prabaswara Febrian 5027241069
2. Erlinda Annisa Zahra 5027241108

### Soal 1

Membuat alamat dan default gateway tiap tokoh sesuai glosariumnya.
![soal_1](images/soal_1.png)

    #Eonwe: 
    # WAN (ke NAT)
    auto eth0
    iface eth0 inet dhcp

    # Barat
    auto eth1
    iface eth1 inet static
        address 10.92.1.1
        netmask 255.255.255.0

    # Timur
    auto eth2
    iface eth2 inet static
        address 10.92.2.1
        netmask 255.255.255.0

    # DMZ
    auto eth3
    iface eth3 inet static
        address 10.92.3.1
        netmask 255.255.255.0

    up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.92.0.0/16



    #Earendil:
    auto eth0
    iface eth0 inet static
        address 10.92.1.2
        netmask 255.255.255.0
        gateway 10.92.1.1


    #Elwing:
    auto eth0
    iface eth0 inet static
        address 10.92.1.3
        netmask 255.255.255.0
        gateway 10.92.1.1


    #Cirdan:
    auto eth0
    iface eth0 inet static
        address 10.92.2.2
        netmask 255.255.255.0
        gateway 10.92.2.1


    #Elrond:
    auto eth0
    iface eth0 inet static
        address 10.92.2.3
        netmask 255.255.255.0
        gateway 10.92.2.1


    #Maglor:
    auto eth0
    iface eth0 inet static
        address 10.92.2.4
        netmask 255.255.255.0
        gateway 10.92.2.1


    #Sirion:
    auto eth0
    iface eth0 inet static
        address 10.92.3.2
        netmask 255.255.255.0
        gateway 10.92.3.1



    #Tirion: (ns1)
    auto eth0
    iface eth0 inet static
        address 10.92.3.3
        netmask 255.255.255.0
        gateway 10.92.3.1


    #Valmar:(ns2)
    auto eth0
    iface eth0 inet static
        address 10.92.3.4
        netmask 255.255.255.0
        gateway 10.92.3.1


    #Lindon:
    auto eth0
    iface eth0 inet static
        address 10.92.3.5
        netmask 255.255.255.0
        gateway 10.92.3.1


    #Vingilot:
    auto eth0
    iface eth0 inet static
        address 10.92.3.6
        netmask 255.255.255.0
        gateway 10.92.3.1

### Soal 2
Angin dari luar mulai berhembus ketika Eonwe membuka jalan ke awan NAT. Pastikan jalur WAN di router aktif dan NAT meneruskan trafik keluar bagi seluruh alamat internal sehingga host di dalam dapat mencapai layanan di luar menggunakan IP address.

Di Router atau eonwe. Dan masukkan ke dalam /root/.bashrc agar tidak config manual

    apt update
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.92.0.0/16
    echo nameserver 192.168.122.1 > /etc/resolv.conf

### Soal 3
Kabar dari Barat menyapa Timur. Pastikan kelima klien dapat saling berkomunikasi lintas jalur (routing internal via Eonwe berfungsi), lalu pastikan setiap host non-router menambahkan resolver 192.168.122.1 saat interfacenya aktif agar akses paket dari internet tersedia sejak awal.

Tambahkan di /etc/resolv.conf ke semua node

    nameserver 192.168.122.1

Setelah sudah diberikan sebuah internet disemua node. Maka bisa melakukan ping google.com dan semua node memiliki koneksi internet.

### Soal 4
Pada konfigurasi ini, Tirion (ns1) berperan sebagai DNS master yang mengelola zona K57.com secara authoritative dengan SOA ke ns1, mencatat NS dan A record untuk ns1, ns2, dan apex domain, mengaktifkan notify serta allow-transfer ke Valmar (ns2) sebagai slave yang menarik zona tersebut dan menjawab secara authoritative, dengan seluruh host non-router menggunakan urutan resolver ns1 → ns2 → 192.168.122.1 serta verifikasi memastikan query dijawab melalui kedua server tersebut.

Pertama install terlebih dahulu di client Tirion dan Valmar

    apt-get install -y bind9

Setelah berhasil ter install maka jalankan command ini:

    ln -s /etc/init.d/named /etc/init.d/bind9

Lalu set up terlebih dahulu di tirion sebagai ns1

    #mkdir -p /etc/bind/zones
    #nano /etc/bind/named.conf.local
    zone "K57.com" {
        type master;
        file "/etc/bind/zones/db.K57.com";
        allow-transfer { 10.92.3.4; };
        notify yes;
    };

    #nano /etc/bind/named.conf.options
    options {
        directory "/var/cache/bind";

        forwarders {
            192.168.122.1;
        };

        dnssec-validation auto;
        auth-nxdomain no;
        listen-on-v6 { any; };
    };

    #nano /etc/bind/zones/db.K57.com
    $TTL 86400
    @   IN  SOA ns1.K57.com. root.K57.com. (
                2025101201  ; Serial
                3600        ; Refresh
                600         ; Retry
                604800      ; Expire
                86400       ; Minimum TTL
    )
    @    IN  NS  ns1.K57.com.
    @    IN  NS  ns2.K57.com.

    ns1  IN  A   10.92.3.3
    ns2  IN  A   10.92.3.4
    @    IN  A   10.92.3.2
    www  IN  A   10.92.3.2

    #nano /root/.bashrc
    cat <<EOF > /etc/resolv.conf
    search K57.com
    nameserver 10.92.3.3
    nameserver 10.92.3.4
    nameserver 192.168.122.1
    EOF

    #nano /etc/resolv.conf
    search K57.com
    nameserver 10.92.3.3
    nameserver 10.92.3.4
    nameserver 192.168.122.1

    #cek file apakah dia berhasil apa tidak
    named-checkconf
    named-checkzone K57.com /etc/bind/zones/db.K57.com

    service bind9 restart

    #lalu bisa jalankan dan cek
    source /root/.bashrc
    ping K57.com

Setelah di setup aktifkan bind9 dan cek dengan ping K10.com

![soal_4](images/soal_4_tirion.png)

Lalu set up terlebih dahulu di Valmar sebagai ns2

    #mkdir -p /etc/bind
    # nano /etc/bind/named.conf.local
    zone "K57.com" {
        type slave;
        masters { 10.92.3.3; };
        file "/var/lib/bind/db.K57.com";
    };

    #nano /root/.bashrc
    apt update && apt install bind9 -y
    cat <<EOF > /etc/resolv.conf
    search K57.com
    nameserver 10.92.3.3
    nameserver 10.92.3.4
    nameserver 192.168.122.1
    EOF     

    #menjalankan
    ping K57.com

Setelah sudah di setup, aktifkan bind9 dan cek ping K57.com

![soal_4](images/soal_4_valmar.png)

### Soal 5
Setiap host dinamai sesuai glosarium (eonwe, earendil, elwing, cirdan, elrond, maglor, sirion, tirion, valmar, lindon, vingilot), diberi domain <hostname>.K57.com dan IP masing-masing agar dikenali secara system-wide, dengan pengecualian pada node ns1 dan ns2.

Semua node diberikan nano /etc/hosts, lalu diisi dengan: 

    127.0.0.1   localhost
    10.92.1.1   eonwe.K57.com eonwe
    10.92.1.2   earendil.K57.com earendil
    10.92.1.3   elwing.K57.com elwing
    10.92.2.2   cirdan.K57.com cirdan
    10.92.2.3   elrond.K57.com elrond
    10.92.2.4   maglor.K57.com maglor
    10.92.3.2   sirion.K57.com sirion
    10.92.3.3   tirion.K57.com ns1
    10.92.3.4   valmar.K57.com ns2
    10.92.3.5   lindon.K57.com lindon
    10.92.3.6   vingilot.K57.com vingilot

setelah sudah dimasukan ke /etc/hosts bisa dicoba dengan ping eonwe.K57.com dan bisa menghasilkan output ping.

![soal_5](images/soal_5.png)

### Soal 6
Pastikan proses zone transfer antara Tirion (ns1) dan Valmar (ns2) berjalan dengan benar sehingga Valmar menerima salinan zona terbaru dengan nilai serial SOA yang sama pada keduanya.

Pertama, lakukan setup dulu untuk Tirion

    #Tirion
    cat /etc/bind/named.conf.local

    #cek dulu 
    zone "K57.com" {
        type master;
        file "/etc/bind/zones/db.K57.com";
        allow-transfer { 10.92.3.4; };   // IP ns2 (Valmar)
        notify yes;
    };

    #restart 
    service bind9 restart

    #cek serial 
    grep Serial /etc/bind/zones/db.K57.com

    #cek serial SOA 
    dig @localhost K57.com SOA

Setelah udah di setup untuk tirion, sekarang setup juga untuk valmar.

    #Valmar 
    cat /etc/bind/named.conf.local

    #cek dulu 
    zone "K57.com" {
        type slave;
        masters { 10.92.3.3; };   // IP ns1 (Tirion)
        file "/var/lib/bind/db.K57.com";
    };

    #restart 
    service bind9 restart

    #cek serial SOA 
    dig @localhost K57.com SOA

Setelah udah setup semua untuk tirion dan valmar bisa langsung test dengan dig @localhost K57.com SOA untuk bisa melihat serial yang ada. lalu bisa saling memunculkan serial dan menghasilkan yang sama serialnnya.

![soal_6](images/soal_6.png)

### Soal 7
Pada zona K57.com, tambahkan A record untuk sirion, lindon, dan vingilot sesuai IP masing-masing, serta tetapkan CNAME www mengarah ke sirion, static ke lindon, dan app ke vingilot.

Boleh di client manapun untuk melakukan setup. Tapi untuk kali ini menggunakan Tirion.
buat nano terlebih dahulu di tirion 

    nano /etc/bind/zones/db.K57.com

Lalu isi dari nano tersebut adalah 

    $TTL 86400
    @   IN  SOA ns1.K57.com. root.K57.com. (
                2025101201  ; Serial
                3600        ; Refresh
                600         ; Retry
                604800      ; Expire
                86400 )     ; Minimum TTL
    @   IN  NS  ns1.K57.com.
    @   IN  NS  ns2.K57.com.

    ns1 IN A 10.92.3.3
    ns2 IN A 10.92.3.4
    @   IN A 10.92.3.2

    sirion   IN A 10.92.3.2
    lindon   IN A 10.92.3.5
    vingilot IN A 10.92.3.6

    www      IN CNAME sirion.K57.com.
    static   IN CNAME lindon.K57.com.
    app      IN CNAME vingilot.K57.com.

Setelah sudah di setup semuanya bisa melakukan command

    service bind9 restart

lalu bisa langsung untuk menjalankan:

    ping -c 3 www.K57.com  
    ping -c 3 static.K57.com
    ping -c 3 app.K57.com 

![soal_7](images/soal_7.png) 

### Soal 8

Di Tirion (ns1) buat reverse zone untuk segmen DMZ yang memuat Sirion, Lindon, dan Vingilot, lalu di Valmar (ns2) tarik sebagai slave, tambahkan PTR untuk ketiganya agar pencarian balik IP mengembalikan hostname yang benar dan dijawab secara authoritative.

Lalu bisa melakuka setup terlebih dahulu untuk Tirion

        #nano /etc/bind/named.conf.local dan tambahkan
        zone "3.92.10.in-addr.arpa" {
            type master;
            file "/etc/bind/zones/db.10.92.3";
            allow-transfer { 10.92.3.4; };  // IP Valmar (ns2)
        };

        #nano /etc/bind/zones/db.10.92.3 dan isi dengan
        $TTL 86400
        @   IN  SOA ns1.K57.com. root.K57.com. (
                2025101201  ; Serial
                3600        ; Refresh
                600         ; Retry
                604800      ; Expire
                86400 )     ; Minimum TTL

        @       IN  NS  ns1.K57.com.
        @       IN  NS  ns2.K57.com.

        2   IN  PTR sirion.K57.com.
        5   IN  PTR lindon.K57.com.
        6   IN  PTR vingilot.K57.com.

        #lalu cek sintaks nya
        named-checkzone 3.92.10.in-addr.arpa /etc/bind/zones/db.10.92.3

        #restart bind9
        service bind9 restart

Setelah sudah di setup di tirion, sekarang bisa melakukan di valmar.

    #nano /etc/bind/named.conf.local diisi dengan
    zone "3.92.10.in-addr.arpa" {
        type slave;
        masters { 10.92.3.3; };   // IP ns1 (Tirion)
        file "/var/lib/bind/db.10.92.3";
    };

    #lalu restart 
    service bind9 restart

    #Dijalankan menggunakan antara Tirion dan valmar
    dig -x 10.92.3.2
    dig -x 10.92.3.5
    dig -x 10.92.3.6

lalu memiliki output question section dan answer action.

![soal_8](images/soal_8.png)

### Soal 9
Jalankan web statis di hostname static.K57.com dengan folder /annals/ diaktifkan autoindex agar isinya dapat ditelusuri, dan pastikan akses hanya melalui hostname, bukan IP.


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

    #verifikasi
    #Cek konfigurasi, pastikan outputnya "syntax is ok" dan "test is successful"
    nginx -t

    #Jika sudah OK, restart Nginx
    service nginx restart

    #in client (earendil atau cirdan)
    #halaman utama
    curl http://static.K57.com
    #directory listening
    curl http://static.K57.com/annals/ 

Lalu habis sudah di setup semuanya bisa menjalankan di client cirdan

    #Halaman utama 
    curl http://static.K57.com

    #directory listening
    curl http://static.K57.com/annals/

![soal_9](images/soal_9.png)

### Soal 10
Jalankan web dinamis berbasis PHP-FPM di hostname app.K57.com dengan halaman beranda dan about, terapkan rewrite agar /about dapat diakses tanpa .php, serta pastikan akses hanya melalui hostname.

Lalu dijalankan di vingilot 

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

Lalu bisa dijalankan di Elrond atau Tirion

    curl http://app.K57.com/
    curl http://app.K57.com/about 
    
![soal_10](images/soal_10.png)
### Soal 11