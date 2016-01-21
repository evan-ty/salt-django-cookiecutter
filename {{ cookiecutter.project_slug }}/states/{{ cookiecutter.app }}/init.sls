include:
    - postgresql.client
    - postgresql.server
    - ssh.server
    - firewall
    - {{ cookiecutter.app }}-common
    - {{ cookiecutter.app }}.users
    - {{ cookiecutter.app }}.database
    - {{ cookiecutter.app }}.app
