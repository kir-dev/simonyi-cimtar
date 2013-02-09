class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name
      t.references :group

      t.timestamps
    end
    add_index :roles, :group_id

    # join table for member-role many-to-many
    create_table :members_roles, :id => false do |t|
      t.integer :member_id, :null => false
      t.integer :role_id, :null => false
    end
    add_index :members_roles, [:member_id, :role_id]
  end
end
