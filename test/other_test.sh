#!/bin/bash

PATH=src:$PATH

#@test
function test_a {


  return 3
}

#@test
function test_b {
  return 0
}


#@test
function should_write_numbers {

  write_numbers.sh > /tmp/nums.txt

  cmp -s /tmp/nums.txt - <<!
1
2
3
!
  res=$?

  rm /tmp/nums.txt

  return $res
}

#@test
function should_write_numbers_fails {

  write_numbers.sh > /tmp/nums.txt

  cmp -s /tmp/nums.txt - <<!
1
1
1
!
  res=$?

  rm /tmp/nums.txt

  return $res
}
