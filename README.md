# Simplifier docker-compose template
Docker-Compose templates to run [Simplifier](https://simplifier.io)

## Docker Version
This setup requires docker version 20.10.17

## simplifier-standalone.yml
Single Simplifier Instance with corresponding MySQL and Reverse Proxy Traefik

##  Quick Setup Guide
 ```
mkdir -p /var/lib/simplifier/mysql
mkdir -p /var/lib/simplifier/data
mkdir -p /var/lib/simplifier/launchpad
mkdir -p /var/lib/simplifier/traefik
 ```
- cp .env.template .env
- edit .env file 
- copy server certificats to /var/lib/simplifier/traefik
- copy security.toml to /var/lib/simplifier/traefik
- edit security.toml to match your needs, at least change name of certificate files

### Installation Manual

Choose a directory for Simplifier data. We recommend using /var/lib/simplifier. This directory is important to backup. During this guide, /var/lib/simplifier is used as path. This path is refered as the host data path.

1. Clone Repository
`mkdir -p /var/lib/simplifier/bin`
`cd /var/lib/simplifier/bin`
`git clone https://github.com/simplifier-ag/docker-compose.git`
`git checkout --track origin/release/7.1 `

2. Create .env File

Copy template file
`cp .env.template .env`

Modify Variables in .env File:
Adjust Hostname, DB Secret and DB Name and if needed Simplifier Version or host data path.

```
HOSTNAME=example.simplifier.cloud
DB_PASSWORD=MySecret123
DB_ROOT_PASSWORD=MySuperSecret 
DB_NAME=simplifier
SIMPLIFIER_VERSION=7.1
HOST_DATA_PATH=/var/lib/simplifier
```

> :warning: Use a valid dns name for the Variable HOSTNAME - IP Adresses won't work for HOSTNAME because Traefik doesn't like this.
> If you are not capable to generate a valid dns with certificate, just modify your host file (for e.g. /etc/hosts) and flush your dns cache

3. Create Data Directory for App Sources, Assset Files etc.

`mkdir -p /var/lib/simplifier/data`
`mkdir -p /var/lib/simplifier/launchpad`
`chown 1000:1000 /var/lib/simplifier/launchpad`

4. Create Data Directory for MySQL Database.

`mkdir -p /var/lib/simplifier/mysql` 

5. Create Certificate Volume for TLS Certfificates

`mkdir -p /var/lib/simplifier/traefik` 

6. Optional - Add TLS Certficates (if you haven't any, Traefik will generate default ones)

copy your certificates to /var/lib/simplifier/traefik

copy and edit security configuration
`cp security.toml /var/lib/simplifier/traefik/`
`nano /var/lib/simplifier/traefik/security.toml`

7. Run Simplifier

`docker compose -f simplifier-standalone.yml up -d && docker compose -f simplifier-standalone.yml logs -f`

Press Strg+X if no error occurs in the logs

8. Open Hostname with your Browser

https://yourHostname/UserInterface

9. Insert your License Key

10. Login with admin/admin
... and change your admin and guest user password

11. Download Marketplace Content and import it (Menu -> Transport)

[Download here](https://community.simplifier.io/marketplace/standard-content/)

12. Register on our [Community Page](https://community.simplifier.io/)

and learn how to use Simplifier in our [free online courses](https://community.simplifier.io/courses/)!
