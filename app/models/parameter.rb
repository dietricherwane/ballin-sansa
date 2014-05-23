class Parameter < ActiveRecord::Base
  attr_accessible :back_office_url, :emission_authentication_token, :reception_authentication_token
end
