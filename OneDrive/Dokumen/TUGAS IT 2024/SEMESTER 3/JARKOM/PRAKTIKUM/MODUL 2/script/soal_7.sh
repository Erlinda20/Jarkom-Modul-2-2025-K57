#di tirion si aku ambilnya

#buka
nano /etc/bind/zones/db.K57.com

#isi nano 
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

#cek syntax zone file
named-checkzone K57.com /etc/bind/zones/db.K57.com
#output
zone K57.com/IN: loaded serial 2025101201
OK

#melakukan restart
service bind9 restart

#dan coba melakukan satu satu
ping -c 3 www.K57.com  # www arah ke sirion
ping -c 3 static.K57.com #static arah ke lindon
ping -c 3 app.K57.com #app arah ke vingilot