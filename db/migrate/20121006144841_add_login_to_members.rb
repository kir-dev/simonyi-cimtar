class AddLoginToMembers < ActiveRecord::Migration
  def change
    add_column :members, :login, :string
  end
end
