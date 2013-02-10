class RemoveColumn < ActiveRecord::Migration
  def change
  	remove_column :members, :admin
  end
end
