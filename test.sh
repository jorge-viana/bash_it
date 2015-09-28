#!/bin/bash

set -u

suite_files=$(ls test/*_test.sh)

global_start_time=0
global_end_time=0
global_total_time_milli=0

global_number_tests=0
global_number_failed_tests=0

global_failed_tests=""


global_start_time=$(date +%s%N)


for suite_file in $suite_files
do

  suite_nbr_tests=0
  suite_nbr_failed_tests=0
  suite_start=0
  suite_end=0
  suite_duration_milli=0
  suite_failed_tests=""

  echo ""
  echo "Running $(basename ${suite_file})"

  # import (source) suite file
  . $suite_file

  test_suite=$(sed -n -e '/#@test/,/function/ p' $suite_file | grep function | awk '{print $2}')


  suite_start=$(date +%s%N)

  for test in $test_suite
  do

    test_start=0
    test_end=0
    test_duration_milli=0

    suite_nbr_tests=$(( suite_nbr_tests + 1 ))

    test_start=$(date +%s%N)

    $("$test")
    test_result=$?

    test_end=$(date +%s%N)
    test_duration_milli=$(( (test_end - test_start) / 1000000 ))


    if [ $test_result -ne 0 ]
    then
      echo "  ${test}, took ${test_duration_milli} milliseconds  <<< FAILED"
      suite_nbr_failed_tests=$(( suite_nbr_failed_tests + 1 ))
      suite_failed_tests+="$( basename ${suite_file}) - ${test}\n"
    fi
  done

  suite_end=$(date +%s%N)
  suite_duration_milli=$(( (suite_end - suite_start) / 1000000 ))

  global_number_tests=$(( global_number_tests + suite_nbr_tests ))
  global_number_failed_tests=$(( global_number_failed_tests + suite_nbr_failed_tests ))

  global_failed_tests+="${suite_failed_tests}"

  #suite stats
  if [ "${suite_failed_tests}" != "" ]
  then
    echo "  Tests run: ${suite_nbr_tests}, Failures: ${suite_nbr_failed_tests}, Time elapsed: ${suite_duration_milli} milliseconds  <<< FAILURE!"
  else
    echo "  Tests run: ${suite_nbr_tests}, Failures: ${suite_nbr_failed_tests}, Time elapsed: ${suite_duration_milli} milliseconds"
  fi
  
done

global_end_time=$(date +%s%N)
global_total_time_milli=$(( (global_end_time - global_start_time) / 1000000 ))

echo ""
echo "----------------------------------------------------------------------"
echo "Results:"
echo ""

if [ "${global_failed_tests}" != "" ]
then
  echo "Failed tests:"
  echo -e "${global_failed_tests}"
fi

echo "Tests run: ${global_number_tests}, Failures: ${global_number_failed_tests}"
echo "Total time: ${global_total_time_milli} milliseconds"
echo "Finished at: $(date)"
echo "----------------------------------------------------------------------"

if [ $global_number_failed_tests -ne 0 ]
then
  exit 1
fi

