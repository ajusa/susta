import osproc, os, terminal, strutils

type Status = enum Success, Failed

type Test = object
  name: string
  status: Status
  output: string

proc show(t: Test) =
  stdout.styledWrite styleBright, fgBlue, "[", t.name, "]"
  var state = if t.status == Success: fgGreen else: fgRed
  stdout.styledWrite styleBright, state, " ■"
  stdout.styledWrite(resetStyle, "\n")
  

proc runTest(file: string): string =
  var (output, code) = execCmdEx("nim --hints:off --warnings:off r " & file)
  if code != 0:
    echo "Failed to compile ", file
    quit(1)
  return output

proc getOutputPath(file: string): string =
  "./output" / file.extractFilename.changeFileExt(".out")

proc run(tests: seq[string]) =
  ## Runs tests
  discard existsOrCreateDir("./output")
  var failed: seq[Test]
  for file in tests:
    var output = file.runTest()
    var previous = file.getOutputPath
    var test = Test(name: file.extractFilename.changeFileExt(""))
    if previous.fileExists:
      var (diff, code) = execCmdEx("diff --color=always -u " & previous & " -", input = output)
      if code != 0:
        test.status = Failed
        test.output = diff.split("\n")[2..^1].join("\n")
        failed.add(test)
    else:
      previous.writeFile(output)
      echo "No existing output found, writing to ./output"
    show test
  if failed.len > 0:
    echo "Failed tests:"
  for test in failed:
    show test
    echo test.output
  styledEcho styleBright, fgGreen, $(tests.len - failed.len), " passed ", fgRed, $failed.len, " failed", resetStyle
  if failed.len > 0:
    quit(1)

proc accept(tests: seq[string]) =
  ## Accepts output of tests, overwriting previous output
  for file in tests:
    var output = file.runTest()
    file.getOutputPath.writeFile(output)

when isMainModule:
  import cligen
  dispatchMulti([run], [accept])
