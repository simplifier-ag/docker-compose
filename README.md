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
- ```instance_default.yaml```:
    default values for each instance
- ```env.template```:
    ".env" global example values
- ```templates/instance/mysql/config.yaml```:
    _moustache_ template file for mysql configuration of a single instance
- ```templates/instance/compose.yaml```:
    _moustache_ template file for compose setup of a single instance
- ```templates/instance/compose_nossl.yaml```:
    _moustache_ template file for compose setup of a single instance without TLS
- ```templates/instance/instance.env```:
    _moustache_ template file for env file of a single instance
- ```templates/traefik_config/security.toml```:
    _moustache_ template for security setting for traefik
- ```templates/include.yaml```:
    _moustache_ template for including all instance and a traefik instance
- ```templates/traefik.yaml```:
    _moustache_ template for traefik instance
- ```templates/traefik_nossl.yaml```:
    _moustache_ template for traefik instance without TLS
- ```apply.sh```:
    _script_ to setup defined instances
- ```instance_default.yaml```:
    default values for every instance
- ```Vagrantfile```:
    virtual machine setup to run "simplifier"
- ```include```:
    dynamically created Simplifier instances
- ```instance_examples```:
    examples for multi-instance setups


### description / examples

- **TODO**

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