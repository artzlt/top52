class CreateTop50Relations < ActiveRecord::Migration
  def change
    create_table :top50_relations do |t|
      t.integer :prim_obj_id
      t.integer :sec_obj_id
      t.integer :sec_obj_qty
      t.integer :type_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
