class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :code
      t.string :name
      t.string :sales_area
      t.string :url_on_success
      t.string :url_on_error
      t.string :url_on_session_expired
      t.string :url_on_hold_success
      t.string :url_on_hold_error
      t.string :url_on_hold_listener
      t.boolean :published
      t.string :url_on_basket_already_paid
      t.boolean :notified_to_hubs_front_office
      t.boolean :notified_to_hubs_back_office

      t.timestamps
    end
  end
end
