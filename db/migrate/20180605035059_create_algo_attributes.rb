class CreateAlgoAttributes < ActiveRecord::Migration
  def change
    create_table :algo_attributes do |t|
      t.string :name
      t.string :name_eng
      t.integer :attr_type
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
