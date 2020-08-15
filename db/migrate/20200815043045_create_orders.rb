class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
