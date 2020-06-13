require 'json'
asdfasfddssf
json = File.read('/root/Ilia_data.json')
results = JSON.parse(json)
cnt = 0
gt_dict = Top50Dictionary.find_by(name_eng: 'Graph type').id
gt_attr = Top50Attribute.find_by(name_eng: 'Graph type').id

dt_dict = Top50Dictionary.find_by(name_eng: 'Dataset type').id
dt_attr = Top50Attribute.find_by(name_eng: 'Dataset type').id

perf_attr = Top50Attribute.find_by(name_eng: 'Performance, MTEPS').id
ts_attr = Top50Attribute.find_by(name_eng: 'Task size').id

results.each do |result|
  cnt += 1
  if cnt <= 1
    next
  end
  alg_id = AlgowikiEntity.find_by(type_id: 4, name_eng: result["Alg"], comment: "Ilia").id
  imp_id = AlgoImplementation.find_by(alg_id: alg_id, name_eng: result["Imp"]).id
  machine_id = Top50Machine.find_by(name: result["Platform"]).id
  size = result["size"].to_i
  ['rmat', 'dir rmat', 'random uniform', 'social', 'hyperlink', 'other'].each do |gt|
    if result.include? 'result ' + gt and result['result ' + gt].present?
      gt_id = Top50DictionaryElem.find_by(dict_id: gt_dict, name_eng: gt, comment: "Ilia").id
      perf = result['result ' + gt].to_f
      x = LaunchResult.create(imp_id: imp_id, machine_id: machine_id, is_valid: 1, comment: "Ilia")
      Top50AttributeValDbval.create(attr_id: perf_attr, obj_id: x.id, value: perf.to_s, is_valid: 1, comment: "Ilia")
      Top50AttributeValDbval.create(attr_id: ts_attr, obj_id: x.id, value: size.to_s, is_valid: 1, comment: "Ilia")
      Top50AttributeValDict.create(attr_id: gt_attr, obj_id: x.id, dict_elem_id: gt_id, is_valid: 1, comment: "Ilia")
      if ['social', 'hyperlink', 'other'].include? gt
        dt_id = Top50DictionaryElem.find_by(dict_id: dt_dict, name_eng: result['type ' + gt], comment: "Ilia").id
        Top50AttributeValDict.create(attr_id: dt_attr, obj_id: x.id, dict_elem_id: dt_id, is_valid: 1, comment: "Ilia")
      end
    end
  end
  puts cnt
end

puts 'Hello'
