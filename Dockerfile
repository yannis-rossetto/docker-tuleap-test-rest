## Re-use tuleap base for caching ##
FROM centos:centos6

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

COPY Tuleap.repo /etc/yum.repos.d/

RUN yum -y install epel-release && \
    yum -y --exclude php-pecl-apcu install \
    tuleap \
    php-pecl-apc \
    php-pecl-xdebug \
    mysql-server \
    httpd \
    php-restler-3.0-0.7.1 \
    php-phpwiki-tuleap && \
    yum clean all

    # php-soap \
    # php-mysql \
    # php-gd \
    # php-process \
    # php-xml \
    # php-pecl-xdebug  \
    # php-mbstring \
    # mysql-server \
    # httpd \
    # php-password-compat \
    # php-zendframework \
    # php-ZendFramework2-Loader \
    # php-ZendFramework2-Mail \
    # htmlpurifier \
    # jpgraph-tuleap \
    # php-restler-3.0-0.7.1 \
    # php-phpwiki-tuleap && \
    # yum clean all

RUN yum remove -y tuleap tuleap-core-subversion tuleap-core-subversion-modperl tuleap-documentation

RUN service mysqld start && \
    sleep 1 && \
    mysql -e "GRANT ALL PRIVILEGES on *.* to 'tuleapadm'@'localhost' identified by 'welcome0'; CREATE DATABASE tuleap DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci"

RUN curl -k -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin

COPY rest-tests.conf /etc/httpd/conf.d/rest-tests.conf

#COPY composer.json /tmp/run/composer.json
#RUN cd /tmp/run && php /usr/local/bin/composer.phar install

RUN mkdir -p /etc/tuleap/conf /etc/tuleap/plugins /var/tmp/tuleap_cache/lang /var/tmp/tuleap_cache/combined /var/lib/tuleap/gitolite/admin

COPY local.inc /etc/tuleap/conf/local.inc

RUN chown -R apache:apache /etc/tuleap /var/tmp/tuleap_cache /var/lib/tuleap

COPY run.sh /run.sh

CMD ["/run.sh"]
