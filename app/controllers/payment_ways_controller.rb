class PaymentWaysController < ApplicationController
  @@parameters = Parameter.first  
  @@url = "http://hub.com"
  
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def index
    @namecss = @feecss = "row-form"
    @payment_ways = PaymentWay.all.order("name ASC").page(params[:page]).per_page(17)
  end  
  
  def create
    @namecss = "row-form"
    @payment_ways = PaymentWay.all.order("name ASC").page(params[:page]).per_page(17)
    @error_messages = []
    @success_messages = []
    @name = params[:name]
    @percentage = params[:percentage]
    @fee = params[:fee]
    @fields = [[@name, "le nom du moyen de paiement", "@namecss"], [@fee, "le montant des frais de transport", "@feecss"]]
    @percentage.eql?("true") ? @percentage = true : @percentage = false
    
       
    if PaymentWay.find_by_name(@name).blank?
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
      PaymentWay.create(name: @name, percentage: @percentage, fee: @fee)
      
      params[:name] = params[:fee] = nil
      @success_messages << "Le moyen de paiement #{@name} été créé." 
    end
  
    render :action => "index"
  end
  
end
