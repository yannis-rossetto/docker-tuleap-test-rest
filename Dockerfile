FROM centos:6

COPY *.repo /etc/yum.repos.d/

RUN yum -y install epel-release centos-release-scl && \
    yum -y install \
        tuleap \
        rh-mysql56-mysql \
        rh-mysql56-mysql-server \
        php-ZendFramework2-Mail \
        rh-php56-php-gd \
        rh-php56-php-pecl \
        rh-php56-php-pear \
        rh-php56-php-soap \
        rh-php56-php-mysqlnd \
        rh-php56-php-xml \
        rh-php56-php-mbstring \
        rh-php56-php-cli \
        rh-php56-php-opcache \
        rh-php56-php-process \
        rh-php56-php-pdo \
        rh-php56-php-fpm \
        php56-php-gd \
        php56-php-pecl \
        php56-php-pear \
        php56-php-soap \
        php56-php-mysqlnd \
        php56-php-xml \
        php56-php-mbstring \
        php56-php-cli \
        php56-php-opcache \
        php56-php-process \
        php56-php-pdo \
        php56-php-fpm \
        java-1.8.0-openjdk \
        php72-php-cli \
        php72-php-pdo \
        php72-php-xml \
        php72-php-mbstring \
        php72-php-mysqlnd \
        php72-php-process \
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
ENV FPM_DAEMON=rh-php56-php-fpm
ENV PHP_CLI=/opt/remi/php72/root/usr/bin/php
