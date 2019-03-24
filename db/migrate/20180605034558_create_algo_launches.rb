class CreateAlgoLaunches < ActiveRecord::Migration
  def change
    create_table :algo_launches, :id => false do |t|
      t.integer :id
      t.integer :imp_id
      t.integer :node_group_id
      t.integer :machine_id
      t.datetime :start_date
      t.datetime :end_date
      t.integer :is_valid
      t.string :comment

      t.timestamps
    end
  end
end
