#!/bin/bash

# todo
# make it more modular
# eventually change the name of the script
# 
# comment tests, @ignore, todos


set -u

readonly _MILLI_TO_NANO_FACTOR=$(( 10 ** 6 ))

declare _suite_file=""
declare _suite_files=""

declare -i _global_start_time=0
declare -i _global_end_time=0
declare -i _global_total_time_milli=0

declare -i _global_number_tests=0
declare -i _global_number_failed_tests=0

declare _global_failed_tests=""


_suite_files=$(ls test/*_test.sh)
_global_start_time=$(date +%s%N)


for _suite_file in $_suite_files
do

  declare _test=""
  declare _test_suite=""
  declare -i _suite_nbr_tests=0
  declare -i _suite_nbr_failed_tests=0
  declare -i _suite_start=0
  declare -i _suite_end=0
  declare -i _suite_duration_milli=0
  declare _suite_failed_tests=""

  echo ""
  echo "Running $(basename ${_suite_file})"

  # import (source) suite file
  . $_suite_file

  _test_suite=$(sed -n -e '/#@test/,/function/ p' $_suite_file | grep function | awk '{print $2}')


  _suite_start=$(date +%s%N)


  for _test in $_test_suite
  do

    declare -i _test_start=0
    declare -i _test_end=0
    declare -i _test_duration_milli=0
    declare -i _test_result=0

    _suite_nbr_tests+=1

    _test_start=$(date +%s%N)

    $("$_test")
    _test_result=$?

    _test_end=$(date +%s%N)
    _test_duration_milli=$(( (_test_end - _test_start) / _MILLI_TO_NANO_FACTOR ))


    if [ $_test_result -ne 0 ]
    then
      echo "  ${_test}, took ${_test_duration_milli} milliseconds  <<< FAILED"
      _suite_nbr_failed_tests+=1
      _suite_failed_tests+="$( basename ${_suite_file}) - ${_test}\n"
    fi
  done

  _suite_end=$(date +%s%N)
  _suite_duration_milli=$(( (_suite_end - _suite_start) / _MILLI_TO_NANO_FACTOR ))

  _global_number_tests+=_suite_nbr_tests
  _global_number_failed_tests+=_suite_nbr_failed_tests

  _global_failed_tests+="${_suite_failed_tests}"

  #suite stats
  echo -n "  Tests run: ${_suite_nbr_tests}, Failures: ${_suite_nbr_failed_tests}, Time elapsed: ${_suite_duration_milli} milliseconds"
  if [ "${_suite_failed_tests}" != "" ]
  then
    echo "  <<< FAILURE!"
  fi
  
done

_global_end_time=$(date +%s%N)
_global_total_time_milli=$(( (_global_end_time - _global_start_time) / _MILLI_TO_NANO_FACTOR ))

echo ""
echo "----------------------------------------------------------------------"
echo "Results:"
echo ""

if [ "${_global_failed_tests}" != "" ]
then
  echo "Failed tests:"
  echo -e "${_global_failed_tests}"
fi

echo "Tests run: ${_global_number_tests}, Failures: ${_global_number_failed_tests}"
echo "Total time: ${_global_total_time_milli} milliseconds"
echo "Finished at: $(date)"
echo "----------------------------------------------------------------------"

if [ $_global_number_failed_tests -ne 0 ]
then
  exit 1
fi

