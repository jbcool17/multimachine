# multimachines

[![standard-readme compliant](https://img.shields.io/badge/standard--readme-OK-green.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)
[![Stories in Progress](https://badge.waffle.io/jbcool17/multimachine.svg?label=In%20Progress&title=In%20Progress)](http://waffle.io/jbcool17/multimachine)
[![Stories in Ready](https://badge.waffle.io/jbcool17/multimachine.svg?label=ready&title=Ready)](http://waffle.io/jbcool17/multimachine)
[![Stories in Done](https://badge.waffle.io/jbcool17/multimachine.svg?label=done&title=Done)](http://waffle.io/jbcool17/multimachine)
[![Stories in Backlog](https://badge.waffle.io/jbcool17/multimachine.svg?label=backlog&title=backlog)](http://waffle.io/jbcool17/multimachine)

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

This project uses the Rails 5 API setting for the backend and a jekyll site generator to compile various mini sites using JS FrontEnd Frameworks(React) via custom scripts. They are currently hosted from github.io: [railsapijwt-frontend](https://jbcool17.github.io/railsapijwt-frontend/). The purpose of this is to learn about APIs and Javascript Front-End Frameworks.
- Frontend repo is located at: [Frontend Repo](https://github.com/jbcool17/railsapijwt-frontend)

## Table of Contents

- [Development](#development)
- [Usage](#usage)
- [Specs](#specs)
- [Testing](#testing)
- [License](#license)

## Development
```
# TODO
```

## Usage
```
#TODO
```

## Specs
- Ruby v2.3.1 / Rails v5.0.0.1
- JWT
- Database - Development / Sqlite3 - Production / Postgresql

## Testing
- Rspec
- more to come

## License

MIT © John Brilla
