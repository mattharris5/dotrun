require 'yaml'
require 'colorize'

class Dotrun
  
  DIRECTIVES_PATH = ".run"
  
  # The main operation method. This is called when running `dotrun` from the command line.
  def run(*args)
    print_help_and_exit if args.first == "-?"
    directive = args.first || "default"
    command = command_for(directive)
    
    if command.is_a?(Array)
      exec_multiple_directives directive, command
    else
      exec_directive directive, command
    end
  end

  protected
  
  # Prints out the usage instructions and available command directives for the current directory.
  def print_help_and_exit
    puts "Usage: dotrun [directive]\n".light_black
    print "Available directives for ".blue
    print "#{File.basename(File.expand_path("."))}".blue.bold
    puts ":".blue
    for key, command in directives
      print "  #{key.to_s.ljust(10)}".magenta
      print " -> ".light_black
      command_string = "#{command.length > 60 ? (command[0..60] + "...".light_black) : command}"
      puts command.is_a?(Array) ? command.join(", ").magenta : command_string
    end
    puts ""
    exit
  end
  
  # Clears the screen, prints a header, and the git branch (if available).
  def prep_screen
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
  
  # Execute one of the directives in the list from the `.run` file.
  def exec_directive(directive, command)
    prep_screen
    puts "Running #{directive} directive: \"#{command}\"...".green
    puts "Use Ctrl-C to stop".green
    puts ""
    trap( :INT ) { puts "Terminating...".magenta }
    
    fork { exec command }
    Process.wait
    puts "All done.\r\n".light_blue
  end

  # Execute multiple commands in multiple tabs using `ttab`
  def exec_multiple_directives(directive, command)
    check_for_ttab
    prep_screen
    puts "\n\n\n"
    puts "Running multiple directives in separate tabs:".green
    for d in command
      print "  #{d}".ljust(20).magenta
      sleep 2
      system %(ttab -G eval "dotrun #{d}; exit")
      puts " ✔︎".magenta
    end
    puts ""
    puts "Running!\r\n".light_blue
  end
  
  # Returns all of the directives as a Ruby object.
  def directives
    @directives ||= load_directives
  end

  # Convenience method for fetching the command designated for the specified directive.
  def command_for(directive)
    directives[directive] || abort("Couldn't find the `#{directive}` directive in your config.\r\n".red)
  end

  # Load up the `.run` file from the current directory and populate the @directives instance variable.
  def load_directives
    abort("No .run file detected in current directory.\r\n".red) unless File.exist?(DIRECTIVES_PATH)
    loaded = YAML.load_file(DIRECTIVES_PATH)
    @directives = loaded.is_a?(String) ? { default: loaded } : loaded
  end
  
  # Checks if the `ttab` utility exists on the machine and errors out if not.
  def check_for_ttab
    msg = "It doesn't appear that ttab is installed. Please run "
    msg << "npm install ttab -g ".bold
    msg << "\r\nto install the utility in order to use the multi-command feature."
    abort(msg.red) unless system("which ttab")
  end
  
end
