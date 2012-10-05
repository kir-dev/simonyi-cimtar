class CreateMemberPosts < ActiveRecord::Migration
  def change
    create_table :member_posts do |t|
      t.integer :member_id
      t.integer :group_id
      t.integer :post_id
      t.datetime :from
      t.datetime :to

      t.timestamps
    end
  end
end
