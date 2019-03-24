class CreateAlgoAttributeDbDatatypes < ActiveRecord::Migration
  def change
    create_table :algo_attribute_db_datatypes do |t|
      t.string :name
      t.string :name_eng
      t.string :db_code

      t.timestamps
    end
  end
end
