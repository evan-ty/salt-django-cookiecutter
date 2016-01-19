base:
    '{{ cookiecutter.app }}':
        - webserver
        - postgresql
        - {{ cookiecutter.app }}
