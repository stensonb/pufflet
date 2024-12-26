build:
	cd cmd/pufflet && go build && mv pufflet ../../build

int-test: build
	APISERVER_CERT_LOCATION="/Users/bryanstenson/git/fileserver/data/uploads/apiserver.crt" APISERVER_KEY_LOCATION="/Users/bryanstenson/git/fileserver/data/uploads/apiserver.key" APISERVER_CA_CERT_LOCATION="/Users/bryanstenson/git/fileserver/data/uploads/ca.crt" build/pufflet --provider mock --provider-config cmd/pufflet/internal/provider/mock/mock.config.json

.PHONY: build
