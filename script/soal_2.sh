#di /root/.bashrc di router
apt update
apt install iptables -y
apt-get install bind9 -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.92.0.0/16
ln -s /etc/init.d/named /etc/init.d/bind9
echo nameserver 192.168.122.1 > /e>

