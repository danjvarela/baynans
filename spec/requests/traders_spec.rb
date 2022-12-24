require "rails_helper"

RSpec.describe "Traders", type: :request do
  let(:user) do
    user = User.new(attributes_for(:user))
    user.skip_confirmation!
    user.save!
    user
  end

  let(:user_attributes) { attributes_for :user }

  before :each do
    sign_in user
  end

  describe "GET /admin/users" do
    it "should redirect to root path" do
      get users_path
      expect(response).to redirect_to root_path
    end
  end

  describe "POST /admin/users" do
    it "should redirect to root path" do
      post users_path, params: {user: user_attributes}
      expect(response).to redirect_to root_path
    end
  end

  describe "DELETE /admin/users" do
    it "should redirect to root path" do
      delete user_path(user)
      expect(response).to redirect_to root_path
    end
  end

  describe "PUT /admin/users" do
    it "should redirect to root path" do
      put user_path(user), params: {user: user_attributes}
      expect(response).to redirect_to root_path
    end
  end

  describe "POST /users/sign_in" do
    it "should redirect to root_path if signup status is pending" do
      post user_session_path, params: {user: user.attributes}
      expect(response).to redirect_to root_path
      expect(user.trading_status_pending?).to be true
    end
  end

  describe "GET /admin/notifications" do
    it "should redirect to root path" do
      get admin_notifications_path
      expect(response).to redirect_to root_path
    end
  end
end
