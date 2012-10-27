class CreateJobPositions < ActiveRecord::Migration
  def change
    create_table :job_positions do |t|
      t.string :company
      t.string :title
      t.string :location
      t.integer :from_month
      t.integer :from_year
      t.integer :to_month
      t.integer :to_year
      t.references :member

      t.timestamps
    end
    add_index :job_positions, :member_id
  end
end
