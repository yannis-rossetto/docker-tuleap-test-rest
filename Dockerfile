## Re-use tuleap base for caching ##
FROM centos:centos6

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

COPY Tuleap.repo /etc/yum.repos.d/

RUN rpm -i http://mir01.syntis.net/epel/6/i386/epel-release-6-8.noarch.rpm && \
    yum -y install php \
    php-soap \
    php-mysql \
    php-gd \
    php-process \
    php-xml \
    php-pecl-xdebug  \
    php-mbstring \
    mysql-server \
    httpd \
    php-password-compat \
    php-zendframework \
    htmlpurifier \
    jpgraph-tuleap \
    php-restler-3.0-0.7.1 \
    php-phpwiki-tuleap && \
    yum clean all

RUN service mysqld start && sleep 1 && mysql -e "GRANT ALL PRIVILEGES on *.* to 'integration_test'@'localhost' identified by 'welcome0'"

RUN curl -k -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin

COPY rest-tests.conf /etc/httpd/conf.d/rest-tests.conf

COPY composer.json /tmp/run/composer.json
RUN cd /tmp/run && php /usr/local/bin/composer.phar install

ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]

VOLUME ["/tuleap"]

# We can use volumes when cp from volumes will be supported
#VOLUME ["/output"]
