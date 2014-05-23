class AddRightsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :create_user, :boolean
    add_column :profiles, :edit_user_data, :boolean
    add_column :profiles, :create_service, :boolean
    add_column :profiles, :edit_service, :boolean
    add_column :profiles, :create_operation, :boolean
    add_column :profiles, :edit_operation, :boolean
    add_column :profiles, :create_inheritor, :boolean
    add_column :profiles, :edit_inheritor, :boolean
    add_column :profiles, :create_bank, :boolean
    add_column :profiles, :edit_bank, :boolean
    add_column :profiles, :create_wallet, :boolean
    add_column :profiles, :edit_wallet, :boolean
    add_column :profiles, :view_transactions, :boolean
  end
end
