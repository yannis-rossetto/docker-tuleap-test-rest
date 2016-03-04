#!/bin/bash

set -ex

setup_apache() {
    cp /usr/share/tuleap/src/etc/combined.conf.dist /etc/httpd/conf.d/combined.conf
    sed -i -e "s/User apache/User codendiadm/" \
	-e "s/Group apache/Group codendiadm/" /etc/httpd/conf/httpd.conf
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
	-e "s#%sys_default_domain%#localhost#g" \
	-e "s#%sys_fullname%#localhost#g" \
	-e "s#%sys_dbauth_passwd%#welcome0#g" \
	-e "s#%sys_org_name%#Tuleap#g" \
	-e "s#%sys_long_org_name%#Tuleap#g" \
	-e 's#\$sys_https_host =.*#\$sys_https_host = "";#' \
	-e 's#\$sys_rest_api_over_http =.*#\$sys_rest_api_over_http = 1;#' \
	> /etc/tuleap/conf/local.inc
}

setup_apache
setup_tuleap

service mysqld start
service httpd start

/usr/share/tuleap/tests/rest/init/bootstrap.sh

cd /usr/share/tuleap/tests/rest
# composer install
echo vendor/bin/phpunit StupidTest.php

exec bash
