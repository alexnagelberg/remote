{exec} = require 'child_process'

task 'build', 'Build project from src/*.coffee to lib/*.js', ->
  exec 'coffee --compile --output lib src/', (err, stdout, stderr) ->
    throw err if err
    console.log stderr + stdout

task 'build-dev', 'Build project any time src/*.coffee gets altered', ->
  exec 'coffee --compile --watch --output lib src/', (err, stdout, stderr) ->
    throw err if err
    console.log stderr + stdout

task 'clean', 'Clean files generated from build', ->
  exec 'rm lib/*.js', (err, stdout, stderr) ->
    throw err if err
    console.log stderr + stdout
