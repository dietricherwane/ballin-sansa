class AddPercentageToInheritorsOperationTypes < ActiveRecord::Migration
  def change
    add_column :inheritors_operation_types, :percentage, :float
  end
end
