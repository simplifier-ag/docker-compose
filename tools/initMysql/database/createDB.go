package database

import (
	"fmt"
	"github.com/golang/glog"
)

func CreateDB(name string, connection Connection, fatalOn map[FatalOn]bool) bool {
	con := connection.GetHandle(fatalOn)
	if con == nil {
		return false
	}
	_, err := con.Exec(fmt.Sprintf("CREATE DATABASE IF NOT EXISTS %s", name))
	if err != nil {
		if _, exists := fatalOn[OnCreateDB]; exists {
			glog.Fatal(fmt.Sprintf("error creating DB '%s' : %s", name, err.Error()))
		} else {
			glog.Error(fmt.Sprintf("error creating DB '%s' : %s", name, err.Error()))
		}
		return false
	}
	return true
}
