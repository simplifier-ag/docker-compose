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
- ```templates/instance/compose_letsencrypt.yaml```:
    _moustache_ template file for compose setup of a single instance with letsencrypt cert
- ```templates/instance/instance.env```:
    _moustache_ template file for env file of a single instance
- ```templates/traefik_config/security.toml```:
    _moustache_ template for security setting for traefik
- ```templates/include.yaml```:
    _moustache_ template for including all instance and a traefik instance
- ```templates/traefik.yaml```:
    _moustache_ template for traefik instance
- ```templates/traefik_letsencrypt.yaml```:
    _moustache_ template for traefik instance with letsencrypt cert
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

#### (1) create an ```.env``` file
To have the setup running in the first place it is necessary to create a ```.env```
file. Use the ```env.template``` file as a template and then define the required values.

#### (2) default setup
The initial setup defines a single instance without ssl, witch servers the domain
```instance.simplifier.io```. 
This can be started via ```docker compose up -d```

#### (3) define your required deployment
Custom instances are defined in a central "deployment" file. There you define 
your instances. Examples are in the ```instances_examples``` folder.

for example:
```yaml
domain_suffix: simplifier.io
instances:
  develop:
    instance_name: develop
    db_password: develop_pass
    simplifier_subdomain: develop
    exposed_debugging_port: 2985
  production:
    instance_name: prod
    db_password: prod_pass
    simplifier_subdomain: prod
    exposed_debugging_port: 2986
```

- _domain_suffix_ (required): domain suffix for all simplifier instances
- _secure_ (optional for custom certificates): TLS Certs
  - _type_ (required): ```custom``` 
  - _key_ (required): PRIVATE KEY
  - _wildcard_crt_for_domain_suffix_ (required): CERTIFICATE
- _secure_ (optional for letsencrypt): TLS Certs
  - _type_ (required): ```letsencrypt``` 
  - _mail_ (required): administrative email address
- _instances_ (required): map of instance definitions
  - _instance_name_ (required): name of instance
  - _db_password_ (required): database password for the instance
  - _simplifier_subdomain_ (required): subdomain
  - _exposed_debugging_port_ (required): debugging port
  - _override_simplifier_image_name_ (optional): override simplifier image with custom (maybe labs or preview simplifier image)
  - _override_launchpad_image_name_ (optional): override launchpad image with custom 
  - _override_wfdt_image_name_ (optional): override workflow designtime image with custom
  - _override_wfrt_image_name_ (optional): override workflow runtime image with custom 
  - _simplifier_labels_ (optional): list of additional labels appended to the simplifier container
  - _simplifier_version_ (required): simplifier version 
  - _enable_metrics_ (optional): if ```true``` jmx metrics for plugins and simplifier will be available 

It is possible to define default values for each instances in the ```instance_default.yaml```. 
Currently the simplifier version is defined here. Any other values mentioned in 
the above description from _instance_ are possible in ```instance_default.yaml```.

#### (4) apply your deployment

To run a deployment, defined in a yaml file, you need to run the ```./apply.sh```
tool:

```
usage: ./apply.sh [-fh] -p parameter_file.yaml
  -h                  show help text
  -f                  force overwrite
  -p parameter_file   use <parameter_file>
```

This will create the required compose files in the "include" directory, 
according to the definitions in the yaml file, and restart the 
"docker compose" setup.

It is possible to manage the compose setup manually via the "docker compose" tool.

It is also possible to modify the files created in "include" manually. If you do so 
and rerun the ```./apply.sh```, your manually changed files will not be overwritten.
The apply tool will exit with a warning then, unless you set the "-f" switch for apply.

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