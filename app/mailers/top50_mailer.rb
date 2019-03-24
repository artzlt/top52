class Top50Mailer < ActionMailer::Base
  default from: "no-reply@top50.parallel.ru"

  def fetch_all_data_from_params(params)
    core_qty_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Number of cores"))
    @core_qty_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(core_qty_attrs)
    microcore_qty_attrs = Top50AttributeDbval.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "Number of micro cores"))
    @microcore_qty_attr_vals = Top50AttributeValDbval.all.joins(:top50_attribute_dbval).merge(microcore_qty_attrs)
    cpu_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "CPU model"))
    @cpu_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(cpu_model_attrs)
    cpu_vendor_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where(name_eng: "CPU Vendor"))
    @cpu_vendor_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(cpu_vendor_attrs)
    comp_model_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where("name_eng LIKE '% model'"))
    @comp_model_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(comp_model_attrs)
    comp_vendor_attrs = Top50AttributeDict.all.joins(:top50_attribute).merge(Top50Attribute.where("name_eng LIKE '% Vendor'"))
    @comp_vendor_attr_vals = Top50AttributeValDict.all.joins(:top50_attribute_dict).merge(comp_vendor_attrs)

    @step1_data = params[:step1_data]
    @step2_data = params[:step2_data]
    @step3_data = params[:step3_data]
    @step4_data = params[:step4_data]
    @app_id = params[:id]
  end

  helper_method :ext_url

  def ext_url(s)
    if s.downcase.start_with? "http"
      return s
    else
      return "http://" + s
    end
  end

  def app_confirm_email(params)
    fetch_all_data_from_params(params)
    @org_email = "top50@parallel.ru"
    mail(to: @step1_data[:contact][:email], subject: "Заявка на участие в рейтинге Top50", cc: @org_email)
  end

end
