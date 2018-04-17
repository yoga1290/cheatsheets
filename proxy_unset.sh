# sudo sh proxy_unset.sh

# Ubuntu/ apt-get
##################
rm /etc/apt/apt.conf

#######################
# DOCKER
##############################
# see https://docs.docker.com/engine/admin/systemd/#http-proxy
# see https://docs.docker.com/config/daemon/systemd/#httphttps-proxy

CONFIG_FILE='/etc/systemd/system/docker.service.d/http-proxy.conf';
CONFIG_FILE2='/etc/systemd/system/docker.service.d/https-proxy.conf';
rm $CONFIG_FILE $CONFIG_FILE2

systemctl daemon-reload;
systemctl restart docker;
#TODO: verify: systemctl show --property=Environment docker

rm /home/$USER/.docker/proxy.env
# to be passed while starting containers:
# e.g: docker run --env-file ~/.docker/proxy.env -it -p 8000:8000 --net="host" --rm --name container web-portal


# see https://docs.docker.com/network/proxy/#configure-the-docker-client#configure-the-docker-client
rm /home/$USER/.docker/config.json;

###########################################################

# GIT
git config --global --unset http.proxy;

#TODO NPM
#TODO BOWER
