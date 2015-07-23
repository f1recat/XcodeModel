require "XcodeModel/version"
require 'XcodeModel/engine'
require 'rubygems'

module XcodeModel  
  def self.syncable_models
    ret = []
    ActiveRecord::Base.connection.tables.each do |table| 
      begin
        cls = table.singularize.camelize.constantize
        ret << cls if cls.included_modules.include?(XcodeModel::Model::InstanceMethods)
      rescue
      end
    end
    ret
  end
  
  module Model
    def has_sync?
      XcodeModel.enabled_for_model?(self)
    end
    
    def has_sync(options={})
      send :include, InstanceMethods
    end        
    
    module InstanceMethods
    end    
  end
end

ActiveRecord::Base.send :extend, XcodeModel::Model