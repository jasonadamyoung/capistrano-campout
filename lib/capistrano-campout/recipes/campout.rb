# === COPYRIGHT:
# Copyright (c) 2012 Jason Adam Young
# === LICENSE:
# see LICENSE file

#
# Post process hooks inspired by: https://github.com/engineyard/eycap/blob/master/lib/eycap/lib/ey_logger_hooks.rb
# Copyright (c) 2008-2011 Engine Yard, released under the MIT License
#

Capistrano::Configuration.instance(:must_exist).load do
  namespace :campout do
    
    ## no descriptions for the following tasks - meant to be hooked by capistrano
    task :pre_announce do
      set(:whereto,campout_core.whereto(self))
      campout_core.pre_announce(binding: binding)
    end
    
    task :post_announce_success do
      set(:whereto,campout_core.whereto(self))
      campout_core.post_announce_success(binding: binding, 
                                         repository: repository, 
                                         previous_revision: previous_revision, 
                                         latest_revision: latest_revision)
    end
    
    task :post_announce_failure do
      set(:whereto,campout_core.whereto(self))
      campout_core.post_announce_failure(binding: binding)
    end
    
    task :copy_log, :except => { :no_release => true} do
      if(campout_core.settings.copy_log_to_server)
        logger = Capistrano::CampoutLogger
        run "mkdir -p #{shared_path}/deploy_logs"
        put File.open(logger.log_file_path).read, "#{shared_path}/deploy_logs/#{logger.remote_log_file_name}"
      end
    end
    
    desc "Display campfire messages and actions based on current configuration"
    task :will_do do
      set(:whereto,campout_core.whereto(self))
      campout_core.will_do(binding: binding)
    end
    
    task :settings do
      y campout_core.settings
    end
  end
end

Capistrano::CampoutLogger.post_process_hook("campout:post_announce_success",:success)
Capistrano::CampoutLogger.post_process_hook("campout:post_announce_failure",:failure)
Capistrano::CampoutLogger.post_process_hook("campout:copy_log",:any)
