FROM ruby:wheezy

# gcc for cgo
RUN apt-get update && apt-get install -y \
		gcc libc6-dev make \
		--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.5.2
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA1 cae87ed095e8d94a81871281d35da7829bd1234e

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA1  golang.tar.gz" | sha1sum -c - \
	&& tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

# get godep
RUN go get github.com/tools/godep
