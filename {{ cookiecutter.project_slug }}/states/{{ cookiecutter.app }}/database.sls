{{ cookiecutter.app }}-database-user:
    postgres_user.present:
        - name: {{ "{{" }} pillar.database.db_user {{ "}}" }}
        - password: {{ "{{" }} pillar.database.db_password {{ "}}" }}
        - login: True

{{ cookiecutter.app }}-database:
    postgres_database.present:
        - name: {{ "{{" }} pillar.database.db_name {{ "}}" }}
        - owner: {{ "{{" }} pillar.database.db_user {{ "}}" }}
        - encoding: UTF8
        - require:
            - postgres_user: {{ cookiecutter.app }}-database-user
