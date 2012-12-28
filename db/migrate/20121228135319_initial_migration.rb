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
      t.integer  :member_id

      t.timestamps
    end

    add_index :job_positions, :member_id

    create_table :member_posts do |t|
      t.integer  :member_id
      t.integer  :group_id
      t.integer  :post_id
      t.datetime :from_date
      t.datetime :to_date

      t.timestamps
    end

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
      t.boolean  :deleted
      t.string   :login
      t.string   :nick

      t.timestamps
    end

    create_table :memberships do |t|
      t.integer  :member_id
      t.integer  :group_id
      t.datetime :from_date
      t.datetime :to_date
      t.boolean  :accepted
      t.boolean  :deleted

      t.timestamps
    end

    create_table :semesters do |t|
      t.string   :semester
      t.datetime :valuation_date_from
      t.datetime :valuation_date_to
      t.float    :min_scolarship_index
      t.integer  :created_by_member

      t.timestamps
    end
  end
end
