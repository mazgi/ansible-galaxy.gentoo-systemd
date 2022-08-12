# gentoo-systemd-remote

[![default](https://github.com/mazgi/ansible-galaxy.gentoo-systemd-remote/workflows/default/badge.svg)](https://github.com/mazgi/ansible-galaxy.gentoo-systemd-remote/actions/workflows/default.yml)

## How to set up

### How to set up your local environment

You need create the `.env` file as follows.

```console
rm -f .env
test $(uname -s) = 'Linux' && echo "UID=$(id -u)\nGID=$(id -g)" >> .env
cat<<EOE >> .env
CURRENT_ENV_NAME=production
DOCKER_GID=$(getent group docker | cut -d : -f 3)
EOE
```

## How to run

https://www.system-rescue.org/manual/Booting_SystemRescueCd/

```console
rootpass=pass nofirewall
```

```console
ssh-keygen
```

```console
curl -L github.com/$YOUR_GITHUB_ACCOUNT.keys > ~/.ssh/authorized_keys
```

```console
ip a show
```

```console
export TARGET_IPADDR=192.0.2.1
```

```console
ssh-keygen -R $TARGET_IPADDR
```

```console
ssh $TARGET_IPADDR -l root
```

Now you can make provisioning as follows.

```console
docker compose up --detach && docker compose logs --follow
^c
```

```console
docker compose exec provisioning ansible --inventory $TARGET_IPADDR, --user root --module-name ping all
docker compose exec provisioning ansible-playbook --inventory $TARGET_IPADDR, /project/provisioning/site.yml
```

And, you can use [`--extra-vars` args](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#defining-variables-at-runtime) to provide your specific values for provisioning.

```console
docker compose run provisioning ansible-playbook\
 --inventory $TARGET_IPADDR,\
 --extra-vars '{"main_block_device":"sda","network_interface_name_pattern":"eth*"}'\
 --extra-vars 'new_hostname=lin-work1-vm'\
 /project/provisioning/site.yml
```

Moreover, you can start provisioning by a point you want using the [`--start-at-task` arg](https://docs.ansible.com/ansible/latest/user_guide/playbooks_startnstep.html#start-at-task).

```console
docker compose run provisioning ansible-playbook --inventory $TARGET_IPADDR, /project/provisioning/site.yml --start-at-task='Verify basic packages'
docker compose run provisioning ansible-playbook --inventory $TARGET_IPADDR, /project/provisioning/site.yml --start-at-task='Build the kernel'
```
