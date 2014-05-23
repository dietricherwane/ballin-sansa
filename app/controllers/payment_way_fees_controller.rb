class PaymentWayFeesController < ApplicationController
  @@parameters = Parameter.first  
  @@url = "http://hub.com"
  
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def index
    @namecss = @feecss = "row-form"
    @payment_ways = PaymentWayFee.all.order("name ASC").page(params[:page]).per_page(17)
  end  
  
  def create
    @namecss = @feecss = "row-form"
    @payment_ways = PaymentWayFee.all.order("name ASC").page(params[:page]).per_page(17)
    @error_messages = []
    @success_messages = []
    @name = params[:name].delete(" ")
    @percentage = params[:percentage]
    @fee = params[:fee]
    @fields = [[@name, "le nom du moyen de paiement", "@namecss"], [@fee, "le montant des frais de transport", "@feecss"]]
    @percentage.eql?("true") ? @percentage = true : @percentage = false
    
       
    if PaymentWayFee.find_by_name(@name).blank?
      @fields.each do |field|
        if field[0].blank?
          @error_messages << "Veuillez entrer #{field[1]}."
          my_container = field[2]
          instance_variable_set("#{my_container}", "row-form error")
          @error = true
        end
      end
    else
      @error = true
      @error_messages << "Ce moyen de paiement existe déjà"
    end
    
    if not_a_number?(@fee)
      @error = true
      @error_messages << "Le montant des frais de transport doit être numérique"
    end
    
    unless @error  
      @request = Typhoeus::Request.new(URI.escape("#{@@parameters.back_office_url}/payment_way_fee/create"), method: :get, params: { name: @name, percentage: @percentage, fee: @fee, authentication_token: @@parameters.emission_authentication_token  }, followlocation: true)
        
      @internal_com_request = "@response = request.response.body"     
      run_typhoeus_request(@request, @internal_com_request)  
      
      if @response == @@parameters.reception_authentication_token           
        PaymentWayFee.create(name: @name, percentage: @percentage, fee: @fee)
        
        params[:name] = params[:fee] = nil
        @success_messages << "Le moyen de paiement #{@name} été créé." 
      end
    end
  
    render :action => "index"
  end
  
  def edit
    @payment_way = PaymentWayFee.find_by_id(params[:id])
    @feecss = "row-form"
    @payment_ways = PaymentWayFee.all.order("name ASC").page(params[:page]).per_page(17)
    if @payment_way.blank?
      redirect_to wallets_path
    end
  end
      
  def update
    @error_messages = []
    @success_messages = []
    @feecss = "row-form"
    @payment_way = PaymentWayFee.find_by_id(params[:id])
    @payment_ways = PaymentWayFee.all.order("name ASC").page(params[:page]).per_page(17)
    @percentage = params[:percentage]
    @fee = params[:fee]
    
    if not_a_number?(@fee)
      @error = true
      @error_messages << "Le montant des frais de transport doit être numérique"
    end
    
    unless @error
      @request = Typhoeus::Request.new(URI.escape("#{@@parameters.back_office_url}/payment_way_fee/update"), method: :get, params: { id: @payment_way.id, fee: @fee, percentage: @percentage, authentication_token: @@parameters.emission_authentication_token  }, followlocation: true)
        
      @internal_com_request = "@response = request.response.body"     
      run_typhoeus_request(@request, @internal_com_request)  
      
      if @response == @@parameters.reception_authentication_token
        @payment_way.update_columns(fee: @fee, percentage: @percentage)        
        @success_messages << "Le moyen de paiement: #{@payment_way.name} a été mis à jour."
      else
        @error_messages << "Une erreur s'est produite, veuillez contacter l'administrateur." 
      end
    end    
    
    render :action => "edit"
  end
    
end
