class CreateCompensations < ActiveRecord::Migration
  def change
    create_table :compensations do |t|
      t.string :cuid
      t.string :label

      t.timestamps
    end
  end
end
