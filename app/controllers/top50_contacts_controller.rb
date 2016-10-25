class Top50ContactsController < ApplicationController

  def index
    @top50_contacts = Top50Contact.all
  end

  def show
    @top50_contact = Top50Contact.find(params[:id])
  end
 
  def new
    @top50_contact = Top50Contact.new
  end

  def create
    @linked_obj = Top50Object.new
    @linked_obj[:type_id] = 2
    @linked_obj[:is_valid] = 0
    @linked_obj[:comment] = "NewContact"
    @linked_obj.save!
    @top50_contact = Top50Contact.new(top50contact_params)
    @top50_contact.id = @linked_obj.id
    if @top50_contact.save
      redirect_to :top50_contacts
    else
      render :new
    end
  end

  def edit
    @top50_contact = Top50Contact.find(params[:id])
  end

  def update
    @top50_contact = Top50Contact.find(params[:id])
    @top50_contact.update_attributes(top50contact_params)
    redirect_to :top50_contacts
  end

  def destroy
    @top50_contact = Top50Contact.find(params[:id])
    Top50Object.delete_all(id: params[:id])
    @top50_contact.destroy
    redirect_to :top50_contacts
  end



  def default
    Top50Contact.default!
  end

  private

  def top50contact_params
    params.require(:top50_contact).permit(:name, :name_eng, :surname, :surname_eng, :patronymic, :patronymic_eng, :phone, :email, :extra_info)
  end
end
