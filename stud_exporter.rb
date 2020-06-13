require 'json'
json = File.read('/root/Stud_data.json')
results = JSON.parse(json)
cnt = 0
gt_dict = Top50Dictionary.find_by(name_eng: 'Graph type').id
gt_attr = Top50Attribute.find_by(name_eng: 'Graph type').id

lt_dict = Top50Dictionary.find_by(name_eng: 'Launch type').id
lt_attr = Top50Attribute.find_by(name_eng: 'Launch type').id
gpu_only_elem = Top50DictionaryElem.find_by(dict_id: lt_dict, name_eng: "GPU-only").id

mpi_attr = Top50Attribute.find_by(name_eng: 'MPI processes').id
omp_attr = Top50Attribute.find_by(name_eng: 'OpenMP threads').id
cuda_attr = Top50Attribute.find_by(name_eng: 'CUDA threads').id
perf_attr = Top50Attribute.find_by(name_eng: 'Performance, MTEPS').id
ts_attr = Top50Attribute.find_by(name_eng: 'Task size').id

results.each do |result|
  cnt += 1
  alg_id = AlgowikiEntity.find_by(type_id: 4, name_eng: result["alg"], comment: "Students").id
  imp_id = AlgoImplementation.find_by(alg_id: alg_id, name_eng: result["imp"], comment: "Students").id
  machine_id = Top50Machine.find_by(name: result["platform"], comment: "Students").id
  size = result["size"].to_i
  pow_idx = result["size"].index('^')
  if pow_idx.present?
    size = size ** result["size"][pow_idx+1..-1].to_i
  end
  perf = result["result"].to_f
  gt_id = Top50DictionaryElem.find_by(dict_id: gt_dict, name_eng: result["type"].downcase).id

  x = LaunchResult.create(imp_id: imp_id, machine_id: machine_id, is_valid: 3, comment: "Students")
  Top50AttributeValDbval.create(attr_id: perf_attr, obj_id: x.id, value: perf.to_s, is_valid: 3, comment: "Students")
  Top50AttributeValDbval.create(attr_id: ts_attr, obj_id: x.id, value: size.to_s, is_valid: 3, comment: "Students")
  Top50AttributeValDict.create(attr_id: gt_attr, obj_id: x.id, dict_elem_id: gt_id, is_valid: 3, comment: "Students")

  mpi_procs = nil
  cuda_threads = nil
  omp_threads = nil
  if result.include? 'cores' and result['cores'].present?
    mpi_procs = result['cores'].to_i
  elsif result.include? 'cores_old' and result['cores_old'].present?
    if result['cores_old'].include? "CUDA"
      cuda_threads =  result['cores_old'].to_i
    elsif result['cores_old'].include? "нитей"
      omp_threads = result['cores_old'].to_i
    elsif result['cores_old'].include? "MPI"
      mpi_procs = result['cores_old'].to_i
      if result['cores_old'].include? "OpenMP"
        idx = result['cores_old'].index('x')
        omp_threads = result['cores_old'][idx+1..-1].to_i
      end
    elsif result['cores_old'].include? "GPU"
      Top50AttributeValDict.create(attr_id: lt_attr, obj_id: x.id, dict_elem_id: gpu_only_elem, is_valid: 3, comment: "Students")
    end
  end
  if mpi_procs.present? and mpi_procs > 0
    Top50AttributeValDbval.create(attr_id: mpi_attr, obj_id: x.id, value: mpi_procs.to_s, is_valid: 3, comment: "Students")
  end
  if omp_threads.present? and omp_threads > 0
    Top50AttributeValDbval.create(attr_id: omp_attr, obj_id: x.id, value: omp_threads.to_s, is_valid: 3, comment: "Students")
  end
  if cuda_threads.present? and cuda_threads > 0
    Top50AttributeValDbval.create(attr_id: cuda_attr, obj_id: x.id, value: cuda_threads.to_s, is_valid: 3, comment: "Students")
  end
  puts cnt
end

puts 'Done'
