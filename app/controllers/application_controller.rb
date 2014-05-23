class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  #helper_method :dummy
  #prepend_before_filter :authenticate_user!, :cache_buster
  
  private
      
    def sign_out_disabled_users
      if current_user.published.eql?(false)
        #redirect_path = after_sign_out_path_for(current_user)
        sign_out(current_user)
        #signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
        #set_flash_message :notice => , :signed_out if signed_out && is_navigational_format?
        flash[:notice] = "Votre compte a été désactivé. Veuillez contacter l'administrateur."
        redirect_to new_user_session_path
        # We actually need to hardcode this as Rails default responder doesn't
        # support returning empty response on GET request
        #respond_to do |format|
        #  format.all { head :no_content }
        #  format.any(*navigational_formats) { redirect_to redirect_path }
        #end
      end
    end
		# Overwriting the sign_out redirect path method
		def after_sign_out_path_for(resource_or_scope)
			new_user_session_path
		end
		
		def after_sign_in_path_for(resource_or_scope)
			@short_profile = current_user.short_profile
			if @short_profile == "ADMIN" or @short_profile == "AUD-C" or @short_profile == "AUD"
			  if @short_profile == "ADMIN"
			    profiles_path	
			  else
			    if @short_profile == "AUD-C"
			      administrator_dashboard_path	
			    else
			      if @short_profile == "AUD"
			        transactions_path	
			      end	
			    end
			  end	
			    
			else
			  if @short_profile != "ADMIN" and @short_profile != "AUD-C" and @short_profile != "AUD" and !@short_profile.blank?
			    custom_profiles_dashboard_path
			  else
			    new_user_session_path
			  end
			end		
		end
		
		def not_a_number?(n)
    	n.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? true : false 
	  end
	  
	  def valid_email?(str)
	    str.to_s.match(/^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i) == nil ? false : true
	  end
	  
	  def valid_url?(str)
	    str.to_s.match(/^((http:\/\/|https:\/\/)?(www.)?(([a-zA-Z0-9-]){2,}\.){1,4}([a-zA-Z]){2,6}(\/([a-zA-Z_\/\.0-9#:?=&;,]*)?)?)$/i) == nil ? false : true
	  end
	  
	  def capitalization(raw_string)
    	@string_capitalized = ''
    	raw_string.split.each do |name|
    		@string_capitalized << "#{name.capitalize} "
    	end
    	@string_capitalized.strip
    end
    
# Vider le cache des navigateurs	
	  def cache_buster
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
    
    def layout_used
      @layout = "" 
    	if current_user.blank?
    	  @layout = "sessions"
    	else
			  @short_profile = current_user.short_profile
			  case @short_profile
		      when "ADMIN"
			      @layout = "administrator"
		      when "AUD-C"
			      @layout = "auditor_controller"
		      when "AUD"
			      @layout = "auditor"			    
			    else
			      @layout = "sessions"
		      end		    
		  end
		  if @short_profile != "ADMIN" and @short_profile != "AUD-C" and @short_profile != "AUD" and !@short_profile.blank? 
		    @layout = "custom_profiles"
		  end
		  @layout			
    end 
    
    def run_typhoeus_request(request, code_on_success)
      request.on_complete do |response|
        if response.success?
          eval(code_on_success)         
        elsif response.timed_out?
          @error_messages << "Délai d'attente de la demande dépassé. Veuillez contacter l'administrateur."
          @error = true
        elsif response.code == 0
          @error_messages << "L'URL demandé n'existe pas. Veuillez contacter l'administrateur."
          @error = true
        else
          @error_messages << "Une erreur s'est produite. Veuillez contacter l'administrateur"
          @error = true
        end      
      end      
      hydra = Typhoeus::Hydra.hydra
	    hydra.queue(request)
	    hydra.run	
    end
	  
end
