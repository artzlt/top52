class CreateTop50Machines < ActiveRecord::Migration
  def change
    create_table :top50_machines, :id => false do |t|
      t.integer :id
      t.string :name
      t.string :name_eng
      t.string :website
      t.integer :type_id
      t.integer :org_id
      t.integer :vendor_id
      t.integer :contact_id
      t.date :start_date
      t.date :end_date
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
