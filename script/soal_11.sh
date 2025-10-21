#In Sirion

apt-get update
apt-get install -y nginx

#nano /etc/nginx/sites-available/sirion.K57.com
server {
    listen 80;
    server_name www.K57.com sirion.K57.com;

    location / {
        proxy_pass http://10.92.3.5; # IP Vingilot
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # Path-based reverse proxy
    location /static/ {
        proxy_pass http://10.92.3.2/;  # IP Lindon
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /app/ {
        proxy_pass http://10.92.3.5/;  # IP Vingilot
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

ln -s /etc/nginx/sites-available/sirion.K57.com /etc/nginx/sites-enabled/
rm -rf /etc/nginx/sites-enabled/default
nginx -t
nginx -s reload

# cek di client lain (cirdan)
curl http://www.K57.com/static/
curl http://www.K57.com/app/
curl http://sirion.K57.com/static/ 