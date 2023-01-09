class AddUnitsToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :units, :float
  end
end
