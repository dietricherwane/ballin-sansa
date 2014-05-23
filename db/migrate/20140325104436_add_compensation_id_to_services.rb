class AddCompensationIdToServices < ActiveRecord::Migration
  def change
    add_column :services, :compensation_id, :integer
  end
end
