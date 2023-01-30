package database

import (
	"fmt"
	"github.com/golang/glog"
)

func GrantPermissions(dbName string, userName string, connection Connection, fatalOn map[FatalOn]bool) bool {
	con := connection.GetHandle(fatalOn)
	if con == nil {
		return false
	}
	sqlstmt := fmt.Sprintf("GRANT ALL PRIVILEGES ON %s.* TO `%s`@`%%`", dbName, userName)
	glog.Info(sqlstmt)
	_, err := con.Exec(sqlstmt)
	if err != nil {
		if _, exists := fatalOn[OnGrandPermissions]; exists {
			glog.Fatal(fmt.Sprintf("error grant permissions for DB '%s' : %s", dbName, err.Error()))
		} else {
			glog.Error(fmt.Sprintf("error grant permissions for DB '%S' : %s", dbName, err.Error()))
		}
		return false
	}
	_, err = con.Exec("FLUSH PRIVILEGES;")
	if err != nil {
		if _, exists := fatalOn[OnGrandPermissions]; exists {
			glog.Fatal("flush privileges")
		} else {
			glog.Error("flush privileges")
		}
		return false
	}
	return true
}
