class CreateHasSyncDevices < ActiveRecord::Migration
  def self.up
    create_table :has_sync_devices do |t|
      t.string  :device
      t.integer :state
      t.datetime :last_sync_timestamp
    end
  end

  def self.down
    drop_table :has_sync_devices
  end
end