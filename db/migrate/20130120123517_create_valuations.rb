class CreateValuations < ActiveRecord::Migration
  def change
    create_table :valuations do |t|
      t.references :semester
      t.references :member
      t.float :scholarship_index
      t.boolean :community, :default => false
      t.boolean :professional, :default => false

      t.timestamps
    end
    add_index :valuations, :semester_id
    add_index :valuations, :member_id
  end
end
