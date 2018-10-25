class CertificatesController < ApplicationController
  skip_before_action :require_login, :verify_authenticity_token, only: [:page1, :page2, :scr]
  #before_action :is_admin

  def page1
    system "php public/cert_create/page1.php"
    n = File.open("public/cert_create/medium/step1", &:readline).to_i
    @n_relizes = *(1..n)
    @n_places = *(1..50)
  end

  def page2
    @reliz = params[:reliz]
    @position = params[:position]
    if_csv = params[:if_csv]
    if(if_csv == nil || if_csv == false)
      command = "php public/cert_create/page2.php " + @reliz + " " + @position + " 0"
    else
      command = "php public/cert_create/page2.php " + @reliz + " " + @position + " 1"
    end

    system command

    File.open("public/cert_create/medium/step2", "r") do |f|
      @machine_name = f.gets
      @firm_proc = f.gets
      @proc_name = f.gets
      @firm_acc = f.gets
      @acc_name = f.gets
      @network_name = f.gets
      @uni = f.gets
      @division = f.gets
      @testpeak = f.gets
      @reliz_name = f.gets
      @reliz_type = f.gets
      @year = f.gets
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

    system "php public/cert_create/scr.php '" + machine_name + "' '" + firm_proc + "' '" + proc_name + "' ' " + firm_acc + "' '" + acc_name + "' '" + network_name + "' '" + uni + "' '" + 
    division + "' '" + position + "' '" + testpeak + "' '" + reliz + "' '" + reliz_name + "' '" + reliz_type + "' '" + year + "'"

    if(reliz.to_i < 10)
      reliz = "0" + reliz
    elsif(position.to_i < 10)
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
