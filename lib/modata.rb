require "modata/version"
require 'modata/engine'
require 'rubygems'

module Modata  
  def self.syncable_models
    ret = []
    ActiveRecord::Base.connection.tables.each do |table| 
      begin
        cls = table.singularize.camelize.constantize
        ret << cls if cls.included_modules.include?(Modta::Model::InstanceMethods)
      rescue
      end
    end
    ret
  end
  
  module Model 
    def has_sync?
      Modata.enabled_for_model?(self)
    end
    
    def has_sync(options={})
      send :include, InstanceMethods
      self.class_eval do
        before_destroy :_track_deletion        
      end      
    end  
        
    module InstanceMethods
      def _track_deletion
        HasSyncDelete.create(table_name:self.class.name, row_id:self.id) if HasSyncDevice.count > 0
        true
      end            
    end    
  end
end

ActiveRecord::Base.send :extend, Modata::Model