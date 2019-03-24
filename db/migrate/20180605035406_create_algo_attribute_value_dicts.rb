class CreateAlgoAttributeValueDicts < ActiveRecord::Migration
  def change
    create_table :algo_attribute_value_dicts do |t|
      t.integer :attr_id
      t.integer :obj_id
      t.integer :dict_elem_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
