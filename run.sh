#!/bin/bash

set -ex

setup_apache() {
    cp /usr/share/tuleap/src/etc/combined.conf.dist /etc/httpd/conf.d/combined.conf
    sed -i -e "s/USER apache/USER codendiadm/" \
	-e "s/GROUP apache/GROUP codendiadm/" /etc/httpd/conf/httpd.conf
}

setup_tuleap() {
    cat /usr/share/tuleap/src/etc/database.inc.dist | \
    	sed \
	     -e "s/%sys_dbname%/tuleap/" \
	     -e "s/%sys_dbuser%/tuleapadm/" \
	     -e "s/%sys_dbpasswd%/welcome0/" > /etc/tuleap/conf/database.inc

    cat /usr/share/tuleap/src/etc/local.inc.dist | \
	sed \
	-e "s#/etc/codendi#/etc/tuleap#g" \
	-e "s#/usr/share/codendi#/usr/share/tuleap#g" \
	-e "s#/var/log/codendi#/var/log/tuleap#g" \
	-e "s#/var/lib/codendi/ftp/codendi#/var/lib/tuleap/ftp/tuleap#g" \
	-e "s#/var/lib/codendi#/var/lib/tuleap#g" \
	-e "s#/usr/lib/codendi#/usr/lib/tuleap#g" \
	-e "s#/var/tmp/codendi_cache#/var/tmp/tuleap_cache#g" \
	> /etc/tuleap/conf/local.inc
}

feed_database() {
    mysql<<EOF
GRANT ALL PRIVILEGES on *.* to 'tuleapadm'@'localhost' identified by 'welcome0' WITH GRANT OPTION; 
CREATE DATABASE tuleap DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
FLUSH PRIVILEGES;
EOF
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/src/db/mysql/database_structure.sql
    mysql -u tuleapadm -pwelcome0 tuleap<<EOF
GRANT SELECT ON tuleap.user to dbauthuser@'localhost' identified by 'welcome0';
GRANT SELECT ON tuleap.groups to dbauthuser@'localhost';
GRANT SELECT ON tuleap.user_group to dbauthuser@'localhost';
FLUSH PRIVILEGES;
EOF
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/src/db/mysql/database_initvalues.sql
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/plugins/tracker/db/install.sql
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/plugins/graphontrackersv5/db/install.sql
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/plugins/agiledashboard/db/install.sql
    mysql -u tuleapadm -pwelcome0 tuleap < /usr/share/tuleap/plugins/cardwall/db/install.sql
}

import() {
    /usr/share/tuleap/src/utils/php-launcher.sh /usr/share/tuleap/src/utils/import_project_xml.php -u admin -i /usr/share/tuleap/tests/rest/init/base -m /usr/share/tuleap/tests/rest/init/base/users.csv
}

setup_apache

service mysqld start
service httpd start

time feed_database

setup_tuleap

time import

exec bash
