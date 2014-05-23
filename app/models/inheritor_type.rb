class InheritorType < ActiveRecord::Base
  has_many :inheritors
  
  
  attr_accessible :label, :published
end
