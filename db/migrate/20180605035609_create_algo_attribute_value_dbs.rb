class CreateAlgoAttributeValueDbs < ActiveRecord::Migration
  def change
    create_table :algo_attribute_value_dbs do |t|
      t.integer :attr_id
      t.integer :obj_id
      t.string :value
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
