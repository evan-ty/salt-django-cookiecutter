include:
    - ssh

openssh-server:
    pkg.installed

/etc/ssh/sshd_config:
    file.managed:
        - user: root
        - group: root
        - mode: 644
        - source: salt://ssh/files/sshd_config
        - require:
            - pkg: openssh-server

ssh:
    service.running:
        - require:
            - pkg: openssh-server
            - file: /etc/ssh/sshd_config
        - watch:
            - file: /etc/ssh/sshd_config
