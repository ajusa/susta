# Susta

*From Greek σούστα(ελατήριο) meaning spring, flexible, and Hindi सस्ता, meaning cheap*

Susta is a simple and easy test runner based on print driven testing.
To understand the motivation behind this project, see 
[treeform's ptest writeup](https://github.com/treeform/ptest#readme).

## Usage

```
Usage:
susta {SUBCMD}  [sub-command options & parameters]
where {SUBCMD} is one of:
help    print comprehensive or per-cmd help
run     Runs tests
accept  Accepts output of tests, overwriting previous output
```

Susta only has two commands - `run` and `accept`. In order to run your tests and compare against
the previous output, do `susta run test1.nim test2.nim...`. Note that most shells support glob expansion,
so doing `susta run tests/*.nim` should suffice as well.

Once you are happy with the output of your tests, do `susta accept test1.nim test2.nim...` in order to keep
the changes and overwrite the previous output.

Susta stores the previous output in the same directory as where it is called, in the `output` directory.
