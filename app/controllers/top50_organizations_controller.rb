class Top50OrganizationsController < Top50BaseController
  skip_before_filter :require_login, only: [:suborg]
  skip_before_filter :require_admin_rights, only: [:suborg]
  respond_to :json

  def get_rel_contain_id
    return Top50RelationType.where(name_eng: 'Contains').first.id
  end

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
    @top50_organization = Top50Organization.new(top50organization_params)
    if @top50_organization.save
      if params[:top50_organization][:parent_org_id].present?
        Top50Relation.create(
          type_id: get_rel_contain_id,
          prim_obj_id: params[:top50_organization][:parent_org_id].to_i,
          sec_obj_id: @top50_organization.id,
        )
      end
      redirect_to :top50_organizations
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
    parent_rel = Top50Relation.find_by(sec_obj_id: @top50_organization.id, type_id: get_rel_contain_id)
    if params[:top50_organization][:parent_org_id].present?
      if parent_rel.present?
        parent_rel.prim_obj_id = params[:top50_organization][:parent_org_id].to_i
        parent_rel.save!
      else
        Top50Relation.create(
          type_id: get_rel_contain_id,
          prim_obj_id: params[:top50_organization][:parent_org_id].to_i,
          sec_obj_id: @top50_organization.id,
        )
      end
    else
      if parent_rel.present?
        parent_rel.destroy!
      end
    end
    redirect_to :top50_organizations
  end

  def destroy
    @top50_organization = Top50Organization.find(params[:id])
    @top50_organization.destroy
    redirect_to :top50_organizations
  end

  def default
    Top50Organization.default!
  end

  def suborg
    org_id = params[:org_id]
    org = Top50Organization.find(org_id)
    all_suborgs = Top50Organization.where("is_valid = 1 and id IN (select sec_obj_id from top50_relations where prim_obj_id = #{org_id} and type_id = #{get_rel_contain_id})")
    #@top50_suborgs = all_suborgs.finder(params[:q])
    #json = { records: @top50_suborgs.page(params[:page]).per(params[:per]), total: @top50_suborgs.count}
    @top50_suborgs = all_suborgs
    json = { records: @top50_suborgs, total: @top50_suborgs.count}
    respond_with(json)
  end
  
  private

  def top50organization_params
    params.require(:top50_organization).permit(:name, :name_eng, :website, :city_id, :is_valid)
  end
end
