* check the requiment (pc , network)

* install proxmox server
* create vm in proxmox and install debian
* create vm in proxmox and install proxmox backup
* fix ip address in router for all servers
* in proxmox: make container run automatically in startup
* in vm debian: update system packages and install necessary package(wget,git,ccze,zip)
* in vm debian: setup ssh server
* in vm debian  "authorized_keys" file add the key 
* in vm debian: install docker
* in vm debian: clone odoo repo from github
* in vm debian: create docker network
* in vm debian: setup proxy container
* in vm debian: setup odoo container
* in vm debian: make sure every thing get work fine
* in vm debian: make docker run automatically on startup
* in vm backup: link storage
* in vm backup: create repo for store data named "backup-container"
* in vm backup: setup schedule job  for auto remove
* in vm debian: install proxmox-backup-client
* in vm debian: check if login to backup server get successfully
* in vm debian: setup backup_script.sh and give it access right
* in vm debian: add line >> export PBS_PASSWORD='valkiry' << to .bashrc file (ignore ask for password by server)
* in vm debian: make script run every day "chmod +x /path/to/myscript.sh; crontab -e; */1 * * * * /home/solvex/service.backup/backup_script.sh"

