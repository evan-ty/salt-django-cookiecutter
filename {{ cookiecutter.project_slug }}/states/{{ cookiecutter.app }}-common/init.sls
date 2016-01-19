{{ cookiecutter.app_name }}-common:
    pkg.installed:
        - names:
            - git
            - python3
            - python3-dev

python-virtualenv:
    pkg.installed:
        - require:
            - pkg: python3
