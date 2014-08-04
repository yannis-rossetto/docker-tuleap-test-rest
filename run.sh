#!/bin/bash

set -e

service mysqld start

options=`getopt -o h -l init,run -- "$@"`

eval set -- "$options"

init=1
run=1

while true
do
    case "$1" in
	--init)
	    init=1
	    run=0
	    shift 1;;
	--run)
	    init=0
	    run=1
	    shift 1;;
	--)
	    shift 1; break ;;
	*)
	    break ;;
    esac
done

if [ "$init" == 1 ]; then
    make -C /tuleap TULEAP_LOCAL_INC=/etc/integration_tests.inc OUTPUT_DIR=/output BUILD_ENV=ci ci_api_test_setup api_test_bootstrap
fi
if [ "$run" == 1 ]; then
    service httpd start
    RUN_MODE=docker_api_all
    if [ -n "$@" ]; then
	RUN_MODE=docker_api_partial
    fi
    exec make -C /tuleap OUTPUT_DIR=/output BUILD_ENV=ci REST_TESTS_OPTIONS="$@" $RUN_MODE
fi
