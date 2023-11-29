EXECUTABLE=kbot
WINDOWS=$(EXECUTABLE)_windows_amd64.exe
LINUX=$(EXECUTABLE)_linux_amd64
DARWIN=$(EXECUTABLE)_darwin_amd64
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

build: windows linux darwin

windows: $(WINDOWS) ## Build for Windows

linux: $(LINUX) ## Build for Linux

darwin: $(DARWIN) ## Build for Darwin (macOS)

$(WINDOWS):
	env GOOS=windows GOARCH=amd64 go build -v -o  $(WINDOWS) -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

$(LINUX):
	env GOOS=linux GOARCH=amd64 go build -v -o  $(LINUX) -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

$(DARWIN):
	env GOOS=darwin GOARCH=amd64 go build -v -o  $(DARWIN) -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

	
	
	
	## CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o $(WINDOWS) kbot -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

clean:
	rm -f $(WINDOWS) $(LINUX) $(DARWIN)