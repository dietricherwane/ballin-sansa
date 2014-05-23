class RenameInheritoTypeIdToInheritorTypeIdInInheritors < ActiveRecord::Migration
  def change
    rename_column :inheritors, :inherito_type_id, :inheritor_type_id
  end
end
