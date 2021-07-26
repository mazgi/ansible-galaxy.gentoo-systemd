# gentoo-systemd-remote

[![default](https://github.com/mazgi/gentoo-systemd-remote/workflows/default/badge.svg)](https://github.com/mazgi/gentoo-systemd-remote/actions?query=workflow%3Adefault)

## How to set up

### How to set up your local environment

You need create the `.env` file as follows.

```shellsession
rm -f .env
test $(uname -s) = 'Linux' && echo "UID=$(id -u)\nGID=$(id -g)" >> .env
cat<<EOE >> .env
CURRENT_ENV_NAME=production
DOCKER_GID=$(getent group docker | cut -d : -f 3)
EOE
```

## How to run

https://www.system-rescue.org/manual/Booting_SystemRescueCd/

```shellsession
rootpass=pass nofirewall
```

```shellsession
ssh-keygen
```

```shellsession
curl -L github.com/mazgi.keys > ~/.ssh/authorized_keys
```

```shellsession
ip a show
```

```shellsession
ssh-keygen -R 192.0.2.1
```

```shellsession
ssh 192.0.2.1 -l root
```

Now you can make provisioning as follows.

```shellsession
docker compose up
docker compose run provisioning ansible --inventory 192.0.2.1, --user root --module-name ping all
docker compose run provisioning ansible-playbook --inventory 192.0.2.1, /project/provisioning/site.yml
```

```shellsession
docker compose run provisioning ansible-playbook --inventory 192.0.2.1, /project/provisioning/site.yml --start-at-task='Verify basic packages'
docker compose run provisioning ansible-playbook --inventory 192.0.2.1, /project/provisioning/site.yml --start-at-task='Build the kernel'
```
