class BanksController < ApplicationController
  @@parameters = Parameter.first  
  @@url = "http://hub.com"
  
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def index
    @bank_types = BankType.where("published IS NOT FALSE").order("name ASC")
    @banks = Bank.all.order("name ASC").page(params[:page]).per_page(17)
    @namecss = @type_idcss = "row-form"
  end
  
  def create
    @error_messages = []
    @success_messages = []
    @namecss = @type_idcss = "row-form"
    @name = params[:name]
    @type_id = params[:post][:bank_type_id]
    @bank_types = BankType.where("published IS NOT FALSE").order("name ASC")
    @banks = Bank.all.order("name ASC").page(params[:page]).per_page(17)
    
    if Bank.find(:all, :conditions => ["lower_unaccent(name) LIKE ?", "#{@name.downcase}"]).blank?
      @fields = [[@name, "le nom de l'ayant droit", "@namecss"], [@type_id, "le type de l'ayant droit", "@type_idcss"]]
      
      @fields.each do |field|
        if field[0].blank?
          @error_messages << "Veuillez entrer #{field[1]}."
          my_container = field[2]
          instance_variable_set("#{my_container}", "row-form error")
          @error = true
        end
      end
      
      unless @error 
        # communication with back office
        @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_BANQUE/CreateBanque/#{@name}/#{@type_id}"), followlocation: true)        
        @internal_com_request = "@response = Nokogiri.XML(request.response.body)
        @response.xpath('//status').each do |link|
        @status = link.content
        end
        "        
        run_typhoeus_request(@request, @internal_com_request)
        
        if @status.to_s.strip == "1" 
          Bank.create(name: @name, bank_type_id: @type_id)
          params[:name] = nil
          @success_messages << "La banque #{@name} a été créé."
        else
          @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, la banque n'a pas pu être créée." : false    
        end 
      end
    else
      @error_messages << "Le nom de la banque doit être unique."
    end
    
    render :action => "index"
  end
  
  def edit
    @type_idcss = @namecss = "row-form"
    @bank = Bank.find_by_id(params[:id])
    @banks = Bank.all.order("name ASC").page(params[:page]).per_page(17)
    @bank_types = BankType.where("published IS NOT FALSE").order("name ASC") 
    if @bank.blank?
      redirect_to banks_path
    end  
  end
  
  def update
    @error_messages = []
    @success_messages = []
    @type_idcss = @namecss = "row-form"
    @type_id = params[:post][:bank_type_id]
    @name = params[:name]
    @bank = Bank.find_by_id(params[:id])
    @banks = Bank.all.order("name ASC").page(params[:page]).per_page(17)
    @bank_types = BankType.where("published IS NOT FALSE").order("name ASC")  
    @fields = [[@type_id, "le type de l'ayant droit", "@type_idcss"], [@name, "le nom de la banque", "@namecss"]]
    
    @fields.each do |field|
      if field[0].blank?
        @error_messages << "Veuillez entrer #{field[1]}."
        my_container = field[2]
        instance_variable_set("#{my_container}", "row-form error")
        @error = true
      end
    end
    
    unless @error 
      # communication with back office
      @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_BANQUE/EditBanque/#{@bank.id}/#{@bank.name}"), followlocation: true)        
      @internal_com_request = "@response = Nokogiri.XML(request.response.body)
      @response.xpath('//status').each do |link|
      @status = link.content
      end
      "        
      run_typhoeus_request(@request, @internal_com_request)
      
      if @status.to_s.strip == "1" 
        @bank.update_columns(bank_type_id: @type_id, name: @name)      
        @success_messages << "Le profil de la banque #{@bank.name} a été modifié."
      else
        @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, la banque n'a pas pu être modifiée." : false    
      end 
    end   
    
    render :action => "edit" 
  end
  
  def enable_bank
	  enable_disable_bank(params[:id], true, "activée", "ActivatedBanque")
	end
	
	def disable_bank
	  enable_disable_bank(params[:id], false, "désactivée", "DesActivatedBanque")
	end
	
	def enable_disable_bank(id, bool, status, custom_link)
	  @message = ""
	  @bank = Bank.find_by_id(params[:id])
	  
	  @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_BANQUE/#{custom_link}/#{@bank.id}"), followlocation: true)        
    @internal_com_request = "@response = Nokogiri.XML(request.response.body)
    @response.xpath('//status').each do |link|
    @status = link.content
    end
    "        
    run_typhoeus_request(@request, @internal_com_request)
    
    if @status.to_s.strip == "1" 
      @bank.update_columns(published: bool)      
      @message = "La banque #{@bank.name} a été #{status}."
    else
      @message = "Veuillez contacter l'administrateur, une erreur s'est produite"
    end 
	  
	  redirect_to :back, :notice => @message
	end
  
end
