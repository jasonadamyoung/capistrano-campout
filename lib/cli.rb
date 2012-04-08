# === COPYRIGHT:
# Copyright (c) 2012 Jason Adam Young
# === LICENSE:
# see LICENSE file
require 'thor'
require 'yaml'
require 'capistrano-campout/version'

module Campout
  class CLI < Thor
    include Thor::Actions

    # these are not the tasks that you seek
    def self.source_root
      File.expand_path(File.dirname(__FILE__) + "/..")
    end
    
    no_tasks do
      
      def copy_configs
        # campout.yml
        destination = "./config/campout.yml"
        if(!File.exists?(destination))
          copy_file('templates/campout.yml',destination)
        end
        #
        destination = "./config/campout.local.yml"
        if(!File.exists?(destination))
          copy_file('templates/campout.local.yml',destination)
        end
      end
      
      def add_campfire_settings(open_repository,campfire_settings)
        if(open_repository)
          settings_file = "./config/campout.local.yml"
        else
          settings_file = "./config/campout.yml"
        end
        
        # has campfire settings?
        has_campfire_settings = false
        if(existing_settings = YAML.load(IO.read(settings_file)))
          if(!existing_settings['campfire'].nil?)
            has_campfire_settings = true
          end
        end
        
        if(!has_campfire_settings)
          append_file(settings_file,campfire_settings.to_yaml)
        end
      end
      
      def add_local_to_gitignore
        gitignore_file = './.gitignore'
        if(File.exists?(gitignore_file))
          if(!(File.read(gitignore_file) =~ %r{config/campout.local.yml}))
            append_file(gitignore_file,"config/campout.local.yml\n")
          end
        end
      end
      
      def add_campout_to_deploy
        cap_deploy_script = './config/deploy.rb'
        if(File.exists?(cap_deploy_script))
          if(!(File.read(cap_deploy_script) =~ %r{require ['|"]capistrano-campout["|']}))
            prepend_file(cap_deploy_script,"require 'capistrano-campout'\n")
          end
        end
      end
    end


    desc "about", "about campout"  
    def about
      puts "Campout Version #{Capistrano::Campout::VERSION}: Post messages and paste logs from a capistrano deployment to a campfire room."
    end
    
    desc "generate_config", "generate campout configuration files"
    def generate_config
      open_repository = yes?("Is this an open/public repository?")
      if(open_repository)
        say "Your campout settings will be added to ./config/campout.local.yml"
      else
        say "Your campout settings will be added to ./config/campout.yml"
      end  
      campfire_settings = {'campfire' => {'domain' => 'domain', 'room' => 'room', 'token' => 'token'}}
      campfire_settings['campfire']['domain'] = ask("Your campfire domain:")
      campfire_settings['campfire']['room'] = ask("Your campfire room ID:")
      campfire_settings['campfire']['token'] = ask("Your campfire api token:")
        
      copy_configs
      add_campfire_settings(open_repository,campfire_settings)
      add_local_to_gitignore
      add_campout_to_deploy
    end        
  end
  
end
