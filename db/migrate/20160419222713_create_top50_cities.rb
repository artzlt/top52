class CreateTop50Cities < ActiveRecord::Migration
  def change
    create_table :top50_cities do |t|
      t.string :name
      t.string :name_eng
      t.integer :region_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
