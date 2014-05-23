class RenameHubsBackOfficeToHubsBackOfficeUrl < ActiveRecord::Migration
  def change
    rename_column :parameters, :hubs_back_office, :hubs_back_office_url
  end
end
