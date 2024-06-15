## to create an external network use the command:
    * docker network create --driver=bridge --subnet=100.0.0.0/24  --ip-range=100.0.0.0/24  app_net
## install color logs:
    * sudo apt install ccze

## for create ssl
    * docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ --dry-run -d [domain-name]