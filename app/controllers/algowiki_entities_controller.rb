class AlgowikiEntitiesController < ApplicationController
  skip_before_filter :require_login, only: [:show_by_task, :show_by_alg, :show_by_imp, :index, :index_type, :entities_of_type, :show, :show_by_id, :show_by_id_post]
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
    @algo_results = AlgowikiEntity.select("task, alg, imp, platform, result, cores, type as legacy_type, size").joins("join algo500_sample_results a on a.rus_task = algowiki_entities.name and algowiki_entities.type_id = 2 and algowiki_entities.id = #{@task.id}").order("result desc")
    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=\"PerfData by Problem #{@task.name}.xlsx\""
      }
    end
  end

  def show_by_alg
    @alg = AlgowikiEntity.find(params[:id])
    @algo_results = AlgowikiEntity.select("task, alg, imp, platform, result, cores, type as legacy_type, size").joins("join algo500_sample_results a on a.rus_alg = algowiki_entities.name and algowiki_entities.type_id = 4 and algowiki_entities.id = #{@alg.id}").order("result desc")
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
    @algo_results = AlgowikiEntity.select("task, alg, imp, platform, result, cores, type as legacy_type, size").joins("join algo500_sample_results a on a.rus_alg = algowiki_entities.name and algowiki_entities.type_id = 4 and algowiki_entities.id = #{@alg.id}").joins("join algowiki_entities ae on a.rus_imp = ae.name and ae.type_id = 5 and ae.id = #{@imp.id}").order("result desc")
    respond_to do |format|
      format.html
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=\"PerfData by implementation #{@imp.name} of Algorithm #{@alg.name}.xlsx\""
      }
    end
  end

  def get_limit(limits, e1, def_val)
    if limits.present?
      if limits.include? e1 and limits[e1].present?
        return limits[e1]
      end
    end
    return def_val
  end

  def get_limit2(limits, e1, e2, def_val)
    return get_limit(get_limit(limits, e1, {}), e2, def_val)
  end
  
  helper_method :should_skip
  def should_skip(res)
    return (
      (
        (@ts_from_present or @ts_to_present) and
        (@ts_empty == 0) and (
          not res[:launch].include? 'Task size' or
          res[:launch]['Task size'] > @ts_to or
          res[:launch]['Task size'] < @ts_from
        )
      ) or
      ((@pl_ids.count { |x| x.present? }) > 0 and not @pl_ids.include? res[:machine][:id]) or
      res[:launch]['Nodes'] > @nodes_to or
      res[:launch]['Nodes'] < @nodes_from or
      (@lt_cur.count > 0 and not @lt_cur.include? res[:launch]['Launch type']) or
      (@net_cur.count > 0 and not @net_cur.intersect? res[:machine]['Networks'])
    )
  end

  def show_by_id
    @filter = nil
    @old_ent = nil
    if params.include? "old_id"
      @old_ent = AlgowikiEntity.find(params[:old_id])
    end
    @ent = AlgowikiEntity.find(params[:id])
    ids = @ent.get_all_imps.pluck(:id)
    @cr = CachedResults.new(ids)

    @ts_bounds = (@cr.get_bounds("Task size") or [0, 0])
    @ts_from_present = get_limit2(params[:limits], :task_size, :from, nil).present?
    @ts_to_present = get_limit2(params[:limits], :task_size, :to, nil).present?
    @ts_from = get_limit2(params[:limits], :task_size, :from, @ts_bounds[0]).to_i
    @ts_to = get_limit2(params[:limits], :task_size, :to, @ts_bounds[1]).to_i
    @ts_empty = get_limit2(params[:limits], :task_size, :allow_empty, 1).to_i

    @nodes_bounds = (@cr.get_bounds("Nodes") or [0, 0])
    @nodes_from = get_limit2(params[:limits], :nodes, :from, @nodes_bounds[0]).to_i
    @nodes_to = get_limit2(params[:limits], :nodes, :to, @nodes_bounds[1]).to_i

    @pl_all = @cr.get_all_pl
    @pl_ids = get_limit(params[:limits], :platform_ids, []).collect { |x| x.present? ? x.to_i : nil }

    @lt_all = @cr.get_all_common(:launch, 'Launch type')
    @lt_cur = get_limit(params[:limits], :launch_types, []).select { |x| x.present? }

    @net_all = @cr.get_all_set_common(:machine, 'Networks')
    @net_cur = Set.new(get_limit(params[:limits], :networks, []).select { |x| x.present? })

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
    return
  end

  def show_by_id_post
    old_id = params[:id].to_i
    id = params[:algo_id].to_i
    if params['commit'] == 'SHOW'
      redirect_to action: :show_by_id, id: id, old_id: old_id, limits: params[:limits] and return
    else
      redirect_to action: :show_by_id, id: id, old_id: old_id and return
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
