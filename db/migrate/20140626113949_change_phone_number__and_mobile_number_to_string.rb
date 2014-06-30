class ChangePhoneNumberAndMobileNumberToString < ActiveRecord::Migration
  def change
    change_column :users, :phone_number, :string
    change_column :users, :mobile_number, :string
  end
end
