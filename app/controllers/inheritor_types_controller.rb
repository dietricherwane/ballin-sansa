class InheritorTypesController < ApplicationController
  
  @@parameters = Parameter.first  
  @@url = "http://hub.com"
  
  before_filter :sign_out_disabled_users
  prepend_before_filter :authenticate_user!
  
  layout :layout_used
  
  def index
    @labelcss = "row-form"
    @inheritors_types = InheritorType.all.order("label ASC").page(params[:page]).per_page(17)
  end
  
  def create
    @labelcss = "row-form"
    @inheritors_types = InheritorType.all.order("label ASC").page(params[:page]).per_page(17)
    @error_messages = []
    @success_messages = []
    @label = params[:label]
    
    if @label.blank?
      @error = true
      @error_messages << "Veuillez entrer le nom du type d'ayant droit"
    end    
    unless InheritorType.find_by_label(@label).blank?
      @error = true
      @error_messages << "Ce type d'ayant droit existe déjà"
    end
    
    unless @error             
      InheritorType.create(label: @label)      
      params[:label] = nil
      @success_messages << "Le type d'ayant droit #{@label} a bien été créé." 
    end
  
    render :action => "index"
  end
  
  
end
