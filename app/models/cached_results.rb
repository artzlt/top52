class CachedResults
  ID_FIELDS = [:id, :imp_id, :machine_id, :node_group_id]
  FIELDS = [:launch, :imp, :machine, :node_group]

  attr_reader :results, :partial_runs

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

    @partial_runs = PartialLaunch.where(launch_id: launch_ids).
      map(&:attributes).
      group_by {|x| x["launch_id"]}
    
    @ids = [ids_to_fetch.dup]
    @rels = []
    (0..4).each do |lvl|
      c = get_rels(ids_to_fetch)
      @ids.append(c.collect {|x| x["son_id"]})
      @ids[lvl + 1].uniq!
      ids_to_fetch += @ids[lvl + 1]
      @rels.append(c.group_by {|x| x["parent_id"]})
    end

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

    def upgrade_element(r)
      new_r = {}
      r.each_with_index do |f, i|
        attrs_hash = attrs_by_id(f)
        attrs_hash[:relations] = @rels[0].fetch(f, [])
        attrs_hash[:partial_runs] = @partial_runs.fetch(f, [])
        new_r[FIELDS[i]] = attrs_hash
      end
      return new_r
    end

    @results.collect! {|r| upgrade_element(r)}
    return
  end

  def attrs_by_id(id)
    attrs_hash = {id: id}
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
    return (self.results.uniq {|x| x[:machine][:id]}).collect {|x| x[:machine][:id]}
  end

end
