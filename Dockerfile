## Re-use tuleap base for caching ##
FROM centos:centos6

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

COPY Tuleap.repo /etc/yum.repos.d/

RUN yum -y install epel-release centos-release-scl && \
    yum -y --exclude php-pecl-apcu install \
    tuleap \
    php-pecl-apc \
    php-pecl-xdebug \
    mysql-server \
    httpd \
    php-restler-3.0-0.7.1 \
    php-phpwiki-tuleap \
    libnss-mysql && \
    yum remove -y tuleap \
    tuleap-core-subversion \
    tuleap-core-subversion-modperl \
    tuleap-documentation \
    java-1.8.0-openjdk && \
    yum --disablerepo=Tuleap install -y git19-git && \
    yum clean all

COPY libnss-mysql-root.cfg libnss-mysql.cfg /etc/

RUN sed -i -e 's/^passwd\(.*\)/passwd\1 mysql/g' \
    	   -e 's/^shadow\(.*\)/shadow\1 mysql/g' \
	   -e 's/^group\(.*\)/group\1 mysql/g'  /etc/nsswitch.conf && \
    curl -k -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin && \ 
    touch /etc/aliases.codendi && \
    mkdir -p /etc/tuleap/conf \
    /etc/tuleap/plugins \
    /var/tmp/tuleap_cache/lang \
    /var/tmp/tuleap_cache/combined \
    /var/tmp/tuleap_cache/restler \
    /var/lib/tuleap/gitolite/admin \
    /var/log/tuleap \
    /usr/lib/tuleap/bin \
    /home/users \
    /home/groups \
    /var/lib/tuleap/ftp/pub \
    /var/lib/tuleap/ftp/tuleap && \
    chown -R codendiadm:codendiadm /etc/tuleap \
    /var/tmp/tuleap_cache \
    /var/lib/tuleap \
    /var/log/tuleap && \
    cd /usr/share && ln -s tuleap codendi && \
    cd /var/tmp && ln -s tuleap_cache codendi_cache

CMD /usr/share/tuleap/tests/rest/bin/run.sh

ENV MYSQL_DAEMON=mysqld
ENV HTTPD_DAEMON=httpd
