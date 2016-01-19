nginx:
    pkg:
        - installed
    service.running:
        - pkg: nginx
        - file: /etc/nginx/nginx.conf
        - enable: True
        - restart: True
        - provider: systemd
    watch:
        - file: /etc/nginx/nginx.conf
        - file: /etc/nginx/sites-enabled/*.conf
