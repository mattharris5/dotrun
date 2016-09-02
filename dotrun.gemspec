Gem::Specification.new do |s|
  s.name        = 'dotrun'
  s.version     = '0.0.1'
  s.date        = '2016-09-01'
  s.summary     = "Simply run your app"
  s.description = "A simple app runner tool"
  s.authors     = ["Matt Harris"]
  s.email       = 'matt@dreamsis.com'
  s.homepage    = 'https://github.com/mattharris5/dotrun'
  s.license     = 'Unlicense'

  # Files and paths
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'
  s.executables  = ['dotrun']

  # Dependencies
  s.add_dependency "colorize", '~> 0'
  
  # Post-install message about ttab
  s.post_install_message = "\e[1;94;49m\r\n** Important dependency note for dotrun gem**\e[0m\r\n\e[0;94;49mIf you want to load multiple commands in separate tabs, you need to install ttab first. For simplicity, this tool is not included in this package. (Sorry! If anyone makes a ruby port let me know.) Use `npm install ttab -g` to easily install this useful utility.\r\n\e[0m"
end
