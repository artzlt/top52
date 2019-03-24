class CreateAlgoAttributeDbs < ActiveRecord::Migration
  def change
    create_table :algo_attribute_dbs, :id => false do |t|
      t.integer :id
      t.integer :db_datatype_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
