APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=maksymonko
EXECUTABLE=kbot
T=$(shell dpkg --print-architecture)
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

build: windows linux macos m1
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

windows: $(WINDOWS) ## Build for Windows

linux: $(LINUX) ## Build for Linux

macos: $(MACOS) ## Build for Darwin (macOS)

m1: $(M1) ## Build for Darwin (macOS)

$(WINDOWS):
	env GOOS=windows GOARCH=amd64 go build -v -o  $(EXECUTABLE) -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

$(LINUX):
	env GOOS=linux GOARCH=amd64 go build -v -o  $(EXECUTABLE) -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

$(MACOS):
	env GOOS=darwin GOARCH=amd64 go build -v -o  $(EXECUTABLE) -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

$(M1):
	env GOOS=darwin GOARCH=arm64 go build -v -o  $(EXECUTABLE) -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${T}

push:
	docker push ${REGESTRY}/${APP}:${VERSION}-${T}

clean:
	rm -rf kbot
	docker rmi ${REGESTRY}/${APP}:${VERSION}-${T} -f