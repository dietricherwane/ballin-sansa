class BankTypesController < ApplicationController
  @@parameters = Parameter.first  
  @@url = "http://hub.com"
  
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def index
    @namecss = "row-form"
    @bank_types = BankType.all.order("name ASC").page(params[:page]).per_page(17)
  end
  
  def create
    @namecss = "row-form"
    @bank_types = BankType.all.order("name ASC").page(params[:page]).per_page(17)
    @error_messages = []
    @success_messages = []
    @name = params[:name]
    
    if @name.blank?
      @error = true
      @error_messages << "Veuillez entrer le nom du type de banque"
    end    
    unless BankType.find_by_name(@name).blank?
      @error = true
      @error_messages << "Ce type de banque existe déjà"
    end
    
    unless @error             
      BankType.create(name: @name)
      
      params[:name] = nil
      @success_messages << "Le type de banque #{@name} a bien été créé." 
    end
  
    render :action => "index"
  end
  
end
