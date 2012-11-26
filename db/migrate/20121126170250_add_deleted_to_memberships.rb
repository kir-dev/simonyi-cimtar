class AddDeletedToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :deleted, :boolean
  end
end
