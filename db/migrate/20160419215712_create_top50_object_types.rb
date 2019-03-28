class CreateTop50ObjectTypes < ActiveRecord::Migration
  def change
    create_table :top50_object_types do |t|
      t.string :name
      t.string :name_eng
      t.integer :parent_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
