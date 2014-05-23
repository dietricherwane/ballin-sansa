class AddPublishedToInheritorsTypes < ActiveRecord::Migration
  def change
    add_column :inheritor_types, :published, :boolean
  end
end
