class Service < ActiveRecord::Base 
  belongs_to :compensation
  has_many :operation_types
attr_accessible :code, :name, :sales_area, :url_on_success, :url_to_ipn, :url_on_error, :url_on_session_expired, :url_on_hold_success, :url_on_hold_error, :url_on_hold_listener, :published, :url_on_basket_already_paid, :notified_to_hubs_front_office, :notified_to_hubs_back_office

  def disabled?
	  self.published.eql?(false) ? true : false
	end
	
	def has_operations_types?
	  self.operation_types.blank? ? false : true
	end
	
	def every_operation_type_has_inheritor?
	  @status = false
	  @operations = self.operation_types
	  if @operations.blank?
	    false
	  else
	    @operations.each do |operation|
	      
	    end
	  end
	  @status
	end

end
