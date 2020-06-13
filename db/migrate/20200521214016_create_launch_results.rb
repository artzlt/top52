class CreateLaunchResults < ActiveRecord::Migration
  def change
    create_table :launch_results do |t|
      t.integer :imp_id
      t.integer :machine_id
      t.integer :node_group_id
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
