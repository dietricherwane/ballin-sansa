class AddPublishedToOperationTypes < ActiveRecord::Migration
  def change
    add_column :operation_types, :published, :boolean
  end
end
