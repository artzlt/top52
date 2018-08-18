class Top50OrganizationsController < ApplicationController
  skip_before_filter :require_login, only: [:suborg]
  respond_to :json

  def index
    @top50_organizations = Top50Organization.all
  end

  def show
    @top50_organization = Top50Organization.find(params[:id])
  end
 
  def new
    @top50_organization = Top50Organization.new
  end

  def create
    @linked_obj = Top50Object.new
    @linked_obj[:type_id] = 4
    @linked_obj[:is_valid] = 0
    @linked_obj[:comment] = "NewOrganization"
    @linked_obj.save!
    @top50_organization = Top50Organization.new(top50organization_params)
    @top50_organization.id = @linked_obj.id
    if @top50_organization.save
      redirect_to :back
    else
      render :new
    end
  end

  def edit
    @top50_organization = Top50Organization.find(params[:id])
  end

  def update
    @top50_organization = Top50Organization.find(params[:id])
    @top50_organization.update_attributes(top50organization_params)
    redirect_to :top50_organizations
  end

  def destroy
    @top50_organization = Top50Organization.find(params[:id])
    Top50Object.delete_all(id: params[:id])
    @top50_organization.destroy
    redirect_to :top50_organizations
  end



  def default
    Top50Organization.default!
  end

  def suborg
    org_id = params[:org_id]
    org = Top50Organization.find(org_id)
    rel_contain_id = Top50RelationType.where(name_eng: 'Contains').first.id
    all_suborgs = Top50Organization.where("is_valid = 1 and id IN (select sec_obj_id from top50_relations where prim_obj_id = #{org_id} and type_id = #{rel_contain_id})")
    #@top50_suborgs = all_suborgs.finder(params[:q])
    #json = { records: @top50_suborgs.page(params[:page]).per(params[:per]), total: @top50_suborgs.count}
    @top50_suborgs = all_suborgs
    json = { records: @top50_suborgs, total: @top50_suborgs.count}
    respond_with(json)
  end
  
  private

  def top50organization_params
    params.require(:top50_organization).permit(:name, :name_eng, :website)
  end
end
