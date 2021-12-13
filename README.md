# docker-compose
Docker-Compose templates to run [Simplifier](https://simplifier.io)

## simplifier-standalone.yml
Single Simplifier Instance with corresponding MySQL and Reverse Proxy Traefik

##  Quick Setup Guide
 ```
mkdir -p /var/lib/simplifier/mysql
mkdir -p /var/lib/simplifier/data
mkdir -p /etc/simplifier/traefik
 ```
edit .env file 
copy server certificats to /etc/simplifier/traefik
copy security.toml to /etc/simplifier/traefik
edit security.toml to match your needs, at least change name of certificate files

### Installation Manual

Extended documentation: How to setup Simplifier with default environment: TODO (link to community pages)

1. Clone Repository

`git clone https://github.com/simplifier-ag/docker-compose.git`

Prepare Directories for Docker Volumes on your host

2. Modify Variables in .env File

Adjust Hostname , DB Secret and DB Name and if needed Simplifier Version

```
HOSTNAME=example.simplifier.cloud
DB_PASSWORD=MySecret123
DB_NAME=simplifier
SIMPLIFIER_VERSION=6.5 
```

> :warning: Use a valid dns name for the Variable HOSTNAME - IP Adresses won't work for HOSTNAME because Traefik don't like this.
> If you are not capable to generate a valid dns with certificate, just modify your host file (for e.g. /etc/hosts) and flush your dns cache

3. Create Data Directory for App Sources, Assset Files etc.

`mkdir -p /var/lib/simplifier/data`

4. Create Data Directory for MySQL Database.

`mkdir -p /var/lib/simplifier/mysql` 

5. Create Certificate Volume for TLS Certfificates

`mkdir -p /etc/simplifier/traefik` 

6. Optional - Add TLS Certficates (if you haven't any, Traefik will generate default ones)

copy your certificates to /etc/simplifier/traefik

copy and edit security configuration
`cp security.toml /etc/simplifier/traefik/`
`nano /etc/simplifier/traefik/security.toml`

7. Run Simplifier

`docker-compose -f simplifier-standalone.yml up -d && docker-compose -f simplifier-standalone.yml logs -f`

Press Strg+X if no error occurs in the logs

8. Open Hostname with your Browser

https://yourHostname/UserInterface

9. Insert your License Key

10. Login with admin/admin
... and change your admin and guest user password

11. Download Marketplace Content and import it (Menu -> Transport)

[Download here](https://community.simplifier.io/marketplace/standard-content/)

12. Register on our [Community Page](https://community.simplifier.io/)

and learn how to use Simpifier in our [free online courses](https://community.simplifier.io/courses/)!
