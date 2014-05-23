class BankType < ActiveRecord::Base
  has_many :banks
  
  attr_accessible :name
end
