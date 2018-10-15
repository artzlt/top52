class CreateTop50AttributeValDicts < ActiveRecord::Migration
  def change
    create_table :top50_attribute_val_dicts, :id => false do |t|
      t.integer :attr_id
      t.integer :obj_id
      t.integer :dict_elem_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
