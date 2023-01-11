require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe 'Symbol' do
    it 'should be present' do
      stock = build :stock, symbol: nil
      expect(stock.save).to be false
    end
  end

  describe 'Company name' do
    it 'should be present' do
      stock = build :stock, company_name: nil
      expect(stock.save).to be false
    end
  end
end
