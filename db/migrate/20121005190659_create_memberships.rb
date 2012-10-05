class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :member_id
      t.integer :group_id
      t.datetime :from
      t.datetime :to

      t.timestamps
    end
  end
end
