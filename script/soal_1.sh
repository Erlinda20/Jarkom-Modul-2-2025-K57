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

cat <<EOF > /etc/resolv.conf
search K57.com
nameserver 10.92.3.3
nameserver 10.92.3.4
nameserver 192.168.122.1
EOF


#tirion local dan options dan db.k57.com
#valmar local