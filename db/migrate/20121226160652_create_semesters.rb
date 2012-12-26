class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :semester
      t.datetime :valuation_date_from
      t.datetime :valuation_date_to
      t.float :min_scolarship_index
      t.integer :created_by_member

      t.timestamps
    end
  end
end
