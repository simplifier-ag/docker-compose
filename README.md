# Simplifier 8 EHP 4

## Changelog:
* Multinstance setup
* PDF Plugin JS execution is disabled per default
* Legacy OPC UA connector is disabled per default
* New feature: Allow users to select a preferred language in workflows 

---

# Simplifier docker-compose template
Docker-Compose templates to run [Simplifier](https://simplifier.io)

## Docker Version
This setup requires 
- docker version: **20.10.17**
- docker compose v2 version: **2.20.3**

## Vagrant setup 

- ```Vagrantfile```:
    Minimalistic server based on debian bookworm to run the simplfier multiinstance setup for  

## Setup 

Multi Simplifier Instance setup with corresponding MySQL and Reverse Proxy Traefik

- ```compose.yaml```
    root docker compose setup 
- ```template_engine/execute.sh```: 
    template mechanism to create multiple instances
- ```instances.yaml```:
    instances to be created
- ```instance_default.yaml```:
    default values for each instance
- ```env.temnplate```:
    ".env" global example values 
- ```temnplates/instance/mysql/config.yaml```:
    _moustache_ template file for mysql configuration of a single instance  
- ```temnplates/instance/docker-compose.yaml```:
    _moustache_ template file for compose setup of a single instance
- ```temnplates/instance/instance.env```:
    _moustache_ template file for env file of a single instance

### description / examples
- TODO

# For an up-to-date Setup Guide, visit our Community

## Setup a new Simplifier instance
https://community.simplifier.io/doc/installation-instructions/on-premise/installing-premise-image/

## Update an existing Simplifier instance
https://community.simplifier.io/doc/installation-instructions/upgrade/upgrade-via-docker-compose/

## Online Courses
https://community.simplifier.io/courses/

## Forum
https://community.simplifier.io/forum

## General Documentation
https://community.simplifier.io/doc/getting-started/