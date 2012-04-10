# === COPYRIGHT:
# Copyright (c) 2012 Jason Adam Young
# === LICENSE:
# see LICENSE file
require 'capistrano'
require 'broach'
require 'grit'

require 'capistrano-campout/logger'
require 'capistrano-campout/version'
require 'capistrano-campout/deep_merge' unless defined?(DeepMerge)
require 'capistrano-campout/options'
require 'capistrano-campout/git_utils'
require 'capistrano-campout/core'

module Capistrano
  module Campout
    def self.extended(configuration)
      configuration.load do    
        set :campout_core, Capistrano::Campout::Core.new
        set :campout_deployer, campout_core.campout_deployer    
      end
    end
  end
end

if Capistrano::Configuration.instance
  Capistrano::Configuration.instance.extend(Capistrano::Campout)

  Capistrano::Configuration.instance(:must_exist).load do
    if(campout_core.settings.valid?)
      # load the recipes
      Dir.glob(File.join(File.dirname(__FILE__), '/capistrano-campout/recipes/*.rb')).sort.each { |f| load f }
      before "deploy", "campout:pre_announce"
    else
      logger.info "The campout configuration is not valid. Make sure that the campfire settings are specified in the campout configuration file(s)"
    end
  end
end