FROM gzm55/vpn-client as openconnect

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
  apk add --no-cache openjdk8-jre-base git mercurial subversion openssh-client bash curl ansible \
	supervisor lz4-libs gnutls gnutls-utils iptables libev libintl \
	libnl3 libseccomp linux-pam lz4 openssl libxml2 nmap-ncat socat openssh-client && \
# download the zip file
  curl --fail --location --silent --show-error "https://download.gocd.org/binaries/17.8.0-5277/generic/go-agent-17.8.0-5277.zip" > /tmp/go-agent.zip && \
	curl --fail --location --silent --show-error "https://releases.hashicorp.com/terraform/0.10.6/terraform_0.10.6_linux_amd64.zip?_ga=2.248615364.279314359.1506357434-1981675648.1506108613" > /tmp/terraform.zip && \
# unzip the zip file into /go-agent, after stripping the first path prefix
  unzip /tmp/go-agent.zip -d / && \
	unzip /tmp/terraform.zip -d / && \
	mv /terraform /usr/bin/ && \
  mv /go-agent-17.8.0 /go-agent && \
  rm /tmp/go-agent.zip && \
  rm /tmp/terraform.zip

#### openconnect setup ####

RUN mkdir -p /etc/vpnc
COPY --from=openconnect /usr/local/lib /usr/local/lib
COPY --from=openconnect /usr/local/sbin /usr/local/sbin
COPY vpnc-script /etc/vpnc/vpnc-script

#### running setup ###
COPY supervisord.conf /etc/supervisord.conf

ADD docker-entrypoint.sh /

ADD start-openconnect.sh /

RUN ["chmod", "+x", "/docker-entrypoint.sh"]
RUN ["chmod", "+x", "/etc/vpnc/vpnc-script"]
RUN ["chmod", "+x", "/start-openconnect.sh"]

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
