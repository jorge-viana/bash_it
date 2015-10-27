# bash_it
bash integration test framework

## Install
Just download the framework to `any_directory`.
Update your PATH environment variable.
`PATH=$PATH:any_directory`

## How it works
Create a working directory for your project and put your scripts anywhere in this directory.
Create a `test` directory for your tests and put your test scripts here.

```
.
├── src
│   ├── greeter.sh
│   └── write_numbers.sh
└── test
    ├── greeter_test.sh
    └── write_numbers_test.sh
```

Run your tests.
```
$ cd working_dir
$ run_tests.sh
```

> **note**

> the test runner will look for files that end with '_test.sh' in a sub-directory named `test` relative to the current working directory

> more flexible configuration options will be provided soon


## Examples
The framework comes with examples. When you run the tests for these examples you'll see two failing tests, this was done to demonstrate how the framework works.


## Writing a test
```
PATH=src:$PATH

#@test
function should_say_hello_to_zenek {

  local actual=$(greeter.sh Zenek)
  local expected="Hello Zenek"

  assert_equals "${expected}" "${actual}"
  return $?
}
```
Things to note in this example:

- the location of the script under test must be in the PATH
- the function is annotated with `#@test`
- the script under test is called and an assertion is made
- the assert function is just syntactic sugar for a comparison and the result of this assertion should be returned immediately after its call

