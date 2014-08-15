## Re-use tuleap base for caching ##
FROM centos:centos6

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

RUN rpm -i http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN rpm -i http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

RUN yum -y install --enablerepo=remi,remi-php55 php && yum clean all
RUN yum -y install --enablerepo=remi,remi-php55 php-soap && yum clean all
RUN yum -y install --enablerepo=remi,remi-php55 php-mysql && yum clean all
RUN yum -y install --enablerepo=remi,remi-php55 php-gd && yum clean all
RUN yum -y install --enablerepo=remi,remi-php55 php-process && yum clean all
RUN yum -y install --enablerepo=remi,remi-php55 php-xml && yum clean all
RUN yum -y install --enablerepo=remi,remi-php55 php-pecl-xdebug  && yum clean all
RUN yum -y install --enablerepo=remi,remi-php55 php-mbstring && yum clean all
RUN yum -y install --enablerepo=remi,remi-php55 mysql-server && yum clean all
RUN yum -y install --enablerepo=remi,remi-php55 httpd && yum clean all

ADD Tuleap.repo /etc/yum.repos.d/
RUN yum -y install php-zendframework && yum clean all
RUN yum -y install htmlpurifier && yum clean all
RUN yum -y install jpgraph-tuleap && yum clean all
RUN yum -y install php-restler

RUN yum -y install --enablerepo=remi,remi-php55 php-opcache && yum clean all

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
