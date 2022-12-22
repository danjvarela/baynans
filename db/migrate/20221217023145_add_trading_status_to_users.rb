class AddTradingStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :trading_status, :integer, default: 0, null: false
  end
end
