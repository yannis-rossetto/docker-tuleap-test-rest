Docker image to execute Tuleap REST tests
=========================================

How to use
==========

To execute all tests, just type:

    $> docker run --rm=true -v $PWD:/tuleap enalean/tuleap-test-rest-c6-php54

To execute only one file (actually you can pass any PhpUnit option):

    $> docker run --rm=true -v $PWD:/tuleap enalean/tuleap-test-rest-c6-php54 tests/rest/ProjectTest.php

Init once execute several times (ie. to develop new tests)

    $> docker run -ti --name=init -v $PWD:/tuleap enalean/tuleap-test-rest-c6-php54 --init
    $> docker commit init tuleap-test-rest-c6-php54-init && docker rm -f init
    # Run all tests
    $> docker run --rm=true -v $PWD:/tuleap tuleap-test-rest-c6-php54-init --run
    # Run only one test
    $> docker run --rm=true -v $PWD:/tuleap tuleap-test-rest-c6-php54-init --run tests/rest/ArtifactsTest.php

Continuous integration usage
----------------------------

For jenkins builds:

    $> docker run --rm=true -v $WORKSPACE/tuleap:/tuleap -v $WORKSPACE:/output enalean/tuleap-test-rest-c6-php54
