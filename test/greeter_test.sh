#!/bin/bash

set -u

PATH=src:$PATH

#@test
function should_say_hello_to_zanek {

  local actual=$(greeter.sh Zanek)
  local expected="Hello Zanek"

  assert_equals "${expected}" "${actual}"
  return $?
}

#@test
function should_say_hello_to_fifi_badly {

  local actual=$(greeter.sh Fifi)
  local expected="Hello dear Fifi"

  assert_equals "${expected}" "${actual}"
  return $?
}
