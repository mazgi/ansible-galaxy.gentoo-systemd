# An Ansible Playbook to install Gentoo Linux that works with UEFI and systemd

This repository is an [Ansible Playbook](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html) to install Gentoo Linux into your physical and virtual machines. This playbook also uses SSH to connect to your target machine, the same as other playbooks.

The Gentoo Linux will be set up with the following conditions and components.

- <ins>AMD64(aka x86_64, x64)</ins> is the only architecture supported on this playbook
- <ins>UEFI</ins> booting; legacy BIOS is not supported
- Using and occupying <ins>a whole empty SSD/HDD</ins>
  - The playbook cannot configure multiple booting from one device or straddle various devices. If you target a device with preserved data, the behavior will not be defined.
- [<ins>BTRFS</ins>](https://wiki.gentoo.org/wiki/Btrfs) is used as the main filesystem
  - BTRFS is a very safe, secure, and stable filesystem.
- Using [<ins>systemd</ins>](https://wiki.gentoo.org/wiki/Systemd) as the init system(aka super daemon)
  - The playbook does not consider OpenRC.
  - As a matter of fact, the system will be built on the system based on the systemd [stage3](https://wiki.gentoo.org/wiki/Stage_tarball#Stage_3) archive and will be selected `default/linux/{ARCH}/{STABLE}/systemd` profile after the setup process is completed.
- A default user who can elevate themselves to root using the `sudo` command will be created
- Does not consider GUI or audio

## Requirements for Using this Playbook

There are only two things you should prepare to use this playbook.

First, <ins>Docker and [Docker Compose](https://docs.docker.com/compose/)</ins> are needed. This method relies on containers, but it will free you from any other dependencies, such as ansible, python, and others, which is an excellent advantage.

Second, you need <ins>a bootable Linux system</ins> that can mount a block device to install Gentoo Linux. Typically, you can use a Gentoo [Minimal Installation CD](https://wiki.gentoo.org/wiki/Bootable_media) and a [SystemRescue](https://www.system-rescue.org/) image for that purpose.

## How to Use the Playbook?

### Place the .env File if you are using Linux

:information_source: Are you using macOS or Windows? If so, there is nothing to do in this section; please skip it.

If you are using Linux, you need to create the `.env` file like the following.

```.env
GID=1234
UID=1234
```

One trick to creating the `.env` file and fill in `UID` and `GID` is to do the following command.

```console
test $(uname -s) = 'Linux' && {
  echo -e "GID=$(id -g)"
  echo -e "UID=$(id -u)"
} >> .env || :
```

Those `GID` and `UID` will be used to indicate the values when the containers are built. This makes a user who has the same GID and UID as you on the container.  
This is important when using a container on Linux, and you will avoid creating any files that you don't have proper ownership of or can't fully control.

### Start the Containers

You can start the containers using the `docker compose up` command.

```console
docker compose up --wait
```

:information_source: After completing the container starting process, you can ensure these are running correctly using the `docker compose ps` and `docker compose logs` commands.

```
❯ docker compose logs --no-log-prefix provisioning
Reset the status.
Starting galaxy collection install process
Nothing to do. All requested collections are already installed. If you want to reinstall them, consider using `--force`.
Update the status to succeeded.
{
  "succeeded": true
}
✅ You are all set!
┬ ┬┌─┐┬ ┬┬─┐┌─┐  ┌─┐┬  ┬    ┌─┐┌─┐┌┬┐
└┬┘│ ││ │├┬┘├┤   ├─┤│  │    └─┐├┤  │
 ┴ └─┘└─┘┴└─└─┘  ┴ ┴┴─┘┴─┘  └─┘└─┘ ┴
Turn in infinity sleep...
```

### Boot your Target Machine using Bootable Linux Image

#### When Booting from Gentoo Minimal Installation CD

Please specify the `dosshd` option at bootup.

#### When Booting from SystemRescue

Please specify the `nofirewall` option at bootup.

### On Your Target: Accept SSH and Make Sure of the Environment

On your target machine, register the public key that is used to connect via SSH your target from your local machine.

```console
mkdir -p ~/.ssh
curl -L github.com/YOUR_ACCOUNT.keys | tee ~/.ssh/authorized_keys
```

On the target, locate the IP address that is assigned and write it down a record.

```console
ip a
```

On the target, locate the block device that you want to install the system on and keep a record.

```console
lsblk
```

### Define your Inventory

Write out the inventory as a file with the target IP address that we looked at in the previous section and the hostname you want to name.

For instance, you can create the `config/inventories/hosts.yml` file as below:

```yaml
all:
  hosts:
    host-1.local:
      ansible_host: 192.168.1.1
```

After that, you can check the connection to your target as follows.

```console
docker compose exec provisioning ansible\
 --inventory config/inventories/hosts.yml\
 --limit host-1.local\
 --module-name ping\
 --user root\
 all
```

```
❯ docker compose exec provisioning ansible --inventory config/inventories/hosts.yml --limit host-1.local --module-name ping --user root all
host-1.local | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### Run the Playbook

Now, you can run your playbook as follows :clap:

```console
docker compose exec provisioning ansible-playbook\
 --inventory config/inventories/hosts.yml\
 --limit host-1.local\
 site.yml
```

Is it taking forever?  
That's great! While taking several cups of :coffee: and :tea:, you can watch over your machine :egg: :hatching_chick: :hatched_chick: :rooster:
