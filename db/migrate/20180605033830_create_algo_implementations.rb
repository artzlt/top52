class CreateAlgoImplementations < ActiveRecord::Migration
  def change
    create_table :algo_implementations, :id => false do |t|
      t.integer :id
      t.string :name
      t.string :name_eng
      t.integer :alg_id
      t.string :link
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
