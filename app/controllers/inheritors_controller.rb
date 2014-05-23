class InheritorsController < ApplicationController

  @@parameters = Parameter.first  
  @@url = "http://hub.com"
  
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used

  def index
    @inheritors_types = InheritorType.where("published IS NOT FALSE").order("label ASC")
    @inheritors = Inheritor.all.order("name ASC").page(params[:page]).per_page(17)
    @namecss = @phone_numbercss = @emailcss = @addresscss = @account_numbercss = @type_idcss = "row-form"
  end
  
  def create
    @error_messages = []
    @success_messages = []
    @namecss = @phone_numbercss = @emailcss = @addresscss = @account_numbercss = @type_idcss = "row-form"
    @name = params[:name]
    @phone_number = params[:phone_number]
    @email = params[:email]
    @address = params[:address]
    @account_number = params[:account_number].delete(" ")
    @type_id = params[:post][:inheritor_type_id]
    @inheritors_types = InheritorType.where("published IS NOT FALSE").order("label ASC")
    @inheritors = Inheritor.all.order("name ASC").page(params[:page]).per_page(17)
    
    if Inheritor.find(:all, :conditions => ["lower_unaccent(name) LIKE ?", "#{@name.downcase}"]).blank?
      @fields = [[@name, "le nom de l'ayant droit", "@namecss"], [@account_number, "le numéro de compte de l'ayant droit", "@account_numbercss"], [@type_id, "le type de l'ayant droit", "@type_idcss"]]
      
      @fields.each do |field|
        if field[0].blank?
          @error_messages << "Veuillez entrer #{field[1]}."
          my_container = field[2]
          instance_variable_set("#{my_container}", "row-form error")
          @error = true
        end
      end
      
      if !@phone_number.blank?
        if not_a_number?(@phone_number)
          @error_messages << "Le numéro de téléphone doit être numérique"
          @error = true
        end
      end
      
      if !@email.blank?
        if !valid_email?(@email)
          @error_messages << "L'email n'est pas valide"
          @error = true
        end
      end
      
      @phone_number.blank? ? @phone_number = "0" : false
      @email.blank? ? @email = "0" : false
      @address.blank? ? @address = "0" : false
      
      unless @error 
        # communication with back office
        @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_AYANT_DROIT/CreateAYANT_DROIT/#{@name}/#{@name}/#{@phone_number}/#{@email}/#{@address}/#{@account_number}/#{@type_id}"), followlocation: true)        
        @internal_com_request = "@response = Nokogiri.XML(request.response.body)        
        @response.xpath('//status').each do |link|
        @status = link.content
        end
        "        
        run_typhoeus_request(@request, @internal_com_request)
        
        if @status.to_s.strip == "1" 
          Inheritor.create(name: @name, phone_number: @phone_number, email: @email, address: @address, account_number: @account_number, inheritor_type_id: @type_id)
          params[:name] = params[:phone_number] = params[:email] = params[:address] = params[:account_number] = nil
          @success_messages << "L'ayant droit #{@name} a été créé."
        else
          @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, l'ayant droit n'a pas pu être créé." : false    
        end 
      end
    else
      @error_messages << "Le nom de l'ayant droit doit être unique."
    end
    
    render :action => "index"
  end  
  
  def link_to_operation
    @inheritor = Inheritor.find_by_id(params[:id])
    @associated_services = []
    if @inheritor.blank?
      redirect_to inheritors_path
    else 
      @operation_types = @inheritor.operation_types
      @services = Service.where("published IS NOT FALSE").order("name ASC").page(params[:page]).per_page(17)
      @serviceidcss = @operationcss = @percentagecss = "row-form"
      unless @operation_types.blank?
        @operation_types.each do |operation_type|
          @service = operation_type.service
          @associated_services << @service unless @associated_services.include?(@service)
        end
      end 
    end  
  end
  
  def create_link_to_operation
    @error_messages = []
    @success_messages = []
    @inheritor = Inheritor.find_by_id(params[:id])   
    @operation_name = params[:operation]
    @serviceidcss = @operationcss = @percentagecss = "row-form"
    @services = Service.where("published IS NOT FALSE").order("name ASC").page(params[:page]).per_page(17)
      
    @service_id = params[:post][:service_id]
    @percentage = params[:percentage]
    @fields = [[@service_id, "le service", "@serviceidcss"], [@percentage, "le pourcentage sur l'opération", "@percentagecss"]]
    @fields.each do |field|
      if field[0].blank?
        @error_messages << "Veuillez entrer #{field[1]}."
        my_container = field[2]
        instance_variable_set("#{my_container}", "row-form error")
        @error = true
      end
    end
    
    if @operation_name == "-Veuillez choisir une opération-"
      @error = true
      @operationcss = "row-form error"
      @error_messages << "Veuillez entrer le nom de l'opération"
    end
    
    if not_a_number?(@percentage)
      @error = true
      @percentagecss = "row-form error"
      @error_messages << "Le pourcentrage doit être numérique"
    end
    
    unless @error 
      @existing_operation = @inheritor.operation_types.where("name = '#{@operation_name}'")
      @operation_type_id = OperationType.find_by_name(@operation_name).id
      if @existing_operation.blank?
        @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_AYANT_DROIT_TYOP/CreateAYANT_DROIT/#{@operation_type_id}/#{@inheritor.id}/#{@percentage}"), followlocation: true)        
        @internal_com_request = "@response = Nokogiri.XML(request.response.body)
        @response.xpath('//status').each do |link|
        @status = link.content
        end
        "        
        run_typhoeus_request(@request, @internal_com_request)
        
        if @status.to_s.strip == "1"   
          ActiveRecord::Base.connection.execute("INSERT INTO inheritors_operation_types VALUES(#{@inheritor.id}, #{@operation_type_id}, #{@percentage})")
          @success_messages << "L'ayant droit #{@inheritor.name} a été associé à l'opération #{@operation_name} avec le pourcentage: #{@percentage}%."
        else
          @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, l'ayant droit n'a pas pu être lié à l'opération." : false    
        end 
      else
        @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_AYANT_DROIT_TYOP/CreateAYANT_DROIT/{idayDroitHasTypeOperation}/{ayDroitHasTypeOperationcPourcentage}"), followlocation: true)        
        @internal_com_request = "@response = Nokogiri.XML(request.response.body)
        @response.xpath('//status').each do |link|
        @status = link.content
        end
        "        
        run_typhoeus_request(@request, @internal_com_request)
        
        if @status.to_s.strip == "1"
          ActiveRecord::Base.connection.execute("UPDATE inheritors_operation_types SET percentage = #{@percentage} WHERE inheritor_id = #{@inheritor.id} AND operation_type_id = #{@operation_type_id}")
          @success_messages << "Le pourcentage de l'ayant droit #{@inheritor.name} est passé à #{@percentage}% pour l'opération: #{@operation_name}."
        else
          @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, le service n'a pas pu être créé." : false    
        end
      end
    end    
    
    @associated_services = []
    @operation_types = Inheritor.find_by_id(params[:id]).operation_types
    unless @operation_types.blank?
      @operation_types.each do |operation_type|
        @service = operation_type.service
        @associated_services << @service unless @associated_services.include?(@service)
      end
    end 
    
    render :action => "link_to_operation"
  end
  
  def edit
    @phone_numbercss = @emailcss = @addresscss = @account_numbercss = @type_idcss = "row-form"
    @inheritor = Inheritor.find_by_id(params[:id])
    @inheritors_types = InheritorType.where("published IS NOT FALSE").order("label ASC")
    @associated_services = []
    if @inheritor.blank?
      redirect_to inheritors_path
    else 
      @operation_types = @inheritor.operation_types
      unless @operation_types.blank?
        @operation_types.each do |operation_type|
          @service = operation_type.service
          @associated_services << @service unless @associated_services.include?(@service)
        end
      end
    end       
  end
  
  def update
    @error_messages = []
    @success_messages = []
    @phone_numbercss = @emailcss = @addresscss = @account_numbercss = @type_idcss = "row-form"
    @phone_number = params[:phone_number]
    @email = params[:email]
    @address = params[:address]
    @account_number = params[:account_number].delete(" ")
    @type_id = params[:post][:inheritor_type_id]
    @inheritors_types = InheritorType.where("published IS NOT FALSE").order("label ASC")
    @inheritor = Inheritor.find_by_id(params[:id])
    @associated_services = []
    @operation_types = @inheritor.operation_types
    unless @operation_types.blank?
      @operation_types.each do |operation_type|
        @service = operation_type.service
        @associated_services << @service unless @associated_services.include?(@service)
      end
    end 
    @fields = [[@account_number, "le numéro de compte de l'ayant droit", "@account_numbercss"], [@type_id, "le type de l'ayant droit", "@type_idcss"]]
      
    @fields.each do |field|
      if field[0].blank?
        @error_messages << "Veuillez entrer #{field[1]}."
        my_container = field[2]
        instance_variable_set("#{my_container}", "row-form error")
        @error = true
      end
    end
    
    if !@phone_number.blank?
      if not_a_number?(@phone_number)
        @error_messages << "Le numéro de téléphone doit être numérique"
        @error = true
      end
    end
    
    if !@email.blank?
      if !valid_email?(@email)
        @error_messages << "L'email n'est pas valide"
        @error = true
      end
    end
    
    @phone_number.blank? ? @phone_number = "0" : false
    @email.blank? ? @email = "0" : false
    @address.blank? ? @address = "0" : false
    
    unless @error 
      # communication with back office
      @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_AYANT_DROIT/EditAYANT_DROIT/#{params[:id]}/#{@inheritor.name}/#{@inheritor.name}/#{@phone_number}/#{@email}/#{@address}/#{@account_number}/#{@type_id}"), followlocation: true)       
      @internal_com_request = "@response = Nokogiri.XML(request.response.body)
      @response.xpath('//status').each do |link|
      @status = link.content
      end
      "        
      run_typhoeus_request(@request, @internal_com_request)
      
      if @status.to_s.strip == "1"
        @phone_number.eql?("0") ? @phone_number = nil : false
        @email.eql?("0") ? @email = nil : false
        @address.eql?("0") ? @address = nil : false
        
        @inheritor.update_columns(phone_number: @phone_number, email: @email, address: @address, account_number: @account_number, inheritor_type_id: @type_id)      
        @success_messages << "Le profil de l'ayant droit #{@inheritor.name} a été modifié."
      else
        @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, l'ayant droit n'a pas pu être mis à jour." : false    
      end 
    end    

    render :action => "edit" 
  end
  
end
