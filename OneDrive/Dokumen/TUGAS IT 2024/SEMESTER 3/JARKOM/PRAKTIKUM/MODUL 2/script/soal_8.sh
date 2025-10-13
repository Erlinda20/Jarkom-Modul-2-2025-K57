#Di Tirion
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


#Di Valmar
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

# Harus menghasilkan jawaban seperti:
# ;; ANSWER SECTION:
# 2.3.92.10.in-addr.arpa. 86400 IN PTR sirion.K57.com.

# Dan lihat ada tanda:
# ;; AUTHORITY SECTION: