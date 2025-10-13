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

#lalu cek 
ls -l /var/lib/bind/ #gausa deh ini

#cek serial SOA 
dig @localhost K57.com SOA

#Valmar 
cat /etc/bind/named.conf.local

#cek dulu 
zone "K57.com" {
    type slave;
    masters { 10.92.3.; };   // IP ns1 (Tirion)
    file "/var/lib/bind/db.K57.com";
};

#restart 
service bind9 restart

#lalu cek 
ls -l /var/lib/bind/

#cek serial SOA 
dig @localhost K57.com SOA


#bandingkan angka serial 2025101201