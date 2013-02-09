class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.datetime :from
      t.datetime :to
      t.string :title
      t.references :membership

      t.timestamps
    end
    add_index :posts, :membership_id
  end
end
