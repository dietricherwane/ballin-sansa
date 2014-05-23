class CreateBankTypes < ActiveRecord::Migration
  def change
    create_table :bank_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
