#!/bin/bash

# Managed by Ansible : don't edit !
# Purposes : checks some services locally (like kojira or others) and send status to zabbix
# Called by: cron

# Check connections in PostgreSQL via the postgres user.
# Sends all the data as CSV to Zabbix for pre-processing

# avoid dir_read issues with sudo
cd /tmp

# Send the raw data directly
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k psql.raw_connections -o "$(sudo -u postgres psql --csv \
  -c 'select state, count(*) from pg_stat_activity where pid <> pg_backend_pid() group by 1 order by 1;')" >/dev/null 2>&1
