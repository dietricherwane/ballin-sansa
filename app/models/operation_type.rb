class OperationType < ActiveRecord::Base
  belongs_to :service
  has_and_belongs_to_many :inheritors
  
  attr_accessible :name, :service_id, :credit_status, :comment, :published
  
  def disabled?
    published.eql?(false)
  end
  
end
