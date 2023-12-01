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

windows: ## Build for Windows
	env GOOS=windows GOARCH=amd64 go build -v -o  $(EXECUTABLE) -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

linux: $(LINUX) ## Build for Linux
	env GOOS=linux GOARCH=amd64 go build -v -o  $(EXECUTABLE) -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

macos: $(MACOS) ## Build for Darwin (macOS)
	env GOOS=darwin GOARCH=amd64 go build -v -o  $(EXECUTABLE) -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

m1: $(M1) ## Build for Darwin (macOS)
	env GOOS=darwin GOARCH=arm64 go build -v -o  $(EXECUTABLE) -ldflags "-X="github.com/maxAndy-803474/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${T}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${T}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${T} -f