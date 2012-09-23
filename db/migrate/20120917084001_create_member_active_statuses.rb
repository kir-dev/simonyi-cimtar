class CreateMemberActiveStatuses < ActiveRecord::Migration
  def change
    create_table :member_active_statuses do |t|
      t.int :member_id
      t.int :group_id
      t.datetime :from
      t.datetime :to

      t.timestamps
    end
  end
end
