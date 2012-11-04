# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capistrano-campout/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jason Adam Young"]
  gem.email         = ["jay@outfielding.net"]
  gem.description = <<-EOF 
    Capistrano::Campout is a gem extension to capistrano to post/speak messages and paste logs from a capistrano deployment 
    to a campfire room. Settings are configurable using ERB in a "config/campout.yml" or "config/campout.local.yml" file. 
    Capistrano::Campout will a speak a pre-deployment message, and a post-deployment success or failure message. Event sounds
    are also supported.
  EOF
  gem.summary       = %q{Post messages and paste logs from a capistrano deployment to a campfire room}
  gem.homepage      = %q{https://github.com/outfielding/capistrano-campout}
  gem.license       = 'MIT'
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "capistrano-campout"
  gem.require_paths = ["lib"]
  gem.version       = Capistrano::Campout::VERSION
  gem.add_dependency('capistrano', '>= 2.11')
  gem.add_dependency('broach', '>= 0.2')
  gem.add_dependency('grit', '>= 2.4')
end
