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

RUN yum install -y libnss-mysql

COPY libnss-mysql-root.cfg libnss-mysql.cfg /etc/

RUN sed -i -e 's/^passwd\(.*\)/passwd\1 mysql/g' \
    	   -e 's/^shadow\(.*\)/shadow\1 mysql/g' \
	   -e 's/^group\(.*\)/group\1 mysql/g'  /etc/nsswitch.conf

RUN curl -k -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin

COPY rest-tests.conf /etc/httpd/conf.d/rest-tests.conf

RUN touch /etc/aliases.codendi

RUN mkdir -p /etc/tuleap/conf /etc/tuleap/plugins /var/tmp/tuleap_cache/lang /var/tmp/tuleap_cache/combined /var/lib/tuleap/gitolite/admin /var/log/tuleap /usr/lib/tuleap/bin /home/users /home/groups /var/lib/tuleap/ftp/pub /var/lib/tuleap/ftp/tuleap 

RUN chown -R codendiadm:codendiadm /etc/tuleap /var/tmp/tuleap_cache /var/lib/tuleap /var/log/tuleap

COPY run.sh /run.sh

CMD ["/run.sh"]
