require "rails_helper"

RSpec.describe "Pages", type: :request do
  let(:user) { create :user }

  before :each do
    sign_in user
  end

  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to be_successful
    end
  end
end
