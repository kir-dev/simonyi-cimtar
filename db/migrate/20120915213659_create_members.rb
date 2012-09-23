class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :fullName
      t.string :email
      t.string :phone
      t.string :room
      t.string :address
      t.text :intro
      t.integer :univYear
      t.string :hobby

      t.timestamps
    end
  end
end
