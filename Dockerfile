## Re-use tuleap base for caching ##
FROM centos:centos6

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

RUN rpm -i http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN rpm -i http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

RUN yum -y install --enablerepo=remi php && yum clean all
RUN yum -y install --enablerepo=remi php-soap && yum clean all
RUN yum -y install --enablerepo=remi php-mysql && yum clean all
RUN yum -y install --enablerepo=remi php-gd && yum clean all
RUN yum -y install --enablerepo=remi php-process && yum clean all
RUN yum -y install --enablerepo=remi php-xml && yum clean all
RUN yum -y install --enablerepo=remi php-pecl-xdebug  && yum clean all
RUN yum -y install --enablerepo=remi php-mbstring && yum clean all
RUN yum -y install --enablerepo=remi mysql-server && yum clean all
RUN yum -y install --enablerepo=remi httpd && yum clean all

ADD Tuleap.repo /etc/yum.repos.d/
RUN yum -y install php-password-compat && yum clean all
RUN yum -y install php-zendframework && yum clean all
RUN yum -y install htmlpurifier && yum clean all
RUN yum -y install jpgraph-tuleap && yum clean all
RUN yum -y install php-restler

RUN yum -y install --enablerepo=remi php-pecl-apc && yum clean all

RUN service mysqld start && sleep 1 && mysql -e "GRANT ALL PRIVILEGES on *.* to 'integration_test'@'localhost' identified by 'welcome0'"

RUN curl -k -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin

ADD rest-tests.conf /etc/httpd/conf.d/rest-tests.conf

ADD composer.json /tmp/run/composer.json
RUN cd /tmp/run && php /usr/local/bin/composer.phar install

ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]

VOLUME ["/tuleap"]

# We can use volumes when cp from volumes will be supported
#VOLUME ["/output"]
