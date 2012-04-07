# === COPYRIGHT:
# Copyright (c) 2012 Jason Adam Young
# === LICENSE:
# see LICENSE file
module Capistrano
  module Campout
    class GitUtils
      
      def initialize(path)
        @path = path
        if(localrepo)
          return self
        else
          return nil
        end
      end
    
      def localrepo
        if(@localrepo.nil?)
          begin
            @localrepo = Grit::Repo.new(@path)
          rescue Grit::InvalidGitRepositoryError
          end
        end
        @localrepo
      end
     
      def user_name
        if(localrepo)
          git_config = Grit::Config.new(localrepo)
          git_config.fetch('user.name')
        else
          nil
        end
      end
      
      def repository=(repository)
        @repository = repository
      end
      
      def github_url_for_repository
        if(!@mogrified_repository)
          if(@repository =~ /git@github.com/)
            @mogrified_repository = @repository.dup
            @mogrified_repository.gsub!(/git@/, 'http://')
            @mogrified_repository.gsub!(/\.com:/,'.com/')
            @mogrified_repository.gsub!(/\.git/, '')
          end
        end
        @mogrified_repository
      end
      
      def repository_is_github?
        return (!github_url_for_repository.nil?)
      end
      
      def github_compare_url(previous_revision, latest_revision)
        if(repository_is_github?)
          if(previous_revision != latest_revision)
            "#{github_url_for_repository}/compare/#{previous_revision}...#{latest_revision}"
          else
            "#{github_url_for_repository}/commit/#{latest_revision}"
          end
        else
          nil
        end
      end
      
    end
  end
end
        
        
        