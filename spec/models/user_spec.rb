require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  describe 'User type' do
    it 'should have a default value of `trader`' do
      created_user = user
      expect(created_user.trader?).to be true
    end
  end

  describe 'Trading status' do
    it 'should have a pending value by default if user is a trader' do
      created_user = user
      expect(created_user.trading_status_pending?).to be true
    end

    it 'should be approved by default if user is an admin' do
      created_user = create :user, { user_type: :admin }
      expect(created_user.trading_status_approved?).to be true
    end
  end
end
