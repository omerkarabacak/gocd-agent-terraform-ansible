

FROM golang:alpine3.6

ADD https://github.com/krallin/tini/releases/download/v0.15.0/tini-static-amd64 /usr/local/sbin/tini
ADD https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 /usr/local/sbin/gosu

# allow mounting ssh keys, dotfiles, and the go server config and data
VOLUME /godata

# force encoding
ENV LANG=en_US.utf8

#### GO Agent setup ####

RUN \
# add mode and permissions for files we added above
  chmod 0755 /usr/local/sbin/tini && \
  chown root:root /usr/local/sbin/tini && \
  chmod 0755 /usr/local/sbin/gosu && \
  chown root:root /usr/local/sbin/gosu && \
# add our user and group first to make sure their IDs get assigned consistently,
# regardless of whatever dependencies get added
  addgroup -g 1000 go && \
  adduser -D -u 1000 -G go go && \
  apk --no-cache upgrade && \
  apk add --no-cache openjdk8-jre-base git mercurial subversion openssh-client bash curl ansible && \
# download the zip file
  curl --fail --location --silent --show-error "https://download.gocd.org/binaries/17.8.0-5277/generic/go-agent-17.8.0-5277.zip" > /tmp/go-agent.zip && \
# unzip the zip file into /go-agent, after stripping the first path prefix
  unzip /tmp/go-agent.zip -d / && \
  mv /go-agent-17.8.0 /go-agent && \
  rm /tmp/go-agent.zip

RUN go get github.com/hashicorp/terraform

ADD docker-entrypoint.sh /

RUN ["chmod", "+x", "/docker-entrypoint.sh"]

ENTRYPOINT ["/docker-entrypoint.sh"]
