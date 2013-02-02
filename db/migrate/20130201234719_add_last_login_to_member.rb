class AddLastLoginToMember < ActiveRecord::Migration
  def change
    add_column :members, :last_login, :datetime
  end
end
