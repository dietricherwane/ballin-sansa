class CreateInheritorTypes < ActiveRecord::Migration
  def change
    create_table :inheritor_types do |t|
      t.string :label

      t.timestamps
    end
  end
end
