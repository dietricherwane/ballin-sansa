class AddPublishedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :published, :boolean
  end
end
