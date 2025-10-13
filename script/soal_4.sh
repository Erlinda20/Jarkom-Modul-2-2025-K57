#didalam Tiroin

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

apt update && apt insy=tall bind9 -y

#nano /etc/resolv.conf
search K57.com
nameserver 10.92.3.3
nameserver 10.92.3.4
nameserver 192.168.122.1

#cek file apakah dia berhasil apa ga
named-checkconf
named-checkzone K57.com /etc/bind/zones/db.K57.com

service bind9 restart
service bind9 status

apt update 
apt bind9


#lalu bisa jalankan dan cek
source /root/.bashrc
ping K57.com


#Valmar
apt-get update &&  apt-get install bind9 -y
ln -s /etc/init.d/named /etc/init.d/bind9
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

#kalau  mau jlaankan
ping K57.com