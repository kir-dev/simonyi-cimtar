class CreateMemberPosts < ActiveRecord::Migration
  def change
    create_table :member_posts do |t|
      t.int :member_id
      t.int :group_id
      t.int :post_id
      t.datetime :from
      t.datetime :to

      t.timestamps
    end
  end
end
