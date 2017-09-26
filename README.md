# gocd-agent-terraform-ansible with Openconnect juniper VPN client support

This image contains following stack:

- golang 1.9
- terraform 0.10.6
- ansible 2.3.0.0-r1
- openconnect
- GoCD Agent 17.8.0

### running :

When you run this image, Supervisord will handle 2 different process;
 1. GoCD agent startup
 2. Openconnect startup (Optional)

#### with openconnect juniper support

Just run with providing the openconnect parameters to docker run:

```
docker run -d --privileged --restart=always \
-e AGENT_AUTO_REGISTER_KEY='myprecious key' \
-e GO_SERVER_URL='https://mygocd/go' \
-e AGENT_AUTO_REGISTER_RESOURCES='provisioning' \
-e AGENT_AUTO_REGISTER_ENVIRONMENTS='prod,qa,performance' \
-e OPENCONNECT_PASSWORD='mystrongpassword+' \
-e OPENCONNECT_HOST='https://myjuniper' \
-e OPENCONNECT_USER='myuser' \
-e OPENCONNECT_SERVER_CERT='sha256:xyz' \
yaman/gocd-agent-terraform-ansible
```

Please note that running with openconnect support will require to pass `--privileged` flag to docker for openconnect to create `tun` devices for vpn connection.

#### without openconnect support

Providing only GoCD related parameters would be enough:

```
docker run -d --restart=always \
-e AGENT_AUTO_REGISTER_KEY='myprecious key' \
-e AGENT_AUTO_REGISTER_RESOURCES='provisioning' \
-e AGENT_AUTO_REGISTER_ENVIRONMENTS='prod,qa,performance' \
-e GO_SERVER_URL='https://mygocd/go' \
yaman/gocd-agent-terraform-ansible
```
