class CreatePaymentWays < ActiveRecord::Migration
  def change
    create_table :payment_ways do |t|
      t.string :name
      t.boolean :published

      t.timestamps
    end
  end
end
