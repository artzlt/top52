class CreateTop50AttributeDbvals < ActiveRecord::Migration
  def change
    create_table :top50_attribute_dbvals, :id => false do |t|
      t.integer :id
      t.integer :datatype_id

      t.timestamps
    end
  end
end
