# sudo sh proxy.sh

export http_proxy='http://DOMAIN:PORT';
export https_proxy='http://DOMAIN:PORT';
export HTTP_PROXY=$http_proxy;
export HTTPS_PROXY=$https_proxy;

# Ubuntu/ apt-get
echo "Acquire::http::Proxy \"$http_proxy\";" > /etc/apt/apt.conf

# see https://docs.docker.com/engine/admin/systemd/#http-proxy
# see https://docs.docker.com/config/daemon/systemd/#httphttps-proxy
mkdir -p /etc/systemd/system/docker.service.d;
CONFIG_FILE='/etc/systemd/system/docker.service.d/http-proxy.conf';
echo "[Service]" >$CONFIG_FILE;
echo "Environment=\"HTTP_PROXY=$http_proxy\" \"NO_PROXY=localhost,127.0.0.1,docker-registry.somecorporation.com\"" >>$CONFIG_FILE;
systemctl daemon-reload;
systemctl restart docker;
#TODO: verify: systemctl show --property=Environment docker

# see https://docs.docker.com/network/proxy/#configure-the-docker-client#configure-the-docker-client
echo -e "{\n \"proxies\":\n {\n   \"default\":\n   {\n     \"httpProxy\": \"$http_proxy\",\n     \"noProxy\": \"*.test.example.com,.example2.com\"\n   }\n }\n}" >/home/$USER/.docker/config.json

echo "HTTP_PROXY=$HTTP_PROXY" >/home/$USER/.docker/proxy.env
echo "HTTPS_PROXY=$HTTPS_PROXY" >>/home/$USER/.docker/proxy.env
echo "http_proxy=$http_proxy" >>/home/$USER/.docker/proxy.env
echo "https_proxy=$https_proxy" >>/home/$USER/.docker/proxy.env
# to be passed while starting containers:
# e.g: docker run --env-file ~/.docker/proxy.env -it -p 8000:8000 --net="host" --rm --name container web-portal


# GIT
git config --global http.proxy $HTTP_PROXY;

# NPM
npm config set proxy $HTTP_PROXY;
npm config set https-proxy $HTTPS_PROXY;

# BOWER:
echo '{' >~/.bowerrc;
echo "  \"proxy\": \"$http_proxy\"," >>~/.bowerrc;
echo "  \"https-proxy\": \"$https_proxy\"," >>~/.bowerrc;
echo '}' >>~/.bowerrc;
