#!/bin/bash

set -e

setup_apache() {
    cp /usr/share/tuleap/src/etc/combined.conf.dist /etc/httpd/conf.d/combined.conf
}

setup_database() {
    cat /usr/share/tuleap/src/etc/database.inc.dist |\
    	sed \
	     -e "s/%sys_dbname%/tuleap/" \
	     -e "s/%sys_dbuser%/tuleapadm/" \
	     -e "s/%sys_dbpasswd%/welcome0/" > /etc/tuleap/conf/database.inc
}

feed_database() {
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/src/db/mysql/database_structure.sql
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/src/db/mysql/database_initvalues.sql
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/plugins/tracker/db/install.sql
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/plugins/graphontrackersv5/db/install.sql
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/plugins/agiledashboard/db/install.sql
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/plugins/cardwall/db/install.sql
}

setup_apache

service mysqld start
service httpd start

time feed_database

setup_database

exec bash
