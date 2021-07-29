# docker-compose
Docker-Compose Templates für Simplifier Setup

## simplifier-standalone.yml
Single Simplifier Instance with corresponding MySQL and Reverse Proxy Traefik

### Installation Manual

1. Clone Repository

`git clone https://github.com/simplifier-ag/docker-compose.git`

Prepare Directories for Docker Volumes on your host

2. Modify Variables in .env File

Adjust Hostname , DB Secret and DB Name

```
HOSTNAME=example.simplifier.cloud
DB_PASSWORD=MySecret123
DB_NAME=simplifier
```

3. Create Data Directory for App Sources, Assset Files etc.

`mkdir -p /datadrive/simplifier/data`

4. Create Data Directory for MySQL Database.

`mkdir -p /datadrive/mysql` 

5. Create Certificate Volume for TLS Certfificates

`mkdir -p /datadrive/traefik/certs` 

6. Optional - Add TLS Certficates (if you haven't any, Traefik will generate default ones)

`nano /datadrive/traefik/certs/certificates.toml`

Copy & Paste
```
[[tls.certificates]]
   certFile = 'certs/simplifier.cloud.crt'
   keyFile = 'certs/simplifier.cloud.key'
```
7. Run Simplifier

`docker-compose -f simplifier-standalone.yml up -d`

8. Open Hostname with your Browser

https://yourHostname/UserInterface

9. Insert your License Key

10. Download Marketplace Content and Import it

[Download here](https://community.simplifier.io/marketplace/standard-content/)

11. Login with admin/admin
... and change your admin password

12. Register on our [Community Page](https://community.simplifier.io/)

and learn how to use Simpifier in our [free online courses](https://community.simplifier.io/courses/)!
