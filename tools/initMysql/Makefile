version = 0.1.0
name = mysqlinit
local_tag = $(name):$(version)

all: build

docker:
	docker build -t $(local_tag) .

build:
	go mod tidy
	rm -f $(name)
	CGO_ENABLED=0 GOOS=linux go build -o $(name) -ldflags="-s -w" main.go
	gzexe $(name)
	rm -f $(name)~

run:
	go run main.go

clean:
	rm -f  $(name) *~
