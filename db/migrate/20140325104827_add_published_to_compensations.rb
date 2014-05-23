class AddPublishedToCompensations < ActiveRecord::Migration
  def change
    add_column :compensations, :published, :boolean
  end
end
