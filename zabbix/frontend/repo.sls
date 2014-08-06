{% from "zabbix/map.jinja" import zabbix with context %}


# We have a common template for the official Zabbix repo
{% include "zabbix/repo.sls" %}


# Here we just add a requisite declaration to ensure correct order
extend:
  zabbix_frontend_repo:
{%- if salt['grains.get']('os_family') == 'Debian' %}
    pkgrepo:
      - require_in:
        - pkg: zabbix-frontend-php
{% else %} {}
{% endif %}
