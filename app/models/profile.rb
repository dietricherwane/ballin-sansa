class Profile < ActiveRecord::Base
  has_many :users

  attr_accessible :id, :name, :shortcut, :edit_profile, :create_profile, :view_transactions, :edit_wallet, :create_wallet, :edit_bank, :create_bank, :edit_inheritor, :create_inheritor, :edit_operation, :create_operation, :edit_service, :create_service, :edit_user_data, :create_user
end
