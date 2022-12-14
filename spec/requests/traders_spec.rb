require "rails_helper"

RSpec.describe "Traders", type: :request do
  let(:user) { create :user }
  let(:user_attributes) { attributes_for :user }

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
      delete users_path
      expect(response).to redirect_to root_path
    end
  end

  describe "PUT /admin/users" do
    it "should redirect to root path" do
      put users_path, params: {user: user_attributes}
      expect(response).to redirect_to root_path
    end
  end
end
