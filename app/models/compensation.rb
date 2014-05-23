class Compensation < ActiveRecord::Base
  has_many :services
  attr_accessible :cuid, :label
end
