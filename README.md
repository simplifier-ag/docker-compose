# Simplifier docker-compose template
Docker-Compose templates to run [Simplifier](https://simplifier.io)

## simplifier-standalone.yml
Single Simplifier Instance with corresponding MySQL and Reverse Proxy Traefik

##  Quick Setup Guide

edit .env file 
copy server certificats to ```./config/traefik/configuration``` 
copy ```security.toml``` to ```./config/traefik/configuration```
edit ```security.toml``` to match your needs, at least change name of certificate files

## Installation Manual

Extended documentation: How to setup Simplifier with default environment: https://community.simplifier.io/doc/installation-instructions/on-premise/installing-premise-image/

#### 1. Clone Repository

`git clone https://github.com/simplifier-ag/docker-compose.git`

Prepare Directories for Docker Volumes on your host

#### 2. Modify Variables in .env File

Adjust Hostname , DB Secret and DB Name and if needed Simplifier Version

```
HOSTNAME=example.simplifier.cloud
DB_PASSWORD=MySecret123
DB_NAME=simplifier
SIMPLIFIER_VERSION=6.5 
```

> :warning: Use a valid dns name for the Variable HOSTNAME - IP Adresses won't work for HOSTNAME because Traefik don't like this.
> If you are not capable to generate a valid dns with certificate, just modify your host file (for e.g. /etc/hosts) and flush your dns cache


#### 3. Optional - Add TLS Certficates (if you haven't any, Traefik will generate default ones)

copy your certificates to ```./config/traefik/configuration``` 

copy and edit security configuration
`cp security.toml ./config/traefik/configuration`
`vim ./config/traefik/configuration/security.toml`

#### 4. Run Simplifier

`docker compose up -d && docker-compose logs -f`

Press Strg+X if no error occurs in the logs

#### 5. Open Hostname with your Browser

https://yourHostname/UserInterface

#### 6. Insert your License Key

#### 7. Login with admin/admin
... and change your admin and guest user password

#### 8. Download Marketplace Content and import it (Menu -> Transport)

[Download here](https://community.simplifier.io/marketplace/standard-content/)

#### 9. Register on our [Community Page](https://community.simplifier.io/)

and learn how to use Simplifier in our [free online courses](https://community.simplifier.io/courses/)!
