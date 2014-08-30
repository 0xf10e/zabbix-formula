{% from "zabbix/map.jinja" import zabbix with context %}
{% from "zabbix/macros.jinja" import files_switch with context %}


include:
  - zabbix.frontend
  - zabbix.frontend.repo


{{ zabbix.frontend.config }}:
  file:
    - managed
    - source: {{ files_switch('zabbix',
                              ['/etc/zabbix/web/zabbix.conf.php',
                               '/etc/zabbix/web/zabbix.conf.php.jinja'] }}
    - template: jinja
    - require:
      - pkg: zabbix-frontend-php


{% if grains['os_family'] == 'Debian' %}
# We don't want the package to mess with apache
zabbix-frontend_debconf:
  debconf:
    - set
    - name: {{ zabbix.frontend.pkg}}
    - data:
        'zabbix-frontend-php/configure-apache': {'type': 'boolean', 'value': False}
        'zabbix-frontend-php/restart-webserver': {'type': 'boolean', 'value': False}
    - prereq:
      - pkg: zabbix-frontend-php
{% endif %}
