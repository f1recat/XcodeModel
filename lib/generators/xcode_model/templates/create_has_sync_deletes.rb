class CreateHasSyncDeletes < ActiveRecord::Migration
  def self.up
    create_table :has_sync_deletes do |t|
      t.string  :table_name
      t.integer :row_id
    end
  end

  def self.down
    drop_table :has_sync_deletes
  end
end