require 'rails/generators'
require 'rails/generators/active_record'

module XcodeModel
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration
    
    source_root File.expand_path('../templates', __FILE__)
    desc 'Generates delete table migration'
    
    def create_migration_file
      add_xcode_model_migration 'create_has_sync_deletes'
      add_xcode_model_migration 'create_has_sync_devices'
    end
    
    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
    
    protected
    
    def add_xcode_model_migration(template)
      migration_dir = File.expand_path 'db/migrate'
      migration_template "#{template}.rb", "db/migrate/#{template}.rb" unless self.class.migration_exists?(migration_dir, template)
    end
  end
end