class ServicesController < ApplicationController

  @@parameters = Parameter.first  
  @@url = "http://hub.com"
  
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def index
    @compensations = Compensation.where("published IS NOT FALSE").order("cuid ASC")
    @services = Service.all.order("name ASC").page(params[:page]).per_page(17)
    @codecss = @namecss = @sales_areacss = @url_on_successcss = @url_on_errorcss = @url_on_session_expiredcss = @url_on_hold_successcss = @url_on_hold_errorcss = @url_on_hold_listenercss = @url_on_basket_already_paidcss = @compensation_idcss = @url_to_ipncss = "row-form"
    #params[:delayed_payment_radio_button_group_yes] = false
    #params[:delayed_payment_radio_button_group_no] = true
  end
  
  def create
    @compensations = Compensation.where("published IS NOT FALSE").order("cuid ASC")
    @services = Service.all.order("name ASC").page(params[:page]).per_page(17)
    @error_messages = []
    @success_messages = []
    @codecss = @namecss = @sales_areacss = @url_on_successcss = @url_on_errorcss = @url_on_session_expiredcss = @url_on_hold_successcss = @url_on_hold_errorcss = @url_on_hold_listenercss = @compensation_idcss = @url_on_basket_already_paidcss = @url_to_ipncss = "row-form"
    
    @code = params[:code].delete(" ")
    @name = params[:name].strip
    @sales_area = params[:sales_area].strip
    @url_on_success = params[:url_on_success].strip
    @url_to_ipn = params[:url_to_ipn].strip
    @url_on_error = params[:url_on_error].strip
    @url_on_session_expired = params[:url_on_session_expired].strip
    @url_on_hold_success = params[:url_on_hold_success].strip
    @url_on_hold_error = params[:url_on_hold_error].strip
    @url_on_hold_listener = params[:url_on_hold_listener].strip
    @url_on_basket_already_paid = params[:url_on_basket_already_paid].strip
    @compensation_id = params[:post][:compensation_id]
    @compensation = Compensation.find_by_id(@compensation_id)
    
    params[:delayed_payment_radio_button_group_yes] = ActiveRecord::ConnectionAdapters::Column.value_to_boolean(params[:delayed_payment_radio_button_group])
    params[:delayed_payment_radio_button_group_no] = !params[:delayed_payment_radio_button_group_yes]
    
    if Service.where("code ILIKE '#{@code}' OR name ILIKE '#{@name}'").blank?
      @fields = [[@code, "le code du e-commerce", "@codecss"], [@name, "le nom du e-commerce", "@namecss"], [@sales_area, "le domaine de vente du e-commerce", "@sales_areacss"], [@url_on_success, "l'url de retour en cas de succès de la transaction", "@url_on_successcss"], [@url_to_ipn, "l'url de l'écouteur en cas de succès de la transaction", "@url_to_ipncss"], [@url_on_error, "l'url de retour en cas d'échec de la transaction", "@url_on_errorcss"], [@url_on_session_expired, "l'url de retour en cas d'expiration de la session", "@url_on_session_expiredcss"], [@url_on_basket_already_paid, "l'url de retour lorsque le panier a déjà été payé", "@url_on_basket_already_paidcss"], [@compensation_id, "le mode de compensation", "@compensation_idcss"]]
      unless @url_on_hold_success.blank? and @url_on_hold_error.blank? and @url_on_hold_listener.blank?
        @delayed_fields = [[@url_on_hold_success, "l'url de retour en cas de succès de création de paiement différé", "@url_on_hold_successcss"], [@url_on_hold_error, "l'url de retour en cas d'échec de création de paiement différé", "@url_on_hold_errorcss"], [@url_on_hold_listener, "l'url de retour en cas de notification de succès de paiement différé", "@url_on_hold_listenercss"]]
        @fields = @fields + @delayed_fields
      end
      
      @fields.each do |field|
        if field[0].blank?
          @error_messages << "Veuillez entrer #{field[1]}."
          my_container = field[2]
          instance_variable_set("#{my_container}", "row-form error")
          @error = true
        end
        if field[1][0..4] == "l'url"
          if !valid_url?(field[0])
            field[1][0..0] = "L"
            @error_messages << "#{field[1]} n'est pas valide."
            my_container = field[2]
            instance_variable_set("#{my_container}", "row-form error")
            @error = true
          end
        end
      end
      
      unless @error   
        # communication with back office
        @request = Typhoeus::Request.new("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_SERVICE/CreateService/#{@name}/#{@compensation.cuid}/#{@code}", followlocation: true)        
        @internal_com_request = "@response = Nokogiri.XML(request.response.body)
        @response.xpath('//status').each do |link|
        @status = link.content
        end
        "        
        run_typhoeus_request(@request, @internal_com_request)
        
        if @status.to_s.strip == "1"     
          @request = Typhoeus::Request.new("#{@@parameters.back_office_url}/service/create", method: :get, params: { code: @code, name: @name, sales_area: @sales_area, comment: @comment, url_on_success: @url_on_success, url_to_ipn: @url_to_ipn, url_on_error: @url_on_error, url_on_session_expired: @url_on_session_expired, url_on_hold_success: @url_on_hold_success, url_on_hold_error: @url_on_hold_error, url_on_hold_listener: @url_on_hold_listener, url_on_basket_already_paid: @url_on_basket_already_paid, authentication_token: @@parameters.emission_authentication_token  }, followlocation: true)
          
          @internal_com_request = "@response = request.response.body"     
          run_typhoeus_request(@request, @internal_com_request)  
          
          if @response == @@parameters.reception_authentication_token
            @service = Service.create(code: @code, name: @name, sales_area: @sales_area, comment: @comment, url_on_success: @url_on_success, url_to_ipn: @url_to_ipn, url_on_error: @url_on_error, url_on_session_expired: @url_on_session_expired, url_on_hold_success: @url_on_hold_success, url_on_hold_error: @url_on_hold_error, url_on_hold_listener: @url_on_hold_listener, notified_to_hubs_front_office: true, url_on_basket_already_paid: @url_on_basket_already_paid, compensation_id: @compensation.id)
            
            params[:code] = params[:name] = params[:sales_area] = params[:url_on_success] = params[:url_to_ipn] = params[:url_on_error] = params[:url_on_session_expired] = params[:url_on_basket_already_paid] = params[:url_on_hold_success] = params[:url_on_hold_error] = params[:url_on_hold_listener] = nil
            params[:delayed_payment_radio_button_group_yes] = false
            params[:delayed_payment_radio_button_group_no] = true
            @success_messages << "Le service a bien été créé."
          else
            @error_messages << "Impossible de joindre le front office."
          end 
        else
          @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, le service n'a pas pu être créé." : false    
        end 
      end
    else
      @error_messages << "Le code ainsi que le nom du service doivent être uniques."
    end
    
    render action: 'index'
  end
  
  def edit
    @codecss = @namecss = @sales_areacss = @url_on_successcss = @url_to_ipncss = @url_on_errorcss = @url_on_session_expiredcss = @url_on_hold_successcss = @url_on_hold_errorcss = @url_on_hold_listenercss = @url_on_basket_already_paidcss = @compensation_idcss = "row-form"
    @compensations = Compensation.where("published IS NOT FALSE").order("cuid ASC")
    @service = Service.find_by_id(params[:id])
    if @service.blank?
      redirect_to services_path
    else
      @operations_types = @service.operation_types
      if @service.url_on_hold_success.blank? and @service.url_on_hold_error.blank? and @service.url_on_hold_listener.blank?
        params[:delayed_payment_radio_button_group_yes] = false
        params[:delayed_payment_radio_button_group_no] = true
      else
        params[:delayed_payment_radio_button_group_yes] = true
        params[:delayed_payment_radio_button_group_no] = false
      end
    end
  end
  
  def update
    @error_messages = []
    @success_messages = []
    @codecss = @namecss = @sales_areacss = @url_on_successcss = @url_to_ipncss = @url_on_errorcss = @url_on_session_expiredcss = @url_on_hold_successcss = @url_on_hold_errorcss = @url_on_hold_listenercss = @url_on_basket_already_paidcss = @compensation_idcss = "row-form"
        
    @code = params[:code].delete(" ")
    @name = params[:name].strip
    @sales_area = params[:sales_area].strip
    @url_on_success = params[:url_on_success].strip
    @url_to_ipn = params[:url_to_ipn].strip
    @url_on_error = params[:url_on_error].strip
    @url_on_session_expired = params[:url_on_session_expired].strip
    @url_on_hold_success = params[:url_on_hold_success].strip
    @url_on_hold_error = params[:url_on_hold_error].strip
    @url_on_hold_listener = params[:url_on_hold_listener].strip
    @url_on_basket_already_paid = params[:url_on_basket_already_paid].strip
    
    @service = Service.find_by_id(params[:id])
    @compensations = Compensation.where("published IS NOT FALSE").order("cuid ASC")
    @compensation_id = params[:post][:compensation_id]  
    @compensation = Compensation.find_by_id(@compensation_id) 
    @operations_types = @service.operation_types
    if @service.url_on_hold_success.blank? and @service.url_on_hold_error.blank? and @service.url_on_hold_listener.blank?
      params[:delayed_payment_radio_button_group_yes] = false
      params[:delayed_payment_radio_button_group_no] = true
    else
      params[:delayed_payment_radio_button_group_yes] = true
      params[:delayed_payment_radio_button_group_no] = false
    end
    
    if Service.where("(code ILIKE '#{@code}' OR name ILIKE '#{@name}') AND id != #{@service.id}").blank?
      @fields = [[@code, "le code du e-commerce", "@codecss"], [@name, "le nom du e-commerce", "@namecss"], [@sales_area, "le domaine de vente du e-commerce", "@sales_areacss"], [@url_on_success, "l'url de retour en cas de succès de la transaction", "@url_on_successcss"], [@url_to_ipn, "l'url de l'écouteur en cas de succès de la transaction", "@url_to_ipncss"], [@url_on_error, "l'url de retour en cas d'échec de la transaction", "@url_on_errorcss"], [@url_on_session_expired, "l'url de retour en cas d'expiration de la session", "@url_on_session_expiredcss"], [@url_on_basket_already_paid, "l'url de retour lorsque le panier a déjà été payé", "@url_on_basket_already_paidcss"], [@compensation_id, "le mode de compensation", "@compensation_idcss"]]
      unless @url_on_hold_success.blank? and @url_on_hold_error.blank? and @url_on_hold_listener.blank?
        @delayed_fields = [[@url_on_hold_success, "l'url de retour en cas de succès de création de paiement différé", "@url_on_hold_successcss"], [@url_on_hold_error, "l'url de retour en cas d'échec de création de paiement différé", "@url_on_hold_errorcss"], [@url_on_hold_listener, "l'url de retour en cas de notification de succès de paiement différé", "@url_on_hold_listenercss"]]
        @fields = @fields + @delayed_fields
      end
      
      @fields.each do |field|
        if field[0].blank?
          @error_messages << "Veuillez entrer #{field[1]}."
          my_container = field[2]
          instance_variable_set("#{my_container}", "row-form error")
          @error = true
        end
        if field[1][0..4] == "l'url"
          if !valid_url?(field[0])
            field[1][0..0] = "L"
            @error_messages << "#{field[1]} n'est pas valide."
            my_container = field[2]
            instance_variable_set("#{my_container}", "row-form error")
            @error = true
          end
        end
      end
      
      unless @error  
        # communication with back office
        @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_SERVICE/EditService/#{@service.id}/#{@code}/#{@name}/#{@compensation.cuid}"), followlocation: true)        
        @internal_com_request = "@response = Nokogiri.XML(request.response.body)
        @response.xpath('//status').each do |link|
        @status = link.content
        end
        "        
        run_typhoeus_request(@request, @internal_com_request)
        
        if @status.to_s.strip == "1"  
          #{@@parameters.back_office_url}     
          @request = Typhoeus::Request.new("#{@@parameters.back_office_url}/service/update", method: :get, params: { service_id: params[:id], code: @code, name: @name, sales_area: @sales_area, url_on_success: @url_on_success, url_to_ipn: @url_to_ipn, url_on_error: @url_on_error, url_on_session_expired: @url_on_session_expired, url_on_hold_success: @url_on_hold_success, url_on_hold_error: @url_on_hold_error, url_on_basket_already_paid: @url_on_basket_already_paid, url_on_hold_listener: @url_on_hold_listener, authentication_token: @@parameters.emission_authentication_token  }, followlocation: true)
          
          @internal_com_request = "@response = request.response.body"     
          run_typhoeus_request(@request, @internal_com_request)  
          
          if @response == @@parameters.reception_authentication_token
            @service.update_columns(code: @code, name: @name, sales_area: @sales_area, url_on_success: @url_on_success, url_on_error: @url_on_error, url_on_session_expired: @url_on_session_expired, url_on_hold_success: @url_on_hold_success, url_to_ipn: @url_to_ipn, url_on_hold_error: @url_on_hold_error, url_on_basket_already_paid: @url_on_basket_already_paid, url_on_hold_listener: @url_on_hold_listener, compensation_id: @compensation.id)
            
            @success_messages << "Le service a été mis à jour."
          else
            @error_messages << "Impossible de joindre le front office."
          end  
        else
          @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, le service n'a pas pu être mis à jour." : false    
        end   
      end
    else
      @error_messages << "Le code ainsi que le nom du service doivent être uniques."
    end
    
    render action: 'edit'
  end
  
  def enable_service
	  enable_disable(params[:format], true, "activé", "#{@@url}/service/enable", "ActivatedService")
	end
	
	def disable_service
	  enable_disable(params[:format], false, "désactivé", "#{@@url}/service/disable", "DesActivatedService")
	end
	
	def enable_disable(id, bool, status, url, url_parameter_to_back_office)
	  @service = Service.find_by_id(id)
	  @error_messages = ""
	  if !@service.blank?
	    @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_SERVICE/#{url_parameter_to_back_office}/#{id}"), followlocation: true)        
      @internal_com_request = "@response = Nokogiri.XML(request.response.body)
      @response.xpath('//status').each do |link|
      @status = link.content
      end
      "        
      run_typhoeus_request(@request, @internal_com_request)
      
      if @status.to_s.strip == "1"
	      @request = Typhoeus::Request.new("#{url}", method: :get, params: { service_id: @service.id,  authentication_token: @@parameters.emission_authentication_token }, followlocation: true)
            
        @internal_com_request = "@response = request.response.body"     
        run_typhoeus_request(@request, @internal_com_request)  
        
        if @response == @@parameters.reception_authentication_token
          @service.update_attributes(published: bool)
        else
          @error_messages << "Impossible de joindre le front office."
        end
      else
        @error_messages.blank? ? @error_messages << "Veuillez contacter l'administrateur, le service n'a pas pu être mis à jour." : false    
      end 
    else
      @error_messages << "Ce service n'existe pas."
    end
    
	  redirect_to :back, :notice => "Le service [ #{@service.name} ] a été #{status}."
	end
  
end
