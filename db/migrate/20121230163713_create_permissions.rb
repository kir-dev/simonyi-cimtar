class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :ability
      t.string :resource
      t.references :post

      t.timestamps
    end
    add_index :permissions, :post_id
  end
end
