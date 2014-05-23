class ChangeInheritorTypeIdToIntegerInInheritors < ActiveRecord::Migration
  def change
    remove_column :inheritors, :inheritor_type_id
  end
end
