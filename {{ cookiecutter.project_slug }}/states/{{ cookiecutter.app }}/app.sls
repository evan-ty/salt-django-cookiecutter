app-dependencies:
    pkg.installed:
        - names:
            - zlib1g-dev
            - libjpeg-dev
            - libfreetype6-dev

/home/{{ cookiecutter.app }}/app:
    file.directory:
        - user: {{ cookiecutter.app }}
        - group: {{ cookiecutter.app }}
        - dir_mode: 755
        - recurse:
            - user
            - mode
        - require:
            - user: {{ cookiecutter.app }}

{{ cookiecutter.app }}-stable-latest:
    git.latest:
        - name: {{ cookiecutter.git }}
        - target: /home/{{ cookiecutter.app }}/app
        - rev: stable
        - user: {{ cookiecutter.app }}
        - force_checkout: True
        - identity: /home/{{ cookiecutter.app }}/.ssh/id_rsa
        - require:
            - pkg: git
            - file: /home/{{ cookiecutter.app }}/app

/home/{{ cookiecutter.app }}/app-env:
    virtualenv.managed:
        - system_site_packages: False
        - requirements: /home/{{ cookiecutter.app }}/app/requirements.txt
        - python: /usr/bin/python3
        - require:
            - git: {{ cookiecutter.app }}-stable-latest

/etc/systemd/system/{{ cookiecutter.app }}.service:
    file.managed:
        - source: salt://{{ cookiecutter.app }}/files/{{ cookiecutter.app }}.service
        - mode: 644
        - template: jinja
        - require:
            - virtualenv: /home/{{ cookiecutter.app }}/app-env

{{ cookiecutter.app }}.service:
    service.running:
        - name: {{ cookiecutter.app }}
        - provider: systemd
        - enable: True
        - reload: True
        - watch:
            - git: {{ cookiecutter.app }}-stable-latest
            - file: /etc/systemd/system/{{ cookiecutter.app }}.service
        - require:
            - file: /etc/systemd/system/{{ cookiecutter.app }}.service

/var/www/{{ cookiecutter.app }}:
    file.directory:
        - user: {{ cookiecutter.app }}
        - group: {{ cookiecutter.app }}
        - dir_mode: 755
        - recurse:
            - user
            - mode

/home/{{ cookiecutter.app }}/app-env/bin/python manage.py migrate:
    cmd.wait:
        - cwd: /home/{{ cookiecutter.app }}/app
        - user: {{ cookiecutter.app }}
        - watch:
            - git: {{ cookiecutter.app }}-stable-latest
        - env:
            - SECRET_KEY: {{ "{{" }} pillar.app.secret_key {{ "}}" }}
            - STATIC_ROOT: {{ "{{" }} pillar.app.static_root {{ "}}" }}
            - DATABASE_URL: postgres://{{ "{{" }} pillar.database.db_user {{ "}}" }}:{{ "{{" }} pillar.database.db_password {{ "}}" }}@localhost/{{ "{{" }} pillar.database.db_name {{ "}}" }}
        - require:
            - virtualenv: /home/{{ cookiecutter.app }}/app-env
            - postgres_database: {{ cookiecutter.app }}-database

/home/{{ cookiecutter.app }}/app-env/bin/python manage.py collectstatic --no-input:
    cmd.wait:
        - cwd: /home/{{ cookiecutter.app }}/app
        - user: {{ cookiecutter.app }}
        - watch:
            - git: {{ cookiecutter.app }}-stable-latest
        - env:
            - SECRET_KEY: {{ "{{" }} pillar.app.secret_key {{ "}}" }}
            - STATIC_ROOT: {{ "{{" }} pillar.app.static_root {{ "}}" }}
            - DATABASE_URL: postgres://{{ "{{" }} pillar.database.db_user {{ "}}" }}:{{ "{{" }} pillar.database.db_password {{ "}}" }}@localhost/{{ "{{" }} pillar.database.db_name {{ "}}" }}
        - require:
            - virtualenv: /home/{{ cookiecutter.app }}/app-env
            - file: /var/www/{{ cookiecutter.app }}

/etc/nginx/sites-available/{{ cookiecutter.app }}.conf:
    file.managed:
        - source: salt://{{ cookiecutter.app }}/files/{{ cookiecutter.app }}.conf
        - mode: 644
        - template: jinja
        - user: root
        - group: root
        - require:
            - pkg: nginx

/etc/nginx/sites-enabled/{{ cookiecutter.app }}.conf:
    file.symlink:
        - target: /etc/nginx/sites-available/{{ cookiecutter.app }}.conf
        - require:
            - file: /etc/nginx/sites-available/{{ cookiecutter.app }}.conf
