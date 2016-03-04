# Ansible GentooInstallBattle

## How To Use

### How To install

```shellsession
$ brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
$ sudo easy_install pip
$ sudo pip install virtualenv
$ export PIP_RESPECT_VIRTUALENV=true
$ export PATH="${HOME}/.local/bin:${PATH}"
$ export PYTHONPATH="${HOME}/.local/lib64/python2.7/site-packages:${PYTHONPATH}"
$ git clone https://github.com/mazgi/ansible-gentooinstallbattle.git
# cd ansible-gentooinstallbattle
$ virtualenv --no-site-packages --distribute --python=$(which python2.7) .
$ source bin/activate
(envdir)$ pip install -r requirements.txt
```

### How To Play

#### Boot up your machine

First, boot up your machine from [SystemRescueCd](https://www.system-rescue-cd.org/SystemRescueCd_Homepage).  
And you should set up at least one network for SSH connection.

#### Run ansible-playbook from your Control Machine

```shellsession
$ export PIP_RESPECT_VIRTUALENV=true
$ export PATH="${HOME}/.local/bin:${PATH}"
$ export PYTHONPATH="${HOME}/.local/lib64/python2.7/site-packages:${PYTHONPATH}"
$ source bin/activate
(envdir)$ ansible-playbook -i 10.11.12.13, site.gentooinstallbattle.yml
```
