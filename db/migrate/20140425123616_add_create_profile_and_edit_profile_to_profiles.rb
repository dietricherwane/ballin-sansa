class AddCreateProfileAndEditProfileToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :create_profile, :boolean
    add_column :profiles, :edit_profile, :boolean
  end
end
