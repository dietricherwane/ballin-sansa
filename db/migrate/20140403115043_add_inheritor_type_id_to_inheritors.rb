class AddInheritorTypeIdToInheritors < ActiveRecord::Migration
  def change
    add_column :inheritors, :inheritor_type_id, :integer
  end
end
