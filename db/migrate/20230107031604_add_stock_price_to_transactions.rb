class AddStockPriceToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :stock_price, :float, null: false
  end
end
