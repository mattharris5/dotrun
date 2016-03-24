# dotrun
A super simple app runner script

## The Problem
Every app I work on seems to have a different way of running it, and I couldn't keep track. I wanted to be able to navigate to any app directory in the terminal and run a simple command to launch the app in focus.

## The Solution
This simple ruby script expects a file called `.run` in the current directory with an instruction to execute. Put the script somewhere on your machine, make it executable with `chmod +x` and symlink it to somewhere in your path (e.g., `ln -s /usr/local/dotrun /path/to/dotrun.rb`) and you can run it from anywhere that you've defined a `.run` file. 

Simply navigate to the directory of your app, and run
```
dotrun
```
and it will run the command you've specified. It will also clear your terminal and tell you some useful information like the current git branch, and hitting `Ctrl+C` will terminate the process (gracefully, hopefully). 

For even more usefulness, you can provide multiple commands in the file to specify different things to launch. For example:

```yaml
server: unicorn_rails --host 127.0.0.1
console: rails c
sidekiq: bundle exec sidekiq
log: tail -f log/development.log
```

You can then run
```
dotrun server
```
to run the unicorn script above.

Feel free to use this if you think it might be valuable to you!
