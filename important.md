## to create an external network use the command:
    * docker network create --driver=bridge --subnet=100.0.0.0/24  --ip-range=100.0.0.0/24  app_net
## fix docker permitions :
    * sudo usermod -aG docker $USER
    * sudo reboot
## diable gpu for debian:
    * sudo systemctl set-default multi-user.target
    * sudo systemctl isolate multi-user.target
## for create ssl
    * docker-compose run --rm certbot certonly --webroot --webroot-path /var/www/certbot/ --dry-run -d [domain-name]
## login/logout proxmox backup server:
    * proxmox-backup-client login --repository 10.0.0.12:8007
    * proxmox-backup-client logout --repository 10.0.0.12:8007
## backup folder to proxmox backup server
    * proxmox-backup-client backup root.pxar:/home/rooot/Desktop/backuptest --repository 10.0.0.12:backup-container
## backup list in proxmox server :
    * proxmox-backup-client snapshot list --repository 10.0.0.12:backup-container
## restore file from spesific repo
    * proxmox-backup-client restore host/fedora/2024-06-16T13:28:13Z root.pxar . --repository 10.0.0.12:backup-container
## restora database postgress:
    * cat your_dump.sql | docker exec -i your-db-container psql -U odoo -d database