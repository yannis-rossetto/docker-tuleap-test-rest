Docker image to execute Tuleap REST tests
=========================================

How to use
==========

To execute all tests, just type:

    $> docker run --rm -ti -v $PWD:/usr/share/tuleap -p 80:80 rest

    $> docker run --rm=true -v $PWD:/tuleap enalean/tuleap-test-rest

To execute only one file (actually you can pass any PhpUnit option):

    $> docker run --rm=true -v $PWD:/tuleap enalean/tuleap-test-rest tests/rest/ProjectTest.php

Init once execute several times (ie. to develop new tests)

    $> docker run -ti --name=init -v $PWD:/tuleap enalean/tuleap-test-rest --init
    $> docker commit init tuleap-test-rest-init && docker rm -f init
    # Run all tests
    $> docker run --rm=true -v $PWD:/tuleap tuleap-test-rest-init --run
    # Run only one test
    $> docker run --rm=true -v $PWD:/tuleap tuleap-test-rest-init --run tests/rest/ArtifactsTest.php

Continuous integration usage
----------------------------

For jenkins builds:

    $> docker run --rm=true -v $WORKSPACE/tuleap:/tuleap -v $WORKSPACE:/output enalean/tuleap-test-rest
    
Debugging failed tests
======================

While the tests are running, in a separate console run

    $> docker ps
    $> docker commit [id of process] some_name (e.g. toto)
    
Then, once the tests have finished running

    $> docker run -ti -p 80:80 -v $PWD:/tuleap --entrypoint=/bin/bash toto

This will take you to the terminal. You can then debug internally, if you wish

    $> sh run.sh [tests/rest/ProjectTest.php] //runs the test- needs to be done to restart mysql, httpd, ...
    $> mysql //check the db
    $> curl 'http://localhost:8089/api/v1/projects' //use the API
    $> ifconfig //get the IP of the container
    
You can even debug via the UI by going to http://IP_OF_CONTAINER:8089 and clicking on login (admin:siteadmin)

Experimental
============

nginx

yum install -y rh-nginx18-nginx
/etc/opt/rh/rh-nginx18/nginx/nginx.conf

	root   /usr/share/tuleap/src/www;
        index  index.php;

        location / {
            index  index.php;
        }

        location /api {
            try_files $uri $uri/ /api/index.php?$args;
        }

        location ~ \.php$ {
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }

There seems to be an issue with artifact tests & location
Reproduce with:
vendor/bin/phpunit -d include_path=/usr/share/tuleap/src/www/include:/usr/share/tuleap/src -d date.timezone=Europe/Paris --filter ArtifactsTest::testPostArtifact  /usr/share/tuleap/tests/rest/ArtifactsTest.php

The post is sent with a Location an guzzle attempt to follow the location
because a 302 header is sent.
Several things here:
- according to http_response_code(), this a 302 header that is prepared by php
  as soon as the location is set by $this->sendLocationHeader(...); in
  ArtifactsResource::post but only nginx properly transmit the set header to
  the client
- For some reasons guzzle doesn't respect the configuration I try to set:
  http://guzzle3.readthedocs.io/http-client/http-redirects.html
  (but the real problem is the 302 as it should really be 200);
