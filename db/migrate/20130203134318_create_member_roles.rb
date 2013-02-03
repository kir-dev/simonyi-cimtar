class CreateMemberRoles < ActiveRecord::Migration
  def change
    create_table :member_roles do |t|
      t.string :name
      t.references :group

      t.timestamps
    end
    add_index :member_roles, :group_id

    # join table for member-role many-to-many
    create_table :member_roles_members, :id => false do |t|
      t.integer :member_id, :null => false
      t.integer :member_role_id, :null => false
    end
    add_index :member_roles_members, [:member_id, :member_role_id]
  end
end
