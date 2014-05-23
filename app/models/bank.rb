class Bank < ActiveRecord::Base
  belongs_to :bank_type
  
  attr_accessible :name, :bank_type_id, :published
end
