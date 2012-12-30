class PostMembershipJoinTable < ActiveRecord::Migration
  def change
    create_table :member_posts_memberships, :id => false do |t|
      t.references :membership
      t.references :member_post
    end

    add_index :member_posts_memberships, :member_post_id
    add_index :member_posts_memberships, :membership_id
  end
end
