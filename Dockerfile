FROM centos:6

COPY *.repo /etc/yum.repos.d/

RUN yum -y install epel-release centos-release-scl && \
    yum -y install \
        tuleap \
        rh-mysql56-mysql \
        rh-mysql56-mysql-server \
        php-ZendFramework2-Mail \
        php72-php-gd \
        php72-php-pecl \
        php72-php-pear \
        php72-php-soap \
        php72-php-mysqlnd \
        php72-php-xml \
        php72-php-mbstring \
        php72-php-opcache \
        php72-php-fpm \
        php72-php-cli \
        php72-php-pdo \
        php72-php-xml \
        php72-php-mbstring \
        php72-php-mysqlnd \
        php72-php-process \
         php72-php-pecl-zip \
        java-1.8.0-openjdk \
        rh-git29-git \
        sudo \
    && \
    yum remove -y tuleap \
        tuleap-core-subversion \
        tuleap-core-subversion-modperl \
        tuleap-documentation && \
    yum clean all

RUN curl -k -sS https://getcomposer.org/installer | /opt/remi/php72/root/usr/bin/php && mv composer.phar /usr/local/bin && \
    mkdir -p /etc/tuleap/conf \
        /etc/tuleap/plugins \
        /var/lib/tuleap/gitolite/admin \
        /var/log/tuleap \
        /usr/lib/tuleap/bin \
        /var/lib/tuleap/ftp/incoming \
        /var/lib/tuleap/ftp/tuleap && \
    chown -R codendiadm:codendiadm /etc/tuleap /var/lib/tuleap /var/log/tuleap

COPY mysql-server.cnf /etc/opt/rh/rh-mysql56/my.cnf.d/mysql-server.cnf

CMD /usr/share/tuleap/tests/rest/bin/run.sh

ENV MYSQL_DAEMON=rh-mysql56-mysqld
ENV FPM_DAEMON=php72-php-fpm
ENV PHP_CLI=/opt/remi/php72/root/usr/bin/php
