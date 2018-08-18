class CreateTop50Countries < ActiveRecord::Migration
  def change
    create_table :top50_countries do |t|
      t.string :name
      t.string :name_eng
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
