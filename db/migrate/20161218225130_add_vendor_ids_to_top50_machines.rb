class AddVendorIdsToTop50Machines < ActiveRecord::Migration
  def change
    add_column :top50_machines, :vendor_ids, :integer, array:true, default: []  
  end
end
