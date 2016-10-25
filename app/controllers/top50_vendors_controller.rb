class Top50VendorsController < ApplicationController

  def index
    @top50_vendors = Top50Vendor.all
  end

  def show
    @top50_vendor = Top50Vendor.find(params[:id])
  end
 
  def new
    @top50_vendor = Top50Vendor.new
  end

  def create
    @linked_obj = Top50Object.new
    @linked_obj[:type_id] = 3
    @linked_obj[:is_valid] = 0
    @linked_obj[:comment] = "NewVendor"
    @linked_obj.save!
    @top50_vendor = Top50Vendor.new(top50vendor_params)
    @top50_vendor.id = @linked_obj.id
    if @top50_vendor.save
      redirect_to :top50_vendors
    else
      render :new
    end
  end

  def edit
    @top50_vendor = Top50Vendor.find(params[:id])
  end

  def update
    @top50_vendor = Top50Vendor.find(params[:id])
    @top50_vendor.update_attributes(top50vendor_params)
    redirect_to :top50_vendors
  end

  def destroy
    @top50_vendor = Top50Vendor.find(params[:id])
    Top50Object.delete_all(id: params[:id])
    @top50_vendor.destroy
    redirect_to :top50_vendors
  end



  def default
    Top50Vendor.default!
  end

  private

  def top50vendor_params
    params.require(:top50_vendor).permit(:name, :name_eng, :website)
  end
end
