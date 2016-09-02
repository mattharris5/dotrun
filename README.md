# dotrun
A super simple app runner script

[![Gem Version](https://badge.fury.io/rb/dotrun.svg)](https://badge.fury.io/rb/dotrun)

## The Problem
Every app I work on seems to have a different way of running it, and I couldn't keep track. I wanted to be able to navigate to any app directory in the terminal and run a simple command to launch the app in focus.

## The Solution
This simple ruby script expects a file called `.run` in the current directory with an instruction to execute. Define a new `.run` file for each of the apps on your system. Then simply navigate to the directory of your app, and run
```
$  dotrun
```
and it will run the command you've specified. It will also clear your terminal and tell you some useful information like the current git branch, and hitting `Ctrl+C` will terminate the process (gracefully, hopefully).

## Installation
```
gem install dotrun
```
Or add `'dotrun'` to your Gemfile.

## Additional Features

### Store multiple directives

For even more usefulness, you can provide multiple commands in the file to specify different things to launch. For example:

```yaml
server: unicorn_rails --host 127.0.0.1
console: rails c
sidekiq: bundle exec sidekiq
tunnel: "ssh -L 33061:mysqlserver.my.net:3306 user@ssh.my.net"
log: tail -f log/development.log
```

You can then run, for example,
```
$  dotrun sidekiq
```
to run the sidekiq script above.

### View a list of available directives
To see a list of the directives you've defined for the current directory:
```
$  dotrun -?
```

### Run multiple directives at once
**This feature requires that [ttab](https://www.npmjs.com/package/ttab) is installed.** Run multiple commands in different tabs of your terminal window by specifying an array of commands in your `.run` directives file. For example:

```yaml
default:
  - server
  - log
  - console
server: unicorn_rails --host 127.0.0.1
console: rails c
log: tail -f log/development.log
```

When you run `dotrun` in this case, each command will open up in a new terminal tab. You can also specify many of these multi-directives by including other array items in the yaml configuration.

---

## License
Feel free to use this if you think it might be valuable to you! This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
