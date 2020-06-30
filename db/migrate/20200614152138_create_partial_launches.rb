class CreatePartialLaunches < ActiveRecord::Migration
  def change
    create_table :partial_launches do |t|
      t.integer :launch_id
      t.integer :comp_group_id
      t.integer :comp_group_qty
      t.integer :sub_group_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
