class AlgowikiEntitiesController < ApplicationController
  skip_before_filter :require_login, only: [:show_by_task, :show_by_alg, :show_by_imp, :index, :index_type, :entities_of_type, :show, :show_by_id]
  before_action :set_algowiki_entity, only: [:show, :edit, :update, :destroy]
  SORT_BY = {
    "performance"=>"Performance, MTEPS",
    "time"=>"Execution time, ms",
    "size"=>"Task size",
    "type"=>"Graph type"
  }
  # GET /algowiki_entities
  def index
    @algowiki_entities = AlgowikiEntity.all
  end

  def index_type
    @algowiki_entity_types = AlgowikiEntityType.select("algowiki_entity_types.id, algowiki_entity_types.name, algowiki_entity_types.name_eng, count(1) as cnt").joins(:algowiki_entities).group("algowiki_entity_types.id, algowiki_entity_types.name, algowiki_entity_types.name_eng")
  end

  def entities_of_type
    @typeid = params[:tid].to_i
    @algowiki_entities = AlgowikiEntity.where(type_id: params[:tid])
  end

  # GET /algowiki_entities/1
  def show
  end

  # GET /algowiki_entities/new
  def new
    @algowiki_entity = AlgowikiEntity.new
  end

  # GET /algowiki_entities/1/edit
  def edit
  end
  
  def show_by_task
    @task = AlgowikiEntity.find(params[:id])
    @algo_results = AlgowikiEntity.select("task, alg, imp, platform, result, cores, type, size").joins("join algo500_sample_results a on a.rus_task = algowiki_entities.name and algowiki_entities.type_id = 2 and algowiki_entities.id = #{@task.id}").order("result desc")
    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=\"PerfData by Problem #{@task.name}.xlsx\""
      }
    end
  end

  def show_by_alg
    @alg = AlgowikiEntity.find(params[:id])
    @algo_results = AlgowikiEntity.select("task, alg, imp, platform, result, cores, type, size").joins("join algo500_sample_results a on a.rus_alg = algowiki_entities.name and algowiki_entities.type_id = 4 and algowiki_entities.id = #{@alg.id}").order("result desc")
    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=\"PerfData by Algorithm #{@alg.name}.xlsx\""
      }
    end
  end
  
  def show_by_imp
    @imp = AlgowikiEntity.find(params[:id])
    @alg = AlgowikiEntity.where("exists (select 1 from algowiki_relations where sec_id = #{@imp.id} and prim_id = algowiki_entities.id and type_id = 1)").first
    @algo_results = AlgowikiEntity.select("task, alg, imp, platform, result, cores, type, size").joins("join algo500_sample_results a on a.rus_alg = algowiki_entities.name and algowiki_entities.type_id = 4 and algowiki_entities.id = #{@alg.id}").joins("join algowiki_entities ae on a.rus_imp = ae.name and ae.type_id = 5 and ae.id = #{@imp.id}").order("result desc")
    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=\"PerfData by implementation #{@imp.name} of Algorithm #{@alg.name}.xlsx\""
      }
    end
  end

  def show_by_id

    @ent = AlgowikiEntity.find(params[:id])
    ids = @ent.get_all_imps.pluck(:id)
    @cr = CachedResults.new(ids)
    if params.include? "sort"
      @sort_attr = SORT_BY.fetch(params["sort"], "Performance, MTEPS")
    else
      @sort_attr = "Performance, MTEPS"
    end
    if params.include? "asc" and params["asc"].present? and params["asc"].downcase == "true"
      @cr.results.sort_by! {|x| x[:launch][@sort_attr]}
    else
      @cr.results.sort_by! {|x| x[:launch][@sort_attr]}.reverse!
    end
  end

  # POST /algowiki_entities
  def create
    @algowiki_entity = AlgowikiEntity.new(algowiki_entity_params)

    if @algowiki_entity.save
      redirect_to :algowiki_entities, notice: 'Algowiki entity was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /algowiki_entities/1
  def update
    if @algowiki_entity.update(algowiki_entity_params)
      redirect_to @algowiki_entity, notice: 'Algowiki entity was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /algowiki_entities/1
  def destroy
    @algowiki_entity.destroy
    redirect_to algowiki_entities_url, notice: 'Algowiki entity was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_algowiki_entity
      @algowiki_entity = AlgowikiEntity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def algowiki_entity_params
      params.require(:algowiki_entity).permit(:name, :name_eng, :wiki_link, :type_id)
    end
end
