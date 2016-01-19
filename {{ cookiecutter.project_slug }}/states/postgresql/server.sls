server-packages:
    pkg.latest:
        - names:
            - postgresql-9.4
            - postgresql-server-dev-9.4

postgresql-service:
    service.running:
        - name: postgresql
        - provider: systemd
        - enable: True
