class CreateInheritors < ActiveRecord::Migration
  def change
    create_table :inheritors do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.string :address
      t.string :account_number
      t.string :inherito_type_id

      t.timestamps
    end
  end
end
