require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) do
    user = build :user
    user.skip_confirmation!
    user.save!
    user
  end

  before :each do
    sign_in user
  end

  describe 'GET /user/:id/portfolio' do
    it 'should return http success' do
      get user_portfolio_path user
      expect(response).to be_successful
    end

    it 'should render the portfolio page' do
      get user_portfolio_path user
      expect(response).to render_template :portfolio
    end
  end
end
