class TransactionsController < ApplicationController

  @@parameters = Parameter.first  
  @@url = "http://hub.com"
  
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def index
    @services = Service.all.order("name ASC").page(params[:page]).per_page(17)
  end
  
  def list_per_service
    @service = Service.find_by_id(params[:id])
    if @service.blank?
      redirect_to transactions_path
    else
      # communication with back office
      @request = Typhoeus::Request.new(URI.escape("#{@@parameters.hubs_back_office_url}/GATEWAY/rest/BACKOFFICE_OPERATION/Win/#{@service.id}"), followlocation: true)        
      @internal_com_request = "@response = request.response.body"        
      run_typhoeus_request(@request, @internal_com_request)
      if !@response.blank?
        if @response.match(/\[/).blank?
          @operations = JSON.parse(@response.sub(/\:/, ":[").sub(/\}\}/, "}]}"))
          unless @operations.blank?
            @operations = Kaminari.paginate_array(@operations["operation"]).page(params[:page]).per(17)
          end
        else
          @operations = JSON.parse(@response)
          unless @operations.blank?
            @operations = Kaminari.paginate_array(@operations["operation"]).page(params[:page]).per(17)
          end
        end
      end
    end
  end
  
end
