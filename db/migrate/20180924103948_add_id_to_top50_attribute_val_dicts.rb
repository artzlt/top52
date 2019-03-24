class AddIdToTop50AttributeValDicts < ActiveRecord::Migration
  def change
    add_column :top50_attribute_val_dicts, :id, :primary_key
  end
end
