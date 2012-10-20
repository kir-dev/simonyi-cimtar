class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :founded
      t.string :url
      t.string :mail_list
      t.string :shortname

      t.timestamps
    end
  end
end
