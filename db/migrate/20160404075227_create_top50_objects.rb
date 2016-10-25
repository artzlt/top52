class CreateTop50Objects < ActiveRecord::Migration
  def change
    create_table :top50_objects do |t|
      t.integer :type_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
