package main

import (
	"flag"
	"fmt"
	"github.com/golang/glog"
	"gopkg.in/yaml.v3"
	"main/database"
	"os"
)

type DbConnectionValues struct {
	User     string
	Pass     string
	Endpoint string
}
type CMDLineArguments struct {
	config             string
	dbConnectionValues DbConnectionValues
}

var arguments CMDLineArguments

func init() {
	flag.Set("logtostderr", "true")
	flag.StringVar(&arguments.config, "config", "mysqlInit.yaml", "file for config")
	flag.StringVar(&arguments.dbConnectionValues.User, "user", "root", "db user")
	flag.StringVar(&arguments.dbConnectionValues.Pass, "pass", "root", "db pass")
	flag.StringVar(&arguments.dbConnectionValues.Endpoint, "endpoint", "localhost:3306", "db connection")
	flag.Parse()
}

type ConfigDef struct {
	Databases     []string         `yaml:"databases,omitempty"`
	DatabaseOwner string           `yaml:"database-owner"`
	ErrorLevel    database.FatalOn `yaml:"error-level"`
}

func main() {
	glog.Info("start mysqlInit")

	content, err := os.ReadFile(arguments.config)
	if err != nil {
		glog.Fatal(err.Error())
	}
	config := ConfigDef{}
	yaml.Unmarshal(content, &config)
	if err != nil {
		glog.Fatal(err.Error())
	}
	err = config.ErrorLevel.IsValid()
	if err != nil {
		var available = ""
		for _, item := range database.ListAvailable() {
			available = available + string(item) + ", "
		}
		glog.Error(fmt.Sprintf("available error levels: %s", available))
		glog.Fatal(err.Error())
	}

	errorLevels := config.ErrorLevel.GetAllLevels()

	conn, err := database.NewConnection(
		arguments.dbConnectionValues.Endpoint,
		arguments.dbConnectionValues.User,
		arguments.dbConnectionValues.Pass,
		errorLevels,
	)

	if err == nil {
		for _, db := range config.Databases {
			glog.Info(fmt.Sprintf("processing db: %s", db))
			database.CreateDB(db, *conn, errorLevels)
			database.GrantPermissions(db, config.DatabaseOwner, *conn, errorLevels)
		}
	}
	os.Exit(0)
}
