class CreateTop50AttributeValDbvals < ActiveRecord::Migration
  def change
    create_table :top50_attribute_val_dbvals, :id => false do |t|
      t.integer :attr_id
      t.integer :obj_id
      t.binary :value
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
