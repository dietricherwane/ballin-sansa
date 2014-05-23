class CreateInheritorOperationTypeJoinTable < ActiveRecord::Migration
  def change
    create_table :inheritors_operation_types, :id => false do |t|
      t.integer :inheritor_id
      t.integer :operation_type_id
    end
  end
end
