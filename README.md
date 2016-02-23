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
$ virtualenv --no-site-packages --distribute --python=$(which python2.7) .
$ source bin/activate
(envdir)$ pip install -r requirements.txt
```

### How To Use

```shellsession
$ export PIP_RESPECT_VIRTUALENV=true
$ export PATH="${HOME}/.local/bin:${PATH}"
$ export PYTHONPATH="${HOME}/.local/lib64/python2.7/site-packages:${PYTHONPATH}"
$ source bin/activate
(envdir)$ ansible-playbook -i 10.11.12.13, site.gentooinstallbattle.yml
```
