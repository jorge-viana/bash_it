#!/bin/bash

set -u

PATH=src:$PATH

#@test
function should_write_numbers_from_1_to_10 {

  local actual=$(write_numbers.sh 1 10)
  local expected="1 2 3 4 5 6 7 8 9 10"

  assert_equals "${expected}" "${actual}"
  return $?
}

#@test
function should_write_numbers_from_1_to_5_badly {

  local actual=$(write_numbers.sh 1 5)
  local expected="1 2 3..."

  assert_equals "${expected}" "${actual}"
  return $?
}
