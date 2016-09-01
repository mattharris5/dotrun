#!/usr/bin/ruby
require 'YAML'
require 'colorize'

directives_path = ".run"
abort("No .run file detected in current directory.\r\n".red) unless File.exist?(directives_path)
directives = YAML.load_file(directives_path)

def print_help_and_exit(directives)
  puts "\nUsage: dotrun [directive]\n".light_black
  print "Available directives for ".blue
  print "#{File.basename(File.expand_path("."))}".blue.bold
  puts ":".blue
  directives = { default: directives } if directives.is_a?(String)
  for key, command in directives
    print "  #{key.to_s.ljust(10)}".magenta
    print " -> ".light_black
    command_string = "#{command.length > 60 ? (command[0..60] + "...".light_black) : command}"
    puts command.is_a?(Array) ? command.join(", ").magenta : command_string
  end
  puts ""
  exit
end

def prep_screen()
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
end

def exec_directive(directive, command)
  prep_screen()
  puts "Running #{directive} directive: \"#{command}\"...".green
  puts "Use Ctrl-C to stop".green
  puts ""
  trap( :INT ) { puts "Terminating...".magenta }

  fork { exec command }
  Process.wait
  puts "All done.\r\n".light_blue
end

directive = ARGV[0] || "default"
command = directives.is_a?(String) ? directives : directives[directive]
print_help_and_exit(directives) if directive == "-?"
abort("Couldn't find the `#{directive}` directive in your config.\r\n".red) unless command

if command.is_a?(Array)
  prep_screen()
  puts "\n\n"
  puts "Running multiple directives in separate tabs:".green
  for d in command
    print "  #{d}".ljust(20).magenta
    sleep 2
    system %(ttab -G eval "dotrun #{d}; exit")
    puts " ✔︎".magenta
  end
  puts ""
  puts "Running!\r\n".light_blue
else
  exec_directive directive, command
end
