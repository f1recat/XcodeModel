require "modata/version"
require 'modata/engine'
require 'rubygems'

module Modata
  def self.syncable_models
    ret = []
    ActiveRecord::Base.connection.tables.each do |table|
      begin
        cls = table.singularize.camelize.constantize
        ret << cls if cls.included_modules.include?(Modata::Model::InstanceMethods)
      rescue
        begin
          cls = table.camelize.constantize
          ret << cls if cls.included_modules.include?(Modata::Model::InstanceMethods)
        rescue
        end
      end
    end
    ret
  end

  module Model
    def has_modata?
      Modata.syncable_models.include?self
    end

    def has_modata(options={})
      send :include, InstanceMethods      
      self.class_eval do
        before_destroy :_track_deletion   
      end
      
      class_attribute :modata_filter_method
      self.modata_filter_method = options[:filter]
      
      class_attribute :modata_computed_attributes
      self.modata_computed_attributes = options[:computed_attributes]      
      
      class_attribute :modata_except_attributes
      self.modata_except_attributes = options[:except]            
      
      class_attribute :modata_only_attributes
      self.modata_only_attributes = options[:only]                  
    end

    module InstanceMethods
      def _track_deletion
        ModataDelete.create(table_name:self.class.name, row_id:self.id) if ModataDevice.count > 0
        true
      end            
    end
  end
end

ActiveRecord::Base.send :extend, Modata::Model
