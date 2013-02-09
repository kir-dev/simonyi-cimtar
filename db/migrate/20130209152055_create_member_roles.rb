class CreateMemberRoles < ActiveRecord::Migration
  def change
    create_table :member_roles do |t|
      t.references :member
      t.references :role

      t.timestamps
    end
    add_index :member_roles, :member_id
    add_index :member_roles, :role_id
  end
end
