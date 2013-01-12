class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.boolean :can_create, :default => false
      t.boolean :can_read, :default => false
      t.boolean :can_update, :default => false
      t.boolean :can_destroy, :default => false
      
      t.string :resource
      t.references :post

      t.timestamps
    end
    add_index :permissions, :post_id
  end
end
