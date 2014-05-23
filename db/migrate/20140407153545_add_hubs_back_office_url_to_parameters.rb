class AddHubsBackOfficeUrlToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :hubs_back_office, :string
  end
end
