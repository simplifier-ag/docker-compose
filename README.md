# docker-compose
Docker-Compose Templates für Simplifier Setup

## simplifier-standalone.yml
Single Simplfier Instanz with corresponding MySQL and Reverse Proxy Traefik

Prepare Directories for Docker Volumes on your host

1. Modify Variables in .env File

Adjust Hostname , DB Secret and DB Name

```
HOSTNAME=example.simplifier.cloud
DB_PASSWORD=MySecret123
DB_NAME=simplifier
```

2. Create Data Directory for App Sources, Assset Files etc.

`mkdir -p /datadrive/simplifier/data`

3. Create Data Directory for MySQL Database.

`mkdir -p /datadrive/mysql` 

4. Create Certificate Volume for TLS Certfificates

`mkdir -p /datadrive/traefik/certs` 

5. Optional - Add TLS Certficates (if you haven't any, Traefik will generate default ones)

`nano /datadrive/traefik/certs/certificates.toml`

Copy & Paste
```
[[tls.certificates]]
   certFile = 'certs/simplifier.cloud.crt'
   keyFile = 'certs/simplifier.cloud.key'
```
Run Simplifier

`docker-compose -f simplifier-standalone.yml up -d`

Open Hostname with your Browser

https://yourHostname/UserInterface

Insert your License Key

Download Marketplace Content and Import it

[Download here](https://community.simplifier.io/marketplace/standard-content/)
