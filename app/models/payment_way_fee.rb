class PaymentWayFee < ActiveRecord::Base
  attr_accessible :code, :name, :fee, :percentage, :published
end
