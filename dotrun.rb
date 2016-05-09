#!/usr/bin/ruby
require 'YAML'
require 'colorize'

directives_path = ".run"
abort("No .run file detected in current directory.\r\n".red) unless File.exist?(directives_path)
directives = YAML.load_file(directives_path)

def print_help_and_exit(directives)
  puts "Usage: dotrun [directive]"
  print "Available directives for ".blue
  print "#{File.basename(File.expand_path("."))}".blue.bold
  puts ":".blue
  directives = { default: directives } if directives.is_a?(String)
  directives.each{|key, command| puts "  #{key.to_s.ljust(10).magenta} #{"->".light_black} #{command}"}
  puts ""
  exit
end

directive = ARGV[0] || "default"
command = directives.is_a?(String) ? directives : directives[directive]
print_help_and_exit(directives) if directive == "-?"
abort("Couldn't find the `#{directive}` directive in your config.\r\n".red) unless command

system("clear")

print "Current project is ".blue
print "#{File.basename(File.expand_path("."))}".blue.on_light_white

if File.exist?(".git")
  branch = `git rev-parse --abbrev-ref HEAD`
  print " (current branch: ".blue
  print branch.strip.blue.on_light_white
  print ")".blue
end
puts ""

puts "Running #{directive} directive: \"#{command}\"...".green
puts "Use Ctrl-C to stop".green
puts ""
trap( :INT ) { puts "Terminating...".magenta }
fork { exec command }
Process.wait

puts "All done.\r\n".light_blue
