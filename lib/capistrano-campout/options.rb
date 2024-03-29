#
# The core of options.rb comes from rails_config, https://github.com/railsjedi/rails_config
#
# Copyright (c) 2010 Jacques Crocker, released under the MIT license
# 
#

require 'ostruct'
require 'yaml'
require 'erb'

module Capistrano
  module Campout
    module Sources
      class YAMLSource

        attr_accessor :path

        def initialize(path)
          @path = path
        end

        # returns a config hash from the YML file
        def load
          if @path and File.exists?(@path.to_s)
            result = YAML.load(IO.read(@path.to_s))
          end
          result || {}
        end

      end
    end
  
    class Options < OpenStruct
      attr_accessor :defaults
      
      def valid?
        # requires the following settings
        # campfire:
        #   domain:
        #   token:
        #   room:
        
        return false if(self.campfire.nil?)
        return false if(self.campfire.domain.nil?)
        return false if(self.campfire.token.nil?)
        return false if(self.campfire.room.nil?)
        return true
      end
  
      def files=(*files)
        if(!files.empty?)
          @files = [files].flatten.compact.uniq
        end
      end
      
      def files
        if(@files.nil? or @files.empty?)
          @files = ["#{File.join(File.dirname(__FILE__), "defaults.yml").to_s}","./config/campout.yml","./config/campout.local.yml"]
        end
        @files
      end
    
      def empty?
        marshal_dump.empty?
      end

      def load_from_files(*files)
        self.files=files
        self.load!
      end
      
      def reload_from_files(*files)
        self.files=files
        self.reload!
      end
    
      def reset_sources!
        self.files.each do |file|
          source = (Sources::YAMLSource.new(file)) if file.is_a?(String)          
          @config_sources ||= []
          @config_sources << source
        end
      end

      # look through all our sources and rebuild the configuration
      def reload!
        self.reset_sources!
        conf = {}
        @config_sources.each do |source|
          source_conf = source.load

          if conf.empty?
            conf = source_conf
          else
            DeepMerge.deep_merge!(source_conf, conf, :preserve_unmergeables => false)
          end
        end

        # swap out the contents of the OStruct with a hash (need to recursively convert)
        marshal_load(__convert(conf).marshal_dump)

        return self
      end

      alias :load! :reload!

      def to_hash
        result = {}
        marshal_dump.each do |k, v|
          result[k] = v.instance_of?(RailsConfig::Options) ? v.to_hash : v
        end
        result
      end

      def to_json(*args)
        require "json" unless defined?(JSON)
        to_hash.to_json(*args)
      end

      def merge!(hash)
        current = to_hash
        DeepMerge.deep_merge!(current, hash.dup)
        marshal_load(__convert(hash).marshal_dump)
        self
      end
    
      protected

      # Recursively converts Hashes to Options (including Hashes inside Arrays)
      def __convert(h) #:nodoc:
        s = self.class.new

        h.each do |k, v|
          s.new_ostruct_member(k)

          if v.is_a?(Hash)
            v = v["type"] == "hash" ? v["contents"] : __convert(v)
          elsif v.is_a?(Array)
            v = v.collect { |e| e.instance_of?(Hash) ? __convert(e) : e }
          end

          s.send("#{k}=".to_sym, v)
        end
        s
      end
    end
  end
end