package database

import (
	"database/sql"
	"fmt"
	"github.com/go-sql-driver/mysql"
	"github.com/golang/glog"
)

type Connection struct {
	Endpoint   string
	User       string
	Pass       string
	connection *sql.DB
}

func NewConnection(endpoint string, user string, pass string, fatalOn map[FatalOn]bool) (*Connection, error) {
	c := Connection{
		connection: nil,
		User:       user,
		Pass:       pass,
		Endpoint:   endpoint,
	}
	var err error = nil
	c.connection, err = c.connect()
	if err == nil {
		return &c, nil
	} else {
		if _, exists := fatalOn[OnConnect]; exists {
			glog.Fatal(fmt.Sprintf("cannot connection to '%s'", c.Endpoint))
		} else {
			glog.Error(fmt.Sprintf("cannot connection to '%s'", c.Endpoint))
		}
		return nil, err
	}
}

func (c *Connection) connect() (*sql.DB, error) {
	cfg := mysql.Config{
		User:                 c.User,
		Passwd:               c.Pass,
		Net:                  "tcp",
		Addr:                 c.Endpoint,
		DBName:               "mysql",
		AllowNativePasswords: true,
	}
	glog.Info(cfg.FormatDSN())
	// Get a database handle.
	db, err := sql.Open("mysql", cfg.FormatDSN())
	if err == nil {
		// test connectivity
		_, err = db.Exec("select now();")
	}
	return db, err
}

func (c *Connection) GetHandle(fatalOn map[FatalOn]bool) *sql.DB {
	if c.connection != nil {
		return c.connection
	} else {
		if _, exists := fatalOn[OnConnect]; exists {
			glog.Fatal(fmt.Sprintf("no connection to '%s'"), c.Endpoint)
		} else {
			glog.Error(fmt.Sprintf("no connection to '%s'"), c.Endpoint)
		}
	}
	return nil
}
