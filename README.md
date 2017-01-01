# multimachines
> setup web developer environments - development / staging server / production server - Ruby

- Python(2.7) - [Pyenv](https://github.com/yyuu/pyenv)
- Ansible - [Install Docs](http://docs.ansible.com/ansible/intro_installation.html)
  - ```pip install ansible```
- [vagrant](https://www.vagrantup.com/)

## setup
```
# Start up vagrant machines
$ vagrant up

# Run initial setup of machines
$ cd server-setup-anisble
$ ansible-playbook provision.yml
```

## other
```
# Run command on all remote machines
$ ansible all -a "sudo apt-get update" -u vagrant

# Install plugin from current project
$ ansible-galaxy install --roles-path . <PROJECT NAME>

# Run commands based on tags
$ ansible-playbook provision.yml --tags "configuration,packages"
```
