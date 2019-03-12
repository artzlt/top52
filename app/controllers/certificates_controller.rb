class CertificatesController < ApplicationController
  before_action :require_cert_moder_rights

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def page1
    n = Top50Benchmark.where("top50_benchmarks.name_eng LIKE 'Top50 position (#%)'").count

    @n_relizes = *(1..n)
    @n_places = *(1..50)
  end

  def page2
    @reliz = params[:reliz]
    @position = params[:position]
    if_csv = params[:if_csv]

    is_in = false
    file_name = "public/cert_create/records/rev"

    if(Integer(@reliz) < 10)
    	file_name += "0"
    end
    file_name += @reliz + "_"

    if(Integer(@position) < 10)
    	file_name += "0"
    end
    file_name += @position + ".csv"

    if(File.exists?(file_name))
      handle = CSV.read(file_name)
      record = handle[0]

      is_in = true

      @machine_name = record[0]
      @firm_proc = record[1]
      @proc_name = record[2]
      @firm_acc = record[3]
      @acc_name = record[4]
      @network_name = record[5]
      @uni = record[6]
      @division = record[7]
      @testpeak = record[9]
      @reliz_name = record[11]
      @reliz_type = record[12]
      @year = record[13]
    end

    if(if_csv == nil or is_in == false)

      reliz_id = Top50Benchmark.where("top50_benchmarks.name_eng LIKE 'Top50 position (##{@reliz})'").pluck(:id).first
      id = Top50BenchmarkResult.where(benchmark_id: reliz_id, result: @position).pluck(:machine_id).first
      @machine_name = Top50Machine.find(id).name

      testpeak_id = Top50Benchmark.where(name_eng: 'Linpack').pluck(:id).first
      @testpeak = Top50BenchmarkResult.where(benchmark_id: testpeak_id, machine_id: id).pluck(:result).first

      com_attr_id = Top50Attribute.where(name_eng: 'Communication network').pluck(:id).first
      comm_id = Top50AttributeValDict.where(attr_id: com_attr_id, obj_id: id).pluck(:dict_elem_id).first
      @network_name = Top50DictionaryElem.find(comm_id).name

      division_id = Top50Machine.where(id: id).pluck(:org_id).first
      @division = Top50Organization.find(division_id).name

      uni_id_result = Top50Relation.where(sec_obj_id: division_id).pluck(:prim_obj_id)
      if(uni_id_result.blank?)
        @uni = @division
        @division = ""
      else
        uni_id = uni_id_result.first
        @uni = Top50Organization.find(uni_id).name
      end

      nodes = Top50Relation.where(prim_obj_id: id).pluck(:sec_obj_id)

      @proc_name = []
      @acc_name = []
      @firm_proc = ""
      @firm_acc = ""

      cpu_type_id = Top50ObjectType.where(name_eng: 'CPU').pluck(:id).first
      gpu_type_id = Top50ObjectType.where(name_eng: 'GPU').pluck(:id).first
      coprocessor_type_id = Top50ObjectType.where(name_eng: 'Coprocessor').pluck(:id).first

      freq_id = Top50Attribute.where(name_eng: 'Clock frequency (MHz)').pluck(:id).first
      cpu_model_id = Top50Attribute.where(name_eng: 'CPU model').pluck(:id).first
      cpu_vendor_id = Top50Attribute.where(name_eng: 'CPU Vendor').pluck(:id).first
      gpu_model_id = Top50Attribute.where(name_eng: 'GPU model').pluck(:id).first
      gpu_vendor_id = Top50Attribute.where(name_eng: 'GPU Vendor').pluck(:id).first
      acc_model_id = Top50Attribute.where(name_eng: 'Coprocessor model').pluck(:id).first
      acc_vendor_id = Top50Attribute.where(name_eng: 'Coprocessor Vendor').pluck(:id).first

      for i in 0..nodes.count
        procs = Top50Relation.where(prim_obj_id: nodes[i]).pluck(:sec_obj_id)

        for j in 0..procs.count
          type = Top50Object.where(id: procs[j]).pluck(:type_id).first

          if(type == cpu_type_id)
            freq = Top50AttributeValDbval.where(attr_id: freq_id, obj_id: procs[j]).pluck(:value).first.to_f/1000
            proc_id = Top50AttributeValDict.where(attr_id: cpu_model_id, obj_id: procs[j]).pluck(:dict_elem_id).first
            procc = Top50DictionaryElem.find(proc_id).name

            unless @proc_name.include? procc
              @proc_name << procc + " " + freq.to_s + " ГГц"
            end

            if(@firm_proc == "")
              firm_proc_id = Top50AttributeValDict.where(attr_id: cpu_vendor_id, obj_id: procs[j]).pluck(:dict_elem_id).first
              @firm_proc = Top50DictionaryElem.find(firm_proc_id).name
            end
          end

          if(type == gpu_type_id)
            acc_id = Top50AttributeValDict.where(attr_id: gpu_model_id, obj_id: procs[j]).pluck(:dict_elem_id).first
            acc = Top50DictionaryElem.find(acc_id).name

            unless @acc_name.include? acc
              @acc_name << acc
            end

            if(@firm_acc == "")
              firm_acc_id = Top50AttributeValDict.where(attr_id: gpu_vendor_id, obj_id: procs[j]).pluck(:dict_elem_id).first
              @firm_acc = Top50DictionaryElem.find(firm_acc_id).name
            end
          end

          if(type == coprocessor_type_id)
            acc_id = Top50AttributeValDict.where(attr_id: acc_model_id, obj_id: procs[j]).pluck(:dict_elem_id).first
            acc = Top50DictionaryElem.find(acc_id).name

            unless @acc_name.include? acc
              @acc_name << acc
            end

            if(@firm_acc == "")
              firm_acc_id = Top50AttributeValDict.where(attr_id: acc_vendor_id, obj_id: procs[j]).pluck(:dict_elem_id).first
              @firm_acc = Top50DictionaryElem.find(firm_acc_id).name
            end
          end
        end
      end

      @proc_name = @proc_name.join("@")
      @acc_name = @acc_name.join("@")
    end
  end

  def scr
    machine_name = params[:machine_name]
    firm_proc = params[:firm_proc]
    proc_name = params[:proc_name]
    firm_acc = params[:firm_acc]
    acc_name = params[:acc_name]
    network_name = params[:network_name]
    uni = params[:uni]
    division = params[:division]
    position = params[:position]
    testpeak = params[:testpeak]
    reliz = params[:reliz]
    reliz_name = params[:reliz_name]
    reliz_type = params[:reliz_type]
    year = params[:year]

    system "php", "public/cert_create/scr.php", machine_name, firm_proc, proc_name, firm_acc, acc_name, network_name, uni, division, position, testpeak, reliz, reliz_name, reliz_type, year

    if(reliz.to_i < 10)
      reliz = "0" + reliz
    end

    if(position.to_i < 10)
      position = "0" + position
    end
    
    send_file("public/cert_create/certificates/rev" + reliz + "_" + position + ".pdf", 
              filename: "rev" + reliz + "_" + position + ".pdf",
              type: "application/pdf")
  end

  private

  def require_cert_moder_rights
    unless current_user.may_manage_certs?
      flash[:error] = "Недостаточно полномочий для доступа к сертификатам"
      redirect_to :back
    end
  end
end
