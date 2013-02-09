class FixLastLoginName < ActiveRecord::Migration
 def change
    rename_column :members, :last_login, :last_active
  end
end
