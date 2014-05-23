class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :name
      t.integer :bank_type_id

      t.timestamps
    end
  end
end
