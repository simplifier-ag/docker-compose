package database

import (
	"errors"
	"fmt"
)

type FatalOn string

const (
	OnNothing          FatalOn = "onNothing"
	OnConnect                  = "onConnect"
	OnCreateDB                 = "onCreateDB"
	OnGrandPermissions         = "onGrant"
)

func ListAvailable() []FatalOn {
	return []FatalOn{OnNothing, OnConnect, OnCreateDB, OnGrandPermissions}
}

func (f FatalOn) IsValid() error {
	switch f {
	case OnNothing, OnConnect, OnCreateDB, OnGrandPermissions:
		return nil
	}
	return errors.New(fmt.Sprintf("invalid FatalOn definition :'%s'", f))
}

func (f FatalOn) GetAllLevels() map[FatalOn]bool {
	switch f {
	case OnNothing:
		return map[FatalOn]bool{}
	case OnConnect:
		return map[FatalOn]bool{
			OnConnect: true,
		}
	case OnCreateDB:
		return map[FatalOn]bool{
			OnCreateDB: true,
			OnConnect:  true,
		}
	case OnGrandPermissions:
		return map[FatalOn]bool{
			OnGrandPermissions: true,
			OnCreateDB:         true,
			OnConnect:          true,
		}
	}
	return map[FatalOn]bool{}
}
