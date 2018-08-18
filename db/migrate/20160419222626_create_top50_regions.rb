class CreateTop50Regions < ActiveRecord::Migration
  def change
    create_table :top50_regions do |t|
      t.string :name
      t.string :name_eng
      t.integer :country_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
