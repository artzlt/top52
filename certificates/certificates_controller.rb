class CertificatesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:page1, :page2, :scr]
  before_action :is_admin

  def page1
    n = Top50Benchmark.all.count - 1

    @n_relizes = *(1..n)
    @n_places = *(1..50)
  end

  def page2
    @reliz = params[:reliz]
    @position = params[:position]
    if_csv = params[:if_csv]

    files = Dir["public/cert_create/records/*"]

    is_in = false

    i = 0
    while(i < files.length)
      pieces = files[i].split("/")[-1].split("_")
      pos = pieces[1].split(".")[0].to_i
      rel = pieces[0][3, 2].to_i
      if(pos == @position.to_i and rel == @reliz.to_i)
        handle = CSV.read(files[i])
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

        break
      end

      i += 1
    end

    if(if_csv == nil or is_in == false)

      reliz_id = Top50Benchmark.where("top50_benchmarks.name_eng LIKE '%#{@reliz}%'").pluck(:id).first
      id = Top50BenchmarkResult.where(benchmark_id: reliz_id, result: @position).pluck(:machine_id).first
      @machine_name = Top50Machine.find(id).name

      @testpeak = Top50BenchmarkResult.where(benchmark_id: 27, machine_id: id).pluck(:result).first

      comm_id = Top50AttributeValDict.where(attr_id: 10, obj_id: id).pluck(:dict_elem_id).first
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

      for i in 0..nodes.count
        procs = Top50Relation.where(prim_obj_id: nodes[i]).pluck(:sec_obj_id)

        for j in 0..procs.count
          type = Top50Object.where(id: procs[j]).pluck(:type_id).first

          if(type == 6)
            freq = Top50AttributeValDbval.where(attr_id: 25, obj_id: procs[j]).pluck(:value).first.to_f/1000
            proc_id = Top50AttributeValDict.where(attr_id: 15, obj_id: procs[j]).pluck(:dict_elem_id).first
            procc = Top50DictionaryElem.find(proc_id).name

            unless @proc_name.include? procc
              @proc_name << procc + " " + freq.to_s + " ГГц"
            end

            if(@firm_proc == "")
              firm_proc_id = Top50AttributeValDict.where(attr_id: 20, obj_id: procs[j]).pluck(:dict_elem_id).first
              @firm_proc = Top50DictionaryElem.find(firm_proc_id).name
            end
          end

          if(type == 7)
            acc_id = Top50AttributeValDict.where(attr_id: 16, obj_id: procs[j]).pluck(:dict_elem_id).first
            acc = Top50DictionaryElem.find(acc_id).name

            unless @acc_name.include? acc
              @acc_name << acc
            end

            if(@firm_acc == "")
              firm_acc_id = Top50AttributeValDict.where(attr_id: 21, obj_id: procs[j]).pluck(:dict_elem_id).first
              @firm_acc = Top50DictionaryElem.find(firm_acc_id).name
            end
          end

          if(type == 8)
            acc_id = Top50AttributeValDict.where(attr_id: 22, obj_id: procs[j]).pluck(:dict_elem_id).first
            acc = Top50DictionaryElem.find(acc_id).name

            unless @acc_name.include? acc
              @acc_name << acc
            end

            if(@firm_acc == "")
              firm_acc_id = Top50AttributeValDict.where(attr_id: 23, obj_id: procs[j]).pluck(:dict_elem_id).first
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

  def is_admin
    unless User.superadmins.include? current_user
      redirect_to :back
    end
  end
end
