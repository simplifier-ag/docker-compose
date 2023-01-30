## mysqlinit

init Database with a given schema for database

### config file (yaml)

```yaml
database-owner: someone
error-level: onCreateDB
databases:
  - aaa
  - bbb
```

- _database-owner_: user to which database are assigned to
- _error-level_: error level wich defines when tool returns a fata error
    - _onNothing_: tool returns always success
	- _onConnect_: tool returns an unsuccessfull exit code if it is not able to connect to DB
	- _onCreateDB_: tool returns an unsuccessfull exit code if it is not able to create the DB
	- _onGrant_: tool returns an unsuccessfull exit code if it is not able to grant permissions to created DBs
- _databases_: list of databases to be created

### commandline params
- _-config_: path to config file
- _-user_: admin user for mysql
- _-pass_: admin pass for mysql
- _-endpoint_: mysql endpoint

## docker-compose setup & usage

see sub directory ```sandbox```

(It is most likely that, if you want to test the sandbox docker-compose 
setup, you need to create a "mysql" dir in there...)

