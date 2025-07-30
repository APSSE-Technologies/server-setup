sudo docker run -it --rm \
  -v $(pwd)/nginx/html:/var/www/html \
  -v /etc/letsencrypt:/etc/letsencrypt \
  certbot/certbot certonly \
  --webroot -w /var/www/html \
  -d apsse-technologies.andrepozzan.eng.br