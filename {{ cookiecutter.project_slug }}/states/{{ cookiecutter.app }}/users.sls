{{ cookiecutter.app }}:
    user.present:
        - shell: /bin/bash

{{ cookiecutter.app }}-user-key:
    ssh_auth.present:
        - user: {{ cookiecutter.app }}
        - require:
            - user: {{ cookiecutter.app }}
        - names:
            - {{ "{{" }} pillar.users.{{ cookiecutter.app }}.public_key {{ "}}"}}

/home/{{ cookiecutter.app }}/.ssh/id_rsa:
    file.managed:
        - user: {{ cookiecutter.app }}
        - group: {{ cookiecutter.app }}
        - mode: 600
        - contents: |
            {{ "{{" }} pillar.users.{{ cookiecutter.app }}.private_key | indent(12) {{ "}}" }}
        - require:
            - ssh_auth: {{ cookiecutter.app }}-user-key
