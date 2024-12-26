build:
	cd cmd/pufflet && go build && mv pufflet ../../build

buildobsd:
	cd cmd/pufflet && GOOS=openbsd GOARCH=amd64 CGO_ENABLED=0 go build && mv pufflet ../../build/pufflet.obsd

deployobsd: buildobsd
	scp build/pufflet.obsd obsd:~/pufflet/

int-test: build
	APISERVER_CERT_LOCATION="/Users/bryanstenson/git/fileserver/data/uploads/apiserver.crt" APISERVER_KEY_LOCATION="/Users/bryanstenson/git/fileserver/data/uploads/apiserver.key" APISERVER_CA_CERT_LOCATION="/Users/bryanstenson/git/fileserver/data/uploads/ca.crt" build/pufflet --provider mock --provider-config cmd/pufflet/internal/provider/mock/mock.config.json

.PHONY: build
