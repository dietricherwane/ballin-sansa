class AddPublishedToBankTypes < ActiveRecord::Migration
  def change
    add_column :bank_types, :published, :boolean
  end
end
