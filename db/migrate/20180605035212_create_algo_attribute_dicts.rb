class CreateAlgoAttributeDicts < ActiveRecord::Migration
  def change
    create_table :algo_attribute_dicts, :id => false do |t|
      t.integer :id
      t.integer :dict_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
