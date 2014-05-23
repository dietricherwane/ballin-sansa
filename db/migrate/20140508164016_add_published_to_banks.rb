class AddPublishedToBanks < ActiveRecord::Migration
  def change
    add_column :banks, :published, :boolean
  end
end
