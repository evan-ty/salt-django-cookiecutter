# Salt states for Django deployment

This cookiecutter template creates a set of states and pillars that can be imported into your own [SaltStack](https://docs.saltstack.com/en/latest/) states to get a server running your Django application.

Additionally, it sets up some firewall rules, creates a system user which contains the Django application, creates a database user that the application can connect to, and adds a `sites-available` nginx entry for the application.

# Usage
`cookiecutter https://github.com/siddhantgoel/salt-django-cookiecutter` should create `states` and `pillars` directories. Just copy them over to your `file_roots` and do `salt 'appname*' state.highstate`.
