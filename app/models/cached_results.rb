class CachedResults
  ID_FIELDS = [:id, :imp_id, :machine_id, :node_group_id]
  FIELDS = [:launch, :imp, :machine, :node_group]
  COMPS = ['CPU', 'GPU', 'Coprocessor', 'Accelerator']

  attr_reader :results, :partial_runs, :all_attrs

  def self.map_to_idx(field)
    return ID_FIELDS.index(field)
  end

  def get_rels(obj_ids)
    rels = Top50Relation.select("prim_obj_id as parent_id, sec_obj_id as son_id, sec_obj_qty as count, top50_relations.type_id, ot.name_eng as son_type").
      joins("join top50_objects o on o.id = sec_obj_id").
      joins("join top50_object_types ot on ot.id = o.type_id").
      where(prim_obj_id: obj_ids).
      map(&:attributes)
    return rels
  end

  def initialize(imp_ids, is_valid=1)
    @results = LaunchResult.select(*ID_FIELDS).where(imp_id: imp_ids, is_valid: is_valid).pluck(*ID_FIELDS) or []
    ids_to_fetch = []
    launch_ids = []
    @results.each do |r|
      launch_ids.append(r[CachedResults.map_to_idx(:id)])
      ids_to_fetch += r
    end

    @ids = [ids_to_fetch.dup]
    @rels = []
    (0..4).each do |lvl|
      c = get_rels(ids_to_fetch)
      @ids.append(c.collect {|x| x["son_id"]})
      @ids[lvl + 1].uniq!
      ids_to_fetch += @ids[lvl + 1]
      @rels.append(c.group_by {|x| x["parent_id"]})
    end
    @partial_runs = PartialLaunch.where(launch_id: launch_ids).
      map(&:attributes)
    @rels[2].merge!(get_rels(@partial_runs.collect { |x| x["sub_group_id"] }).group_by {|x| x["parent_id"]})
    @partial_runs = @partial_runs.group_by {|x| x["launch_id"]}

    @attrs_dbval = Top50AttributeValDbval.select("a.name, a.name_eng, ad.datatype_id, obj_id, value, dt.db_code").
      joins("join top50_attribute_dbvals ad on ad.id = top50_attribute_val_dbvals.attr_id").
      joins("join top50_attributes a on a.id = ad.id").
      joins("join top50_attribute_datatypes dt on dt.id = ad.datatype_id").
      where(obj_id: ids_to_fetch).
      map(&:attributes).
      group_by {|x| x["obj_id"]}
    @attrs_dict = Top50AttributeValDict.select("a.name, a.name_eng, obj_id, de.name as value").
      joins("join top50_attributes a on a.id = top50_attribute_val_dicts.attr_id").
      joins("join top50_dictionary_elems de on de.id = top50_attribute_val_dicts.dict_elem_id").
      where(obj_id: ids_to_fetch).
      map(&:attributes).
      group_by {|x| x["obj_id"]}

    @all_attrs = Hash[FIELDS.collect { |v| [v, Set['Nodes', 'Launch type']] }]

    def upgrade_element(r)
      new_r = {}
      r.each_with_index do |f, i|
        attrs_hash = attrs_by_id(f)
        @all_attrs[FIELDS[i]].merge(attrs_hash.keys)
        attrs_hash[:id] = f
        attrs_hash[:relations] = @rels[0].fetch(f, [])
        attrs_hash[:partial_runs] = @partial_runs.fetch(f, [])
        new_r[FIELDS[i]] = attrs_hash
      end
      ng = new_r[:node_group]
      if not ng[:id].present?
        ng = new_r[:machine]
      end
      new_r[:launch]['Nodes'] = ng[:relations].inject(0) {|sum, rel| sum += (rel["son_type"] == "Compute node") ? rel["count"] : 0}
      if new_r[:machine]['Communication network family'].present?
        new_r[:machine]['Networks'] = Set[new_r[:machine]['Communication network family']]
      else
        nets = Set[]
        (ng[:relations].select { |rel| rel["son_type"] == "Compute node" }).each do |node|
          (self.rels_by_id(node["son_id"], 1).select { |rel| rel["son_type"] == "Interconnect" }).each do |ic|
            ic_attrs = attrs_by_id(ic["son_id"])
            if ic_attrs['Interconnect family'].present?
              nets.add(ic_attrs['Interconnect family'])
            end
          end
        end
        new_r[:machine]['Networks'] = nets
      end
      if not new_r[:launch]['Launch type'].present?
        has_comps = (COMPS.collect { |x| [x, false] }).to_h
        (ng[:relations].select { |rel| rel["son_type"] == "Compute node" }).each do |node|
          (self.rels_by_id(node["son_id"], 1).select { |rel| rel["son_type"] == "Compute group" }).each do |cg|
            cg_is_partial = false
            partial_cg_cnt = 0
            if new_r[:launch][:partial_runs].present? 
              (new_r[:launch][:partial_runs].select { |x| x["comp_group_id"] == cg["son_id"] }).each do |pr|
                if pr["comp_group_qty"].present?
                  partial_cg_cnt += pr["comp_group_qty"]
                else
                  cg_is_partial = true
                end

                has_comps.each_key do |comp_type|
                  if has_children_common(pr["sub_group_id"], 2, comp_type)
                    has_comps[comp_type] = true
                  end
                end
              end
            end
            cg_is_partial = (cg_is_partial or (cg["count"] <= partial_cg_cnt))
            if not cg_is_partial
              has_comps.each_key do |comp_type|
                if has_children(cg, 2, comp_type)
                  has_comps[comp_type] = true
                end
              end
            end
          end

          has_comps.each_key do |comp_type|
            if has_children(node, 1, comp_type)
              has_comps[comp_type] = true
            end
          end

        end
        has_comps.select! { |k, v| v }
        if has_comps.length > 1
          new_r[:launch]['Launch type'] = 'Hybrid'
        elsif has_comps.length == 0
          new_r[:launch]['Launch type'] = 'Undefined'
        else
          new_r[:launch]['Launch type'] = "#{has_comps.key(true)}-only"
        end
      end
      return new_r
    end

    @results.collect! {|r| upgrade_element(r)}
    return
  end

  def attrs_by_id(id)
    attrs_hash = {}
    @attrs_dbval.fetch(id, []).each do |a|
      attrs_hash[a["name_eng"]] = Top50AttributeValDbval.fetch_value(
       a["db_code"],
       a["value"]
      )
    end
    @attrs_dict.fetch(id, []).each do |a|
      attrs_hash[a["name_eng"]] = a["value"]
    end
    return attrs_hash
  end

  def rels_by_id(id, lvl)
    return (@rels[lvl][id] or {})
  end

  def get_bounds(attr)
    elems = self.results.select {|x| x[:launch].include? attr}
    if elems.present?
      return (elems.minmax_by {|x| x[:launch][attr]}).collect {|x| x[:launch][attr]}
    end
    return nil
  end

  def get_all_pl
    return get_all_common(:machine, :id)
  end

  def get_all_common(cat, attr)
    return (self.results.uniq { |x| x[cat][attr] }).collect { |x| x[cat][attr] }
  end

  def get_all_set_common(cat, attr)
    result = Set[]
    self.results.each { |x| result.merge(x[cat][attr]) }
    return result
  end

  def launch_attrs
    return @all_attrs[:launch]
  end

  def has_children(elem, level, type)
    return self.has_children_common(elem["son_id"], level, type)
  end

  def has_children_common(obj_id, level, type)
    return self.rels_by_id(obj_id, level).any? { |rel| rel["son_type"] == type }
  end

end
