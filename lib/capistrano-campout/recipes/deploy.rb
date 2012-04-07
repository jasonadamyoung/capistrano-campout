# === COPYRIGHT:
# Copyright (c) 2012 Jason Adam Young
# === LICENSE:
# see LICENSE file

#
# Original source from: https://github.com/engineyard/eycap/blob/master/lib/eycap/recipes/deploy.rb
# Copyright (c) 2008-2011 Engine Yard, released under the MIT License
#

Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do    
    # This is here to hook into the logger for deploy tasks
    before("deploy") do
      Capistrano::CampoutLogger.setup(self)
      at_exit{ Capistrano::CampoutLogger.post_process if Capistrano::CampoutLogger.setup? }
    end
  end
end
    