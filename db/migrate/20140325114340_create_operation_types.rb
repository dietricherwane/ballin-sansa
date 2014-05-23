class CreateOperationTypes < ActiveRecord::Migration
  def change
    create_table :operation_types do |t|
      t.string :name
      t.integer :service_id
      t.integer :credit_status

      t.timestamps
    end
  end
end
