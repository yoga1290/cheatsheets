# sudo sh proxy.sh

export http_proxy='http://DOMAIN:PORT';
export https_proxy='http://DOMAIN:PORT';
export HTTP_PROXY='http://DOMAIN:PORT';
export HTTPS_PROXY='http://DOMAIN:PORT';

# Ubuntu/ apt-get
echo "Acquire::http::Proxy \"$http_proxy\";" > /etc/apt/apt.conf

# see https://docs.docker.com/engine/admin/systemd/#http-proxy
mkdir -p /etc/systemd/system/docker.service.d;
CONFIG_FILE='/etc/systemd/system/docker.service.d/http-proxy.conf';
echo "[Service]\n" >$CONFIG_FILE;
echo 'Environment="HTTP_PROXY=http://DOMAIN:PORT" "NO_PROXY=localhost,127.0.0.1,docker-registry.somecorporation.com"' >>$CONFIG_FILE;

echo "HTTP_PROXY=$HTTP_PROXY" >/root/.docker/proxy.env
echo "HTTPS_PROXY=$HTTPS_PROXY" >>/root/.docker/proxy.env
echo "http_proxy=$http_proxy" >>/root/.docker/proxy.env
echo "https_proxy=$https_proxy" >>/root/.docker/proxy.env
# to be passed while starting containers:
# e.g: docker run --env-file ~/.docker/proxy.env -it -p 8000:8000 --net="host" --rm --name container web-portal
systemctl daemon-reload;
systemctl restart docker;


# GIT
git config --global http.proxy $HTTP_PROXY;

# NPM
npm config set proxy $HTTP_PROXY;
npm config set https-proxy $HTTPS_PROXY;

# BOWER:
echo '{' >~/.bowerrc;
echo '  "proxy": "http://DOMAIN:PORT/",' >>~/.bowerrc;
echo '  "https-proxy":"http://DOMAIN:PORT/"' >>~/.bowerrc;
echo '}' >>~/.bowerrc;
