# bash_it
bash integration test framework

## How it works
You write a script and you put it in the `src` directory.

You write a test for your script and you put it in the `test` directory.

You execute `./run_tests.sh` and watch for results.

> **note**

> at this point things are a bit inflexible, the test directory must be named 'test', the test script files must end with '_test.sh'

## Examples
The framework comes with two simple examples.

Once downloaded, you can execute `./run_tests.sh` right away and see a test report.
