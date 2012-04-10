# Capistrano::Campout

Capistrano::Campout is a gem extension to capistrano to post/speak messages 
and paste logs from a capistrano deployment to a campfire room. Settings are 
configurable in a "config/campout.yml" and/or "config/campout.local.yml" 
file. ERB templates are supported for messages and can use all of the 
capistrano settings.
 
Capistrano::Campout will a speak messages at pre-deployment and 
post-deployment success or failure. Event sounds are also supported.

## Design goals

Capistrano::Campout is inspired by and borrows concepts (and in some cases code) 
from two projects: [capistrano-mountaintop](https://github.com/technicalpickles/capistrano-mountaintop) and [capfire](https://github.com/pjaspers/capfire). 

I created my own instead of forking either for the following reasons

* I initially wanted to use Tinder (Capfire uses broach). I later went with Broach due to ActiveSupport (which Tinder requires) conflicts with Capistrano.
* I wanted more customization with regard to messages than capfire provided.
* I liked EngineYard's logger implementation much better than capistrano-log_with_awesome (which capistrano-mountaintop depends on) - and liked it better integrated into campout's gem itself.
* I wanted configuration-file based settings that I can separate into shared (checked into git) and local (git ignored) files
* I wanted room to expand for my team's needs for utilities for git and github inspection

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-campout'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-campout

## Setup

You can generate a configuration by running

    campout generate_config

This will prompt you for your campfire configuration settings and create config/campout.yml and config/campout.local.yml files for you, adding config/campout.local.yml to your .gitignore file (if present) and adding a require 'capistrano-campout' to your config/deploy.rb file.

## Manual Setup

Alternatively add a:

	require "capistrano-campout"  

to your capistrano deploy.rb and create a config/campout.yml and/or a config/campout.local.yml with your campfire settings (required)

	campfire:
	    domain: your_campfire_domain
	    room: room_id_to_post_to
	    token: your_campfire_api_token

"config/campout.yml" is meant to be a pre-project file and can contain global settings for everyone. Don't put the api token in a campout.yml file that's part of a public git repository

"config/campout.local.yml" is meant as a local/private configuration file - I'd recommend adding the file to the .gitignore

## Settings

Run the 'campout generate_config' command - and the config/campout.yml file will have a list of all the known settings.

Otherwise, use the source, Luke.

## Known Limitations

There isn't much error checking on the campfire connection. And there's no tests. The latter might be a feature.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Sources

Capistrano::Campout includes code and ideas from the following projects:

* [rails_config](https://github.com/railsjedi/rails_config) Copyright © 2010 Jacques Crocker
* [deep_merge](https://github.com/danielsdeleo/deep_merge) Copyright © 2008 Steve Midgley, now mainted by Daniel DeLeo
* [eycap](https://github.com/engineyard/eycap) Copyright © 2008-2011 Engine Yard
* [capfire](https://github.com/pjaspers/capfire) Copyright © 2010 Piet Jaspers 10to1
* [capistrano-mountaintop](https://github.com/technicalpickles/capistrano-mountaintop) Copyright © 2010 Joshua Nichols.


