class OperationTypesController < ApplicationController
  @@parameters = Parameter.first  
  @@url = "http://hub.com"
  
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def index
    @service_idcss = @operation_type_namecss = @type_css = @commentcss = "row-form"
    @services = Service.all.order("name ASC").page(params[:page]).per_page(17)
  end
  
  def create
    @error_messages = []
    @success_messages = []
    @service_id = params[:post][:service_id]
    @name = params[:operation_type_name].delete(" ")
    @comment = params[:comment]
    @credit_status = params[:type][:id]
    @service_idcss = @operation_type_namecss = @type_css = @commentcss = "row-form"
    
    @services = Service.all.order("name ASC").page(params[:page]).per_page(17)
    @service = Service.find_by_id(@service_id) 
    @fields = [[@service_id, "le service", "@service_idcss"], [@name, "le nom de l'opération", "@operation_type_namecss"], [@comment, "le slogan", "@commentcss"]]  
    @fields.each do |field|
      if field[0].blank?
        @error_messages << "Veuillez entrer #{field[1]}."
        my_container = field[2]
        instance_variable_set("#{my_container}", "row-form error")
        @error = true
      end
    end 
    
    unless @error
      if OperationType.where("name ILIKE '#{@name}' AND credit_status = #{@credit_status}").blank?
        # communication with back office
        @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_TYP_OPERATION/CreateTYP_OPERATION/#{@service_id}/#{@name}/#{@credit_status}/1"), followlocation: true)        
        @internal_com_request = "@response = Nokogiri.XML(request.response.body)
        @response.xpath('//status').each do |link|
        @status = link.content
        end
        "        
        run_typhoeus_request(@request, @internal_com_request)
        
        if @status.to_s.strip == "1" 
          @request = Typhoeus::Request.new(URI.escape("#{@@parameters.back_office_url}/operation/create"), method: :get, params: { service_id: @service_id, name: @name, comment: @comment, authentication_token: @@parameters.emission_authentication_token  }, followlocation: true)
            
          @internal_com_request = "@response = request.response.body"     
          run_typhoeus_request(@request, @internal_com_request)  
          
          if @response == @@parameters.reception_authentication_token
            @service.operation_types.create(name: @name, comment: @comment, credit_status: @credit_status)        
            params[:post][:service_id] = params[:operation_type_name] = params[:comment] = nil
            @success_messages << "L'opération: #{@name} a été ajoutée au service: #{@service.name}."
          end
        else
          @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, le type d'opération n'a pas pu être créé." : false    
        end 
      else
        @error_messages << "Ce type d'opération existe déjà."
      end
    end    

    render :action => "index"
  end
  
  def edit
    @operation_type_namecss = @type_css = @commentcss = "row-form"
    @services = Service.all.order("name ASC").page(params[:page]).per_page(17)
    @operation = OperationType.find_by_id(params[:id])
    if @operation.blank?
      redirect_to operation_types_path
    end 
  end
  
  def update
    @error_messages = []
    @success_messages = []
    @operation_type_namecss = @type_css = @commentcss = "row-form"
    @operation_id = params[:id]
    @name = params[:operation_type_name].delete(" ")
    @comment = params[:comment]
    @credit_status = params[:type][:id]
    @services = Service.all.order("name ASC").page(params[:page]).per_page(17)
    
    @operation = OperationType.find_by_id(@operation_id)
    @fields = [[@name, "le nom de l'opération", "@operation_type_namecss"], [@comment, "le slogan", "@commentcss"], [@credit_status, "type de transaction", "@typecss"]]  
    @fields.each do |field|
      if field[0].blank?
        @error_messages << "Veuillez entrer #{field[1]}."
        my_container = field[2]
        instance_variable_set("#{my_container}", "row-form error")
        @error = true
      end
    end 
    
    unless @error
      if OperationType.where("name ILIKE '#{@name}' AND credit_status = #{@credit_status}").blank?
        @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_TYP_OPERATION/EditTYP_OPERATION/#{@operation_id}/#{@operation.service.id}/#{@name}/#{@credit_status}/1"), followlocation: true)        
        @internal_com_request = "@response = Nokogiri.XML(request.response.body)
        @response.xpath('//status').each do |link|
        @status = link.content
        end
        "        
        run_typhoeus_request(@request, @internal_com_request)
        
        if @status.to_s.strip == "1" 
          @request = Typhoeus::Request.new(URI.escape("#{@@parameters.back_office_url}/operation/update"), method: :get, params: { operation_id: @operation_id, name: @name, comment: @comment, authentication_token: @@parameters.emission_authentication_token  }, followlocation: true)
            
          @internal_com_request = "@response = request.response.body"     
          run_typhoeus_request(@request, @internal_com_request)  
          
          if @response == @@parameters.reception_authentication_token
            @operation.update_columns(name: @name, comment: @comment, credit_status: @credit_status)        
            @success_messages << "L'opération: #{@operation.name} a été mise à jour."
          else
            @error_messages << "Une erreur s'est produite, veuillez contacter l'administrateur." 
          end
        else
          @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, le type d'opération n'a pas pu être mis à jour." : false    
        end 
      else
        @error_messages << "Ce type d'opération existe déjà."
      end
    end    
    
    render :action => "edit"
  end
  
  def enable
	  enable_disable(params[:format], true, "activé", "#{@@parameters.back_office_url}/operation/enable", "ActivatedTYP_OPERATION")
	end
	
	def disable
	  enable_disable(params[:format], false, "désactivé", "#{@@parameters.back_office_url}/operation/disable", "desActivatedTYP_OPERATION")
	end
	
	def enable_disable(id, bool, status, url, url_parameter_to_back_office)
	  @operation = OperationType.find_by_id(id)
	  @error_messages = ""
	  if !@operation.blank?
	    @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_TYP_OPERATION/#{url_parameter_to_back_office}/#{id}"), followlocation: true)        
      @internal_com_request = "@response = Nokogiri.XML(request.response.body)
      @response.xpath('//status').each do |link|
      @status = link.content
      end
      "        
      run_typhoeus_request(@request, @internal_com_request)
      
      if @status.to_s.strip == "1"
	      @request = Typhoeus::Request.new("#{url}", method: :get, params: { operation_id: id,  authentication_token: @@parameters.emission_authentication_token }, followlocation: true)
            
        @internal_com_request = "@response = request.response.body"     
        run_typhoeus_request(@request, @internal_com_request)  
        
        if @response == @@parameters.reception_authentication_token
          @operation.update_attributes(published: bool)
        else
          @error_messages << "Impossible de joindre le front office."
        end
      else
        @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, le type d'opération n'a pas pu être mis à jour." : false    
      end 
    else
      @error_messages << "Cette opération n'existe pas."
    end
    
	  redirect_to :back, :notice => "L'opération #{@operation.name} du service #{@operation.service.name} a été #{status}."
	end
	
	def get_operations_from_service
    @service_id = params.first.first
    @operations_options = "<option>-Veuillez choisir une opération-</option>"
    @operations = Service.find_by_id(@service_id).operation_types.where("published IS NOT FALSE")
    @operations.each do |operation|
      @operations_options << "<option>#{operation.name}</option>"
    end
    render :text => @operations_options
  end
  
end
