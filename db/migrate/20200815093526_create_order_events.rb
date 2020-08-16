class CreateOrderEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :order_events do |t|
      t.integer :event_type, null: false

      # order's data
      t.references :order # MEMO: the foreing-key setting stop cereting the event without order's id after destroying the order.
      t.integer :order_status, null: false

      t.timestamps
    end
  end
end
