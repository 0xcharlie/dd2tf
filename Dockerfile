FROM golang:1.15

# https://github.com/amnk/dd2tf
# define DATADOG_API_KEY & DATADOG_APP_KEY at runtime

# install dependencies & pull main app repo
RUN go get -v github.com/golang/dep/cmd/dep
RUN go get -v github.com/go-bindata/go-bindata
# go get doesn't seem to install this automagically, build it
WORKDIR /go/src/github.com/go-bindata/go-bindata
RUN make

# pull main app repo
RUN go get -v github.com/amnk/dd2tf

# build main app
WORKDIR /go/src/github.com/amnk/dd2tf
RUN dep ensure -v
RUN go generate
RUN go build
RUN go install

ENTRYPOINT ["dd2tf"]