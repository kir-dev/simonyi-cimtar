class InitialMigration < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string   :name
      t.integer  :founded
      t.string   :url
      t.string   :mail_list
      t.string   :shortname

      t.timestamps
    end

    create_table :job_positions do |t|
      t.string   :company
      t.string   :title
      t.string   :location
      t.date     :from_date
      t.date     :to_date
      t.boolean  :present_job
      
      t.references  :member

      t.timestamps
    end

    add_index :job_positions, :member_id

    create_table :members do |t|
      t.string   :full_name
      t.string   :email
      t.string   :phone
      t.string   :room
      t.string   :address
      t.text     :intro
      t.integer  :univ_year
      t.integer  :enrollment_year
      t.string   :hobby
      t.boolean  :deleted, default: false
      t.string   :login
      t.string   :nick
      t.boolean  :admin, default: false

      t.timestamps
    end

    create_table :memberships do |t|
      t.references  :member
      t.references  :group
      t.datetime    :from_date
      t.datetime    :to_date
      t.boolean     :accepted, default: false
      t.boolean     :deleted, default: false

      t.timestamps
    end

    add_index :memberships, :member_id
    add_index :memberships, :group_id

    create_table :semesters do |t|
      t.string   :semester
      t.datetime :valuation_date_from
      t.datetime :valuation_date_to
      t.float    :min_scholarship_index
      
      # created by member relation
      t.integer  :created_by

      t.timestamps
    end

    add_index :semesters, :created_by
  end
end
