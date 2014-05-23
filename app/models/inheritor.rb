class Inheritor < ActiveRecord::Base
  belongs_to :inheritor_type
  has_and_belongs_to_many :operation_types
  
  attr_accessible :name, :phone_number, :email, :address, :account_number, :inheritor_type_id, :published
end
