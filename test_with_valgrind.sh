#!/usr/bin/env bash

TEST_NGINX_USE_VALGRIND=1 TEST_NGINX_SLEEP=1 prove -r t 2>&1 | grep -B 3 -A 20 "match-leak-kinds: definite"
# Ignore if testing is failed or grep nothing
test $? -eq 0 && exit 1
exit 0
