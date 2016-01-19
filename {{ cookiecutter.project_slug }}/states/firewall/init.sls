/etc/iptables.firewall.rules:
    file.managed:
        - source: salt://firewall/files/iptables.firewall.rules
        - user: root
        - group: root
        - mode: 644

iptables-restore < /etc/iptables.firewall.rules:
    cmd.wait:
        - user: root
        - require:
            - file: /etc/iptables.firewall.rules
        - watch:
            - file: /etc/iptables.firewall.rules
