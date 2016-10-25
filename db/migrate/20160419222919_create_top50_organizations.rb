class CreateTop50Organizations < ActiveRecord::Migration
  def change
    create_table :top50_organizations, :id => false do |t|
      t.integer :id
      t.string :name
      t.string :name_eng
      t.string :website
      t.integer :city_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
