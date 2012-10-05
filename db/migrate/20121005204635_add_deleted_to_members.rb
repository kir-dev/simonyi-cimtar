class AddDeletedToMembers < ActiveRecord::Migration
  def change
    add_column :members, :deleted, :boolean
  end
end
